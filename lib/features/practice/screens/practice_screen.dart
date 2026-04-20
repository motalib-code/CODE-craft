import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/practice_data.dart';
import '../../../data/company_data.dart';
import '../../../models/company.dart';
import '../../../models/dsa_pattern.dart';
import '../../../models/lc_problem.dart';
import '../../../services/gemini_service.dart';
import '../../../services/xp_service.dart';
import '../../../services/youtube_service.dart';
import 'company_detail_screen.dart';
import 'problem_detail_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String selectedCategory = 'Coding Practice';
  String selectedCompany = 'All Companies';
  String searchQuery = '';
  String selectedDifficulty = 'All';
  String selectedPhase = 'All';
  String selectedPattern = 'All';
  bool isVoiceListening = false;

  final TextEditingController _search = TextEditingController();
  final TextEditingController _companySearch = TextEditingController();
  final SpeechToText _speech = SpeechToText();
  final XPService _xpService = XPService();
  final PracticeGeminiService _gemini = PracticeGeminiService();
  final YouTubeService _youtube = YouTubeService();

  XPState _xpState = const XPState(
    totalXp: 0,
    streakDays: 0,
    lastSolvedDate: null,
    solvedIds: <int>[],
  );
  bool _loading = true;
  String? _error;
  String _companyTier = 'All';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _xpState = await _xpService.load();
      for (final p in allProblems) {
        p.isSolved = _xpState.solvedIds.contains(p.id);
      }
      await _speech.initialize();
      await Future<void>.delayed(const Duration(milliseconds: 450));
    } catch (e) {
      _error = 'Failed to load practice data. Tap retry.';
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  List<LCProblem> get filteredProblems {
    return allProblems.where((p) {
      final bool phaseOk = selectedPhase == 'All' || p.phase == selectedPhase;
      final bool diffOk = selectedDifficulty == 'All' || p.difficulty == selectedDifficulty;
      final bool patternOk = selectedPattern == 'All' || p.pattern == selectedPattern;
      final bool searchOk = searchQuery.isEmpty ||
          p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.id.toString().contains(searchQuery) ||
          p.topic.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.pattern.toLowerCase().contains(searchQuery.toLowerCase());
      return phaseOk && diffOk && patternOk && searchOk;
    }).toList();
  }

  Future<void> _toggleSolved(LCProblem p, bool solved) async {
    final XPState next = await _xpService.toggleSolved(
      problemId: p.id,
      difficulty: p.difficulty,
      current: _xpState,
      solved: solved,
    );
    final int gain = XPManager.xpForDifficulty(p.difficulty);
    final String oldBadge = XPManager.badgeForXP(_xpState.totalXp);
    final String newBadge = XPManager.badgeForXP(next.totalXp);

    setState(() {
      _xpState = next;
      p.isSolved = solved;
    });

    if (solved) {
      _showXpCelebration(gain);
    }
    if (oldBadge != newBadge && mounted) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E1550),
          title: const Text('Badge Upgraded', style: TextStyle(color: Colors.white)),
          content: Text('You unlocked $newBadge', style: const TextStyle(color: Colors.white70)),
        ),
      );
    }
  }

  void _showXpCelebration(int xp) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1550),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                  repeat: false,
                ),
              ),
              Text('+${xp} XP', style: const TextStyle(color: Color(0xFF6B5CE7), fontSize: 28, fontWeight: FontWeight.bold))
                  .animate()
                  .moveY(begin: 25, end: 0, duration: 600.ms)
                  .fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  int _xpForDiff(String diff) => XPManager.xpForDifficulty(diff);

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _startVoice() async {
    if (isVoiceListening) {
      await _speech.stop();
      setState(() => isVoiceListening = false);
      return;
    }

    final bool available = await _speech.initialize();
    if (!available) return;

    setState(() => isVoiceListening = true);
    await _speech.listen(
      listenFor: const Duration(seconds: 3),
      pauseFor: const Duration(seconds: 3),
      partialResults: false,
      onResult: (result) async {
        if (!result.finalResult) return;
        setState(() => isVoiceListening = false);
        final command = result.recognizedWords.toLowerCase().trim();
        await _handleVoiceCommand(command);
      },
    );
  }

  Future<void> _handleVoiceCommand(String command) async {
    if (command.startsWith('explain ')) {
      final concept = command.replaceFirst('explain ', '');
      final videos = await _youtube.searchConcept(concept);
      if (!mounted) return;
      _showVideosBottomSheet(videos, title: 'Explain: $concept');
      return;
    }

    if (command.startsWith('search ')) {
      final query = command.replaceFirst('search ', '');
      setState(() {
        searchQuery = query;
        _search.text = query;
      });
      return;
    }

    if (command.contains('show easy')) {
      setState(() => selectedDifficulty = 'Easy');
      return;
    }
    if (command.contains('show medium')) {
      setState(() => selectedDifficulty = 'Medium');
      return;
    }
    if (command.contains('show hard')) {
      setState(() => selectedDifficulty = 'Hard');
      return;
    }

    if (command.startsWith('open company ')) {
      final name = command.replaceFirst('open company ', '').trim();
      final company = companiesData.firstWhere(
        (c) => c.name.toLowerCase().contains(name),
        orElse: () => companiesData.first,
      );
      setState(() {
        selectedCategory = 'Company Wise';
        selectedCompany = company.name;
      });
      return;
    }

    setState(() {
      searchQuery = command;
      _search.text = command;
    });
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }

  void _openProblemDetail(LCProblem problem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProblemDetailScreen(problemSlug: problem.id.toString(), problem: problem),
      ),
    );
  }

  Future<void> _showAIExplanation(LCProblem problem) async {
    final explain = await _gemini.explainProblem(problem);
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1550),
        title: const Text('AI Explain', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Text(
            '${explain['whatAsked'] ?? ''}\n\nApproach: ${(explain['approach'] ?? []).toString()}\n\nTime: ${explain['timeComplexity'] ?? ''}\nSpace: ${explain['spaceComplexity'] ?? ''}',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  Future<void> _showProblemOptions(LCProblem problem) async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1550),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(problem.isSolved ? 'Mark as Unsolved' : 'Mark as Solved', style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _toggleSolved(problem, !problem.isSolved);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Color(0xFF6B5CE7)),
              title: Text(problem.isBookmarked ? 'Remove Bookmark' : 'Bookmark', style: const TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => problem.isBookmarked = !problem.isBookmarked);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new, color: Colors.orange),
              title: const Text('Open on LeetCode', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _open(problem.lcUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.smart_toy, color: Color(0xFF6B5CE7)),
              title: const Text('AI Explain', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showAIExplanation(problem);
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_circle, color: Colors.red),
              title: const Text('YouTube Solution', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                final vids = await _youtube.searchSolutions(problem);
                if (!mounted) return;
                _showVideosBottomSheet(vids, title: 'YouTube Solutions');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVideosBottomSheet(List<dynamic> videos, {required String title}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1550),
      isScrollControlled: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (_, i) {
                  final v = videos[i];
                  return ListTile(
                    title: Text(v.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(v.channelName, style: const TextStyle(color: Colors.white54)),
                    trailing: const Icon(Icons.open_in_new, color: Color(0xFF6B5CE7)),
                    onTap: () => _open(v.watchUrl),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int solvedToday = 0;
    final int totalSolved = allProblems.where((e) => e.isSolved).length;
    final int totalProblems = allProblems.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1033),
      body: SafeArea(
        child: _loading
            ? _buildLoading()
            : _error != null
                ? _buildError()
                : Column(
                    children: [
                      _buildHeader(solvedToday, totalSolved, totalProblems),
                      _buildSearchRow(),
                      _buildCategoryChips(),
                      const SizedBox(height: 10),
                      Expanded(child: _buildTabBody()),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFF1E1550),
        highlightColor: const Color(0xFF2D2070),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 84,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _init,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(int solvedToday, int totalSolved, int totalProblems) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Hello\nRahul Sharma', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1550),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.5)),
                ),
                child: Text('⚡ ${_xpState.totalXp}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text('🔥 ${_xpState.streakDays} day streak', style: const TextStyle(color: Colors.white70))),
              Expanded(child: Text('✅ $solvedToday/5 today', style: const TextStyle(color: Colors.white70))),
              Expanded(child: Text('📊 $totalSolved/$totalProblems total', style: const TextStyle(color: Colors.white70))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search problems, id, tags...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E1550),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _startVoice,
            style: IconButton.styleFrom(backgroundColor: const Color(0xFF1E1550)),
            icon: Icon(isVoiceListening ? Icons.mic : Icons.mic_none, color: const Color(0xFF6B5CE7)),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final chips = <String>['Coding Practice', 'Company Wise', 'DSA Sheet', 'Patterns', 'Resources', 'Weekly Plan'];
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: chips
            .map((c) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: selectedCategory == c,
                    onSelected: (_) => setState(() => selectedCategory = c),
                    selectedColor: const Color(0xFF6B5CE7),
                    backgroundColor: const Color(0xFF1E1550),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTabBody() {
    if (selectedCategory == 'Coding Practice') return _buildCodingPracticeTab();
    if (selectedCategory == 'Company Wise') return _buildCompanyWiseTab();
    if (selectedCategory == 'DSA Sheet') return _buildDsaSheetTab();
    if (selectedCategory == 'Patterns') return _buildPatternsTab();
    if (selectedCategory == 'Resources') return _buildResourcesTab();
    return _buildWeeklyPlanTab();
  }

  Widget _buildCodingPracticeTab() {
    final patterns = <String>{'All', ...allProblems.map((e) => e.pattern)}.toList();
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: ['All', 'Easy', 'Medium', 'Hard']
                .map((d) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: selectedDifficulty == d,
                        onSelected: (_) => setState(() => selectedDifficulty = d),
                        selectedColor: const Color(0xFF6B5CE7),
                        backgroundColor: const Color(0xFF1E1550),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: ['All', 'Phase 1', 'Phase 2', 'Phase 3', 'Phase 4', 'Phase 5']
                .map((p) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(p),
                        selected: selectedPhase == p,
                        onSelected: (_) => setState(() => selectedPhase = p),
                        selectedColor: const Color(0xFF6B5CE7),
                        backgroundColor: const Color(0xFF1E1550),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: patterns
                .take(20)
                .map((p) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(p),
                        selected: selectedPattern == p,
                        onSelected: (_) => setState(() => selectedPattern = p),
                        selectedColor: const Color(0xFF6B5CE7),
                        backgroundColor: const Color(0xFF1E1550),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProblems.length,
            itemBuilder: (_, i) {
              final problem = filteredProblems[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1550),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: problem.isSolved ? Colors.green.withOpacity(0.4) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: problem.isSolved ? Colors.green.withOpacity(0.2) : const Color(0xFF2D2070),
                    child: Text(
                      problem.id.toString().padLeft(problem.id > 99 ? 3 : 2, '0'),
                      style: TextStyle(
                        color: problem.isSolved ? Colors.green : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  title: Row(children: [
                    Expanded(
                      child: Text(problem.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    if (problem.isBookmarked) const Icon(Icons.bookmark, color: Color(0xFF6B5CE7), size: 16),
                  ]),
                  subtitle: Wrap(
                    spacing: 4,
                    children: [
                      if (problem.pattern.isNotEmpty) _chip(problem.pattern, const Color(0xFF6B5CE7).withOpacity(0.3)),
                      ...problem.companies.take(2).map((c) => _chip(c, Colors.orange.withOpacity(0.2))),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: problem.difficulty == 'Easy'
                              ? const Color(0xFF00B8A9)
                              : problem.difficulty == 'Medium'
                                  ? const Color(0xFFFFA116)
                                  : const Color(0xFFFF375F),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(problem.difficulty,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 4),
                      Text('+${_xpForDiff(problem.difficulty)} XP',
                          style: const TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  onTap: () => _openProblemDetail(problem),
                  onLongPress: () => _showProblemOptions(problem),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyWiseTab() {
    final String q = _companySearch.text.toLowerCase();
    final companies = companiesData.where((c) {
      final bool tierOk = _companyTier == 'All' || c.tier == _companyTier;
      final bool searchOk = q.isEmpty || c.name.toLowerCase().contains(q) || c.tier.toLowerCase().contains(q);
      return tierOk && searchOk;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _companySearch,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search company...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1E1550),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: ['All', 'FAANG', 'BigTech', 'Finance', 'Indian']
                .map((t) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(t == 'BigTech' ? 'Big Tech' : t),
                        selected: _companyTier == t,
                        onSelected: (_) => setState(() => _companyTier = t),
                        selectedColor: const Color(0xFF6B5CE7),
                        backgroundColor: const Color(0xFF1E1550),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemCount: companies.length,
            itemBuilder: (_, i) {
              final company = companies[i];
              final CompanyDSA? dsa = dsaProblemsSheet.where((e) => e.company.toLowerCase().contains(company.name.toLowerCase().split(' ').first)).isNotEmpty
                  ? dsaProblemsSheet.firstWhere((e) => e.company.toLowerCase().contains(company.name.toLowerCase().split(' ').first))
                  : null;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CompanyDetailScreen(
                        company: company,
                        tricks: dsa?.tricks ?? 'Practice arrays, strings, and dynamic programming.',
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1550),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.3)),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(company.logoEmoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 6),
                      Text(company.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _tierColor(company.tier),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(company.tier, style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                      const SizedBox(height: 4),
                      Text('${company.totalProblems}+ problems', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.code, color: Color(0xFF6B5CE7), size: 18),
                            onPressed: () => _open(company.problemsUrl),
                            tooltip: 'GitHub Problems',
                          ),
                          IconButton(
                            icon: const Icon(Icons.folder, color: Colors.orange, size: 18),
                            onPressed: () => _open(dsa?.driveUrl ?? resourcesData['DSA Problems Drive']!),
                            tooltip: 'Drive Sheet',
                          ),
                          IconButton(
                            icon: const Icon(Icons.map, color: Colors.green, size: 18),
                            onPressed: () => _open('https://roadmap.swadhin.cv'),
                            tooltip: 'FAANG Playbook',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDsaSheetTab() {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6B5CE7), Color(0xFF1E1550)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DSA Problems Sheet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const Text('Company-wise curated problems', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _actionButton('Drive', Colors.orange, () => _open(resourcesData['DSA Problems Drive']!)),
                  const SizedBox(width: 8),
                  _actionButton('Playbook', Colors.green, () => _open(resourcesData['FAANG Playbook Website']!)),
                  const SizedBox(width: 8),
                  _actionButton('Patterns', const Color(0xFF6B5CE7), () => setState(() => selectedCategory = 'Patterns')),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _smallResourceCard('50 DSA Tricks', resourcesData['DSA 50 Tricks Drive']!, Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _smallResourceCard('2000 HR Emails', resourcesData['2000 HR Emails Drive']!, Colors.green)),
              const SizedBox(width: 8),
              Expanded(child: _smallResourceCard('Internship Calendar', resourcesData['Internship Calendar']!, const Color(0xFF6B5CE7))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...dsaProblemsSheet.map((dsa) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E1550), borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(_companyEmoji(dsa.company), style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(dsa.company,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('💡 ${dsa.tricks}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  _actionButton('📁 Drive', Colors.orange, () => _open(dsa.driveUrl)),
                  const SizedBox(width: 8),
                  _actionButton('💻 GitHub', const Color(0xFF6B5CE7), () => _open(dsa.githubUrl)),
                  const SizedBox(width: 8),
                  _actionButton('🗺️ Playbook', Colors.green, () => _open(dsa.faangPlaybookUrl)),
                ]),
              ]),
            )),
      ],
    );
  }

  Widget _buildPatternsTab() {
    return ListView(
      children: dsaPatterns.map((pattern) => _patternCard(pattern)).toList(),
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Google Drive Resources', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _resourceCard('50 DSA Tricks', resourcesData['DSA 50 Tricks Drive']!, Colors.orange),
        _resourceCard('DSA Problems Sheet', resourcesData['DSA Problems Drive']!, Colors.blue),
        _resourceCard('2000 HR Emails', resourcesData['2000 HR Emails Drive']!, Colors.green),
        const SizedBox(height: 12),
        const Text('Interview Roadmaps', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _roadmapCard(),
        _resourceCard('Tech Interview Handbook', resourcesData['Tech Interview Handbook']!, const Color(0xFF6B5CE7)),
        _resourceCard('System Design Primer', resourcesData['System Design Primer']!, const Color(0xFF6B5CE7)),
        const SizedBox(height: 12),
        const Text('Opportunities', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _resourceCard('Internship Calendar', resourcesData['Internship Calendar']!, Colors.orange),
        _resourceCard('LeetCode Company Questions', resourcesData['LeetCode Company Questions']!, const Color(0xFF6B5CE7)),
        _resourceCard('Visor LeetCode', resourcesData['Visor LeetCode']!, const Color(0xFF6B5CE7)),
        const SizedBox(height: 18),
        const Text(
          '📊 LC Problems data taken from:\n'
          'github.com/snehasishroy/leetcode-companywise-interview-questions\n'
          'github.com/hitarth-gg/visor-leetcode',
          style: TextStyle(color: Colors.white38, fontSize: 10),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: () => _open(resourcesData['LeetCode Company Questions']!), child: const Text('Repo 1')),
            TextButton(onPressed: () => _open(resourcesData['Visor LeetCode']!), child: const Text('Repo 2')),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyPlanTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _weekCard(1, 'Foundation Mix', week1Ids),
        _weekCard(2, 'Intermediate Mix', week2Ids),
        _weekCard(3, 'Advanced Mix', week3Ids),
      ],
    );
  }

  Widget _weekCard(int number, String label, List<int> ids) {
    final weekProblems = allProblems.where((p) => ids.contains(p.id)).toList();
    final completedCount = weekProblems.where((p) => p.isSolved).length;
    final progress = weekProblems.isEmpty ? 0.0 : completedCount / weekProblems.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: const Color(0xFF1E1550), borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text('Week $number: $label', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white12,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B5CE7)),
        ),
        trailing: Text('$completedCount/${weekProblems.length}', style: const TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold)),
        children: weekProblems
            .map((p) => CheckboxListTile(
                  value: p.isSolved,
                  onChanged: (val) => _toggleSolved(p, val ?? false),
                  title: Text(p.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    p.difficulty,
                    style: TextStyle(
                      color: p.difficulty == 'Easy'
                          ? const Color(0xFF00B8A9)
                          : p.difficulty == 'Medium'
                              ? const Color(0xFFFFA116)
                              : const Color(0xFFFF375F),
                    ),
                  ),
                  secondary: Text('#${p.id}', style: const TextStyle(color: Colors.white38)),
                  activeColor: const Color(0xFF6B5CE7),
                ))
            .toList(),
      ),
    );
  }

  Color _tierColor(String tier) {
    switch (tier) {
      case 'FAANG':
        return Colors.red;
      case 'BigTech':
        return const Color(0xFF6B5CE7);
      case 'Finance':
        return Colors.green;
      case 'Indian':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _companyEmoji(String company) {
    final c = company.toLowerCase();
    if (c.contains('google')) return 'G';
    if (c.contains('microsoft')) return 'M';
    if (c.contains('amazon')) return 'A';
    if (c.contains('meta') || c.contains('facebook')) return 'M';
    if (c.contains('apple')) return 'A';
    return 'C';
  }

  Widget _smallResourceCard(String title, String url, Color color) {
    return InkWell(
      onTap: () => _open(url),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1550),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _actionButton(String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 11), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _patternCard(DSAPattern pattern) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF1E1550), borderRadius: BorderRadius.circular(14)),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6B5CE7).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(pattern.emoji, style: const TextStyle(fontSize: 20)),
          ),
          title: Text(pattern.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text('${pattern.keyProblems.length} key problems', style: const TextStyle(color: Colors.white54, fontSize: 12)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(pattern.timeComplexity, style: const TextStyle(color: Colors.green, fontSize: 11)),
              const Icon(Icons.chevron_right, color: Color(0xFF6B5CE7)),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('When to Use:', style: TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold)),
                  Text(pattern.whenToUse, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  const Text('Indicators:', style: TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 6,
                    children: pattern.indicators
                        .map((i) => Chip(
                              label: Text(i, style: const TextStyle(color: Colors.white, fontSize: 11)),
                              backgroundColor: const Color(0xFF2D2070),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Key Problems:', style: TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold)),
                  ...pattern.keyProblems.map((p) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.code, color: Color(0xFF6B5CE7), size: 16),
                        title: Text(p, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.play_circle, color: Colors.red),
                          label: const Text('Watch Videos', style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red.withOpacity(0.3))),
                          onPressed: () async {
                            final videos = await _youtube.searchConcept('${pattern.name} algorithm explained');
                            if (!mounted) return;
                            _showVideosBottomSheet(videos, title: '${pattern.name} videos');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.smart_toy),
                          label: const Text('AI Explain'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
                          onPressed: () async {
                            final e = await _gemini.explainPattern(pattern.name);
                            if (!mounted) return;
                            showDialog<void>(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: const Color(0xFF1E1550),
                                title: Text(pattern.name, style: const TextStyle(color: Colors.white)),
                                content: Text(e.toString(), style: const TextStyle(color: Colors.white70)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resourceCard(String title, String url, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: const Color(0xFF1E1550), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.25), child: Icon(Icons.link, color: color)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: TextButton(onPressed: () => _open(url), child: const Text('Open')),
      ),
    );
  }

  Widget _roadmapCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1E1550), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FAANG Playbook', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('85+ guides, 200+ companies, 1400+ LeetCode problems', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(onPressed: () => _open(resourcesData['FAANG Playbook Website']!), child: const Text('Website')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => _open(resourcesData['FAANG Playbook GitHub']!), child: const Text('GitHub')),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    _companySearch.dispose();
    _speech.stop();
    super.dispose();
  }
}


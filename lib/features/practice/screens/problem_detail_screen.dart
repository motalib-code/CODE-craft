import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/leetcode_problem.dart';
import '../../../models/youtube_video.dart';
import '../../../providers/problems_provider.dart';
import '../../../providers/xp_provider.dart';
import '../../../services/leetcode_service.dart';
import '../../../services/practice_gemini_service.dart';
import '../../../services/youtube_service.dart';
import '../../widgets/practice/video_card.dart';

class ProblemDetailScreen extends ConsumerStatefulWidget {
  final String problemSlug;

  const ProblemDetailScreen({
    super.key,
    required this.problemSlug,
  });

  @override
  ConsumerState<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends ConsumerState<ProblemDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LeetCodeProblem? _problem;
  bool _isLoading = true;
  Map<String, dynamic> _aiExplanation = {};
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProblem();
  }

  Future<void> _loadProblem() async {
    try {
      final problem = await LeetCodeService().fetchProblemDetail(widget.problemSlug);
      if (mounted) {
        setState(() {
          _problem = problem;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading problem: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadAIExplanation() async {
    if (_problem == null) return;
    try {
      final explanation = await PracticeGeminiService().explainProblem(
        title: _problem!.title,
        difficulty: _problem!.difficulty,
        tags: _problem!.tags,
      );
      if (mounted) {
        setState(() => _aiExplanation = explanation);
      }
      _showAIExplanationSheet();
    } catch (e) {
      print('Error getting AI explanation: $e');
    }
  }

  void _showAIExplanationSheet() {
    if (_aiExplanation.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, controller) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                children: [
                  Text('🎯 What\'s Asked',
                      style:
                          AppTextStyles.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(_aiExplanation['whatIsAsked'] ?? '',
                      style: AppTextStyles.body.copyWith(color: Colors.white70)),
                  const SizedBox(height: 20),
                  Text('💡 Approach',
                      style:
                          AppTextStyles.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(_aiExplanation['approach'] ?? '',
                      style: AppTextStyles.body.copyWith(color: Colors.white70)),
                  const SizedBox(height: 20),
                  Text('🛠️ Data Structure/Algorithm',
                      style:
                          AppTextStyles.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_aiExplanation['dataStructure'] ?? '',
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.purple)),
                  ),
                  const SizedBox(height: 20),
                  Text('⏱️ Complexity',
                      style:
                          AppTextStyles.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Time:',
                                style: TextStyle(color: Colors.white70)),
                            Text(_aiExplanation['timeComplexity'] ?? '',
                                style: AppTextStyles.h3
                                    .copyWith(color: AppColors.purple)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Space:',
                                style: TextStyle(color: Colors.white70)),
                            Text(_aiExplanation['spaceComplexity'] ?? '',
                                style: AppTextStyles.h3
                                    .copyWith(color: AppColors.purple)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('⚠️ Common Mistakes',
                      style:
                          AppTextStyles.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  ...((_aiExplanation['commonMistakes'] as List?) ?? [])
                      .map((mistake) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Text('•',
                                    style:
                                        TextStyle(color: Colors.red, fontSize: 20)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(mistake,
                                      style: AppTextStyles.body.copyWith(
                                          color: Colors.white70)),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markAsSolved() {
    if (_problem == null) return;

    final xpNotifier = ref.read(xpProvider.notifier);
    xpNotifier.addXP(_problem!.xpReward);

    ref.read(solvedProblemsProvider.notifier).markAsSolved(_problem!.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('+${_problem!.xpReward} XP earned! 🎉'),
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() => _isSolved = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(backgroundColor: AppColors.bg),
        body: Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    if (_problem == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(backgroundColor: AppColors.bg),
        body: const Center(
          child: Text('Problem not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: Text(_problem!.title, style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Difficulty and tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(_problem!.difficulty),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _problem!.difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _problem!.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: AppColors.purple
                                  .withOpacity(0.2),
                              labelStyle:
                                  const TextStyle(color: AppColors.purple),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('✅ ${_problem!.acceptanceRate.toStringAsFixed(1)}%',
                          style: AppTextStyles.body
                              .copyWith(color: Colors.white70)),
                      const SizedBox(width: 16),
                      Text('❤️ ${_problem!.likes}',
                          style: AppTextStyles.body
                              .copyWith(color: Colors.white70)),
                      const SizedBox(width: 16),
                      Text('👎 ${_problem!.dislikes}',
                          style: AppTextStyles.body
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.description), text: 'Problem'),
                Tab(icon: Icon(Icons.school), text: 'Learn'),
              ],
              indicatorColor: AppColors.purple,
              labelColor: AppColors.purple,
              unselectedLabelColor: Colors.white38,
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Problem tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Problem Description',
                            style: AppTextStyles.h2),
                        const SizedBox(height: 12),
                        Text(_problem!.content ?? 'Description not available',
                            style: AppTextStyles.body
                                .copyWith(color: Colors.white70)),
                        const SizedBox(height: 24),
                        if (_problem!.exampleTestcases != null &&
                            _problem!.exampleTestcases!.isNotEmpty) ...[
                          Text('Examples', style: AppTextStyles.h2),
                          const SizedBox(height: 12),
                          ..._problem!.exampleTestcases!
                              .map((example) => Container(
                                    padding: const EdgeInsets.all(12),
                                    margin:
                                        const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D2070),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      example,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  )),
                        ],
                        const SizedBox(height: 24),
                        // Action buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('AI Explain This Problem'),
                            onPressed: _loadAIExplanation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_circle_fill),
                            label: const Text('Watch Solution on YouTube'),
                            onPressed: () async {
                              final videos = await YouTubeService()
                                  .searchSolutionVideos(
                                      _problem!.title);
                              if (videos.isNotEmpty) {
                                _showVideosSheet(videos);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.2),
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _markAsSolved,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                                  .withOpacity(_isSolved ? 0.5 : 1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                            child: Text(
                              _isSolved
                                  ? '✅ Marked as Solved'
                                  : '✅ Mark as Solved',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Learn tab
                  FutureBuilder<List<YouTubeVideo>>(
                    future: YouTubeService()
                        .searchConceptVideos(
                            _problem!.tags.first),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      final videos = snapshot.data!;
                      return ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) => VideoCard(
                          video: videos[index],
                          onTap: () async {
                            final url = Uri.parse(
                                videos[index].watchUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideosSheet(List<YouTubeVideo> videos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, controller) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_fill, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Video Explanations',
                      style: AppTextStyles.h2.copyWith(color: Colors.white)),
                  const Spacer(),
                  Text('${videos.length} videos',
                      style:
                          AppTextStyles.small.copyWith(
                              color: Colors.white54)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: videos.length,
                itemBuilder: (_, i) => VideoCard(
                  video: videos[i],
                  onTap: () async {
                    final url = Uri.parse(videos[i].watchUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return const Color(0xFF00B8A9);
      case 'Medium':
        return const Color(0xFFFFA116);
      case 'Hard':
        return const Color(0xFFFF375F);
      default:
        return AppColors.purple;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

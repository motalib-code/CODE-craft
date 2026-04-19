import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../models/algo_topic.dart';
import '../../../models/dbms_topic.dart';
import '../../../models/leetcode_problem.dart';
import '../../../models/youtube_video.dart';
import '../../../providers/problems_provider.dart';
import '../../../providers/xp_provider.dart';
import '../../../providers/voice_provider.dart';
import '../../../services/leetcode_service.dart';
import '../../../services/youtube_service.dart';
import '../../widgets/practice/problem_card.dart';
import '../../widgets/practice/video_card.dart';
import '../../widgets/practice/voice_button.dart';
import '../../widgets/practice/algo_topic_card.dart';
import '../../../models/continue_learning.dart';
import '../../widgets/practice/continue_learning_card.dart';
import '../../auth/notifiers/auth_notifier.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  late TextEditingController _searchController;
  String _selectedCategory = 'Coding Practice';
  bool _isLoadingProblems = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadInitialProblems();
  }

  Future<void> _loadInitialProblems() async {
    setState(() => _isLoadingProblems = true);
    await ref.read(problemsProvider.notifier).fetchProblems();
    setState(() => _isLoadingProblems = false);
  }

  void _handleVoiceCommand(String command) {
    command = command.toLowerCase().trim();

    // "explain binary search" → show concept detail
    if (command.startsWith('explain ')) {
      String concept = command.substring(8);
      // TODO: Navigate to concept detail screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searching for: $concept')),
      );
      return;
    }

    // "search two sum" → filter problems
    if (command.startsWith('search ')) {
      String query = command.substring(7);
      _searchController.text = query;
      ref.read(searchQueryProvider.notifier).state = query;
      return;
    }

    // Filter by difficulty
    if (command.contains('easy')) {
      ref.read(difficultyFilterProvider.notifier).state = 'Easy';
      return;
    }
    if (command.contains('medium')) {
      ref.read(difficultyFilterProvider.notifier).state = 'Medium';
      return;
    }
    if (command.contains('hard')) {
      ref.read(difficultyFilterProvider.notifier).state = 'Hard';
      return;
    }

    // Switch tabs
    if (command.contains('algorithm')) {
      setState(() => _selectedCategory = 'Algorithms');
      return;
    }
    if (command.contains('data structure')) {
      setState(() => _selectedCategory = 'Data Structures');
      return;
    }
    if (command.contains('database') || command.contains('sql')) {
      setState(() => _selectedCategory = 'DBMS');
      return;
    }

    // Default: search
    _searchController.text = command;
    ref.read(searchQueryProvider.notifier).state = command;
  }

  @override
  Widget build(BuildContext context) {
    final xp = ref.watch(xpProvider);
    final streak = ref.watch(streakProvider);
    final rank = ref.watch(rankProvider);
    final isListening = ref.watch(voiceProvider);
    final filteredProblems = ref.watch(filteredProblemsProvider);
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════ HEADER ═══════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + XP badge
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello',
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textHint)),
                          Text(userData.value?.name ?? 'Coder',
                              style: AppTextStyles.h2),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.purple),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text('$xp XP',
                                style: AppTextStyles.small.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Streak + Rank info
                  Row(
                    children: [
                      Text('🔥 $streak day streak',
                          style: AppTextStyles.body
                              .copyWith(color: Colors.amber)),
                      const SizedBox(width: 16),
                      Text('✅ Solved Today',
                          style: AppTextStyles.body
                              .copyWith(color: Colors.green)),
                      const SizedBox(width: 16),
                      Text('🏆 Rank #$rank',
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.purple)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ═══════════════════ SEARCH BAR WITH VOICE ═══════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          ref
                              .read(searchQueryProvider.notifier)
                              .state = value;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search problems, topics...',
                          hintStyle: AppTextStyles.body
                              .copyWith(color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.textHint, size: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  VoiceButton(
                    isListening: isListening,
                    onPressed: () {
                      final voiceNotifier =
                          ref.read(voiceProvider.notifier);
                      voiceNotifier.toggleListening((text) {
                        _handleVoiceCommand(text);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ═══════════════════ CATEGORY CHIPS ═══════════════════
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: [                  'Continue Learning',                  'Coding Practice',
                  'Algorithms',
                  'Data Structures',
                  'DBMS',
                  'System Design',
                ]
                    .map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategory = cat);
                              ref
                                  .read(
                                      categoryProvider.notifier)
                                  .state = cat;
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedCategory ==
                                        cat
                                    ? AppColors.purple
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: _selectedCategory == cat
                                    ? null
                                    : Border.all(
                                        color:
                                            AppColors.border),
                              ),
                              child: Text(
                                cat,
                                style:
                                    AppTextStyles.small
                                        .copyWith(
                                  color: _selectedCategory ==
                                          cat
                                      ? Colors.white
                                      : AppColors
                                          .textHint,
                                  fontWeight: _selectedCategory ==
                                          cat
                                      ? FontWeight.bold
                                      : FontWeight
                                          .normal,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ═══════════════════ CONTENT AREA ═══════════════════
            Expanded(
              child: _selectedCategory == 'Continue Learning'
                  ? _buildContinueLearningSection()
                  : _buildCategoryContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    if (_selectedCategory == 'Coding Practice') {
      return _buildCodingPracticeContent();
    } else if (_selectedCategory == 'Algorithms') {
      return _buildAlgorithmsContent();
    } else if (_selectedCategory == 'Data Structures') {
      return _buildDataStructuresContent();
    } else if (_selectedCategory == 'DBMS') {
      return _buildDBMSContent();
    } else {
      return const Center(
        child: Text('Coming Soon!',
            style: TextStyle(color: Colors.white70)),
      );
    }
  }

  Widget _buildContinueLearningSection() {
    final learningContent = getAllLearningContent();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('📚 Continue Learning', style: AppTextStyles.h2),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _selectedCategory = 'Coding Practice'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...learningContent.map((content) => ContinueLearningCard(
                title: content.title,
                category: content.category,
                videoId: content.videoId,
                thumbnail: content.thumbnail,
                channelName: content.channelName,
                onTap: () async {
                  final url = Uri.parse(content.watchUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              )),
          const SizedBox(height: 24),
          // Category shortcuts
          Text('Learning Paths', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showLearningCategory('DSA');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B5CE7).withOpacity(0.2),
                      border: Border.all(color: const Color(0xFF6B5CE7)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('💻 DSA', style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text('${dsaLearningContent.length} courses',
                            style: AppTextStyles.small),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showLearningCategory('AI');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withOpacity(0.2),
                      border: Border.all(color: const Color(0xFFFF6B6B)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('🤖 AI', style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text('${aiLearningContent.length} courses',
                            style: AppTextStyles.small),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showLearningCategory('ML');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.2),
                      border: Border.all(color: const Color(0xFF4ECDC4)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('📊 ML', style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text('${mlLearningContent.length} courses',
                            style: AppTextStyles.small),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showLearningCategory(String category) {
    final content = getLearningByCategory(category);

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
                  Text(
                    category == 'DSA'
                        ? '💻 DSA Courses'
                        : category == 'AI'
                            ? '🤖 AI Courses'
                            : '📊 ML Courses',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  Text('${content.length} courses',
                      style:
                          AppTextStyles.small.copyWith(color: Colors.white54)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: content.length,
                itemBuilder: (_, i) => ContinueLearningCard(
                  title: content[i].title,
                  category: content[i].category,
                  videoId: content[i].videoId,
                  thumbnail: content[i].thumbnail,
                  channelName: content[i].channelName,
                  onTap: () async {
                    final url = Uri.parse(content[i].watchUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                      Navigator.pop(context);
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

  Widget _buildCodingPracticeContent() {
    final filteredProblems =
        ref.watch(filteredProblemsProvider);
    final solvedProblems = ref.watch(solvedProblemsProvider);

    if (_isLoadingProblems) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (filteredProblems.isEmpty) {
      return const Center(
        child: Text('No problems found',
            style: TextStyle(color: Colors.white70)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty filters
          Row(
            children: [
              Text('Filter by Difficulty',
                  style: AppTextStyles.h3),
              const Spacer(),
              ..._buildDifficultyChips(),
            ],
          ),
          const SizedBox(height: 16),
          // Problem list
          ...filteredProblems.asMap().entries.map((entry) {
            final index = entry.key;
            final problem = entry.value;
            final isSolved =
                solvedProblems.contains(problem.id);
            return FadeInUp(
              delay: Duration(milliseconds: index * 50),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProblemCard(
                  problem: problem,
                  isSolved: isSolved,
                  onTap: () => context.push(
                    '/practice/problem/${problem.titleSlug}',
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAlgorithmsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: algorithmTopics
            .map((topic) => AlgoTopicCard(
                  topic: topic,
                  onSubtopicTap: (subtopic) {
                    _handleVoiceCommand('explain $subtopic');
                  },
                  onGFGTap: () async {
                    if (await canLaunchUrl(
                        Uri.parse(topic.gfgUrl))) {
                      await launchUrl(Uri.parse(
                          topic.gfgUrl));
                    }
                  },
                  onVideosTap: () async {
                    final videos = await YouTubeService()
                        .searchConceptVideos(topic.name);
                    if (mounted && videos.isNotEmpty) {
                      _showVideosSheet(videos);
                    }
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDataStructuresContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: dataStructureTopics
            .map((topic) => Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1550),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Text(
                      topic.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      topic.name,
                      style: AppTextStyles.h3
                          .copyWith(color: Colors.white),
                    ),
                    trailing: Text(
                      '${topic.problems.length} problems',
                      style: AppTextStyles.small
                          .copyWith(color: Colors.white54),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: topic.problems
                                  .map((problem) =>
                                  ActionChip(
                                    label: Text(
                                      problem,
                                      style: const TextStyle(
                                          color: Colors
                                              .white),
                                    ),
                                    backgroundColor:
                                        const Color(
                                            0xFF2D2070),
                                    onPressed: () {
                                      ref
                                          .read(searchQueryProvider
                                              .notifier)
                                          .state =
                                          problem;
                                    },
                                  ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                if (await canLaunchUrl(
                                    Uri.parse(
                                        topic.gfgUrl))) {
                                  await launchUrl(Uri
                                      .parse(topic
                                          .gfgUrl));
                                }
                              },
                              child: const Text(
                                  'Learn More'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDBMSContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: dbmsTopics
            .map((topic) => Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1550),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Text(
                      topic.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      topic.name,
                      style: AppTextStyles.h3
                          .copyWith(color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Concepts',
                                style: AppTextStyles.h3),
                            const SizedBox(
                                height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: topic.concepts
                                  .map((concept) =>
                                  ActionChip(
                                    label: Text(
                                      concept,
                                      style: const TextStyle(
                                          color: Colors
                                              .white),
                                    ),
                                    backgroundColor:
                                        const Color(
                                            0xFF2D2070),
                                    onPressed: () {
                                      _handleVoiceCommand(
                                          'explain $concept');
                                    },
                                  ))
                                  .toList(),
                            ),
                            if (topic.sqlProblems
                                .isNotEmpty) ...[
                              const SizedBox(
                                  height: 16),
                              Text('Practice Problems',
                                  style:
                                      AppTextStyles
                                          .h3),
                              const SizedBox(
                                  height: 8),
                              ...topic.sqlProblems
                                  .map((problem) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                            vertical:
                                                4),
                                    child: Text(
                                      '• ${problem.title}',
                                      style: AppTextStyles
                                          .body
                                          .copyWith(
                                          color: Colors
                                              .white70),
                                    ),
                                  )),
                            ],
                            const SizedBox(
                                height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                if (await canLaunchUrl(
                                    Uri.parse(
                                        topic.gfgUrl))) {
                                  await launchUrl(Uri
                                      .parse(topic
                                          .gfgUrl));
                                }
                              },
                              child: const Text(
                                  'Learn on GFG'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  List<Widget> _buildDifficultyChips() {
    final selectedFilter =
        ref.watch(difficultyFilterProvider);
    return ['All', 'Easy', 'Medium', 'Hard']
        .map((difficulty) => Padding(
              padding:
                  const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(
                          difficultyFilterProvider
                              .notifier)
                      .state = difficulty;
                },
                child: Text(
                  difficulty,
                  style: AppTextStyles.small
                      .copyWith(
                    color: selectedFilter ==
                            difficulty
                        ? AppColors.purple
                        : AppColors.textHint,
                    fontWeight: selectedFilter ==
                            difficulty
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ))
        .toList();
  }

  void _showVideosSheet(List<YouTubeVideo> videos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
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
                  const Icon(Icons.play_circle_fill,
                      color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Video Explanations',
                      style: AppTextStyles.h2
                          .copyWith(color: Colors.white)),
                  const Spacer(),
                  Text('${videos.length} videos',
                      style: AppTextStyles.small
                          .copyWith(
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
                    final url =
                        Uri.parse(videos[i].watchUrl);
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../services/notification_service.dart';
import '../../../screens/mock_interview_setup_screen.dart';
import '../../../screens/jobs_screen.dart';
import '../../../screens/news_screen.dart';
import '../../../screens/smart_insights_screen.dart';
import '../../../screens/resume_checker_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/points_badge.dart';
import '../../../core/utils/helpers.dart';
import '../notifiers/home_notifier.dart';
import '../../auth/notifiers/auth_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.startNewsPolling(
        onNewArticle: (_) {
          if (mounted) setState(() {});
        },
        interval: const Duration(hours: 2),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final home = ref.watch(homeNotifierProvider);
    final userData = ref.watch(userDataProvider);
    final userName = userData.value?.name ?? 'Rahul';
    const points = '1.2k';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple.withOpacity(0.08),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ── Top Bar ──────────────────────────────
                  FadeInDown(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.bgSurface,
                          child: Icon(Icons.person, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        Text('CodeCraft', style: AppTextStyles.h2),
                        const Spacer(),
                        const PointsBadge(points: '1.2k'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Greeting ──────────────────────────
                  FadeInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hey $userName!', style: AppTextStyles.h1),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.gradPurpleBlue.createShader(bounds),
                          child: Text('ready to code?', style: AppTextStyles.h2.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(height: 12),
                        Text('Your journey to mastery continues today.', style: AppTextStyles.body),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  FadeInUp(
                    delay: const Duration(milliseconds: 120),
                    child: _buildQuickActionGrid(context),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 80),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.assistant, color: AppColors.purple),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Open Portfolio & Career Assistant',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.push('/career-assistant'),
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Streak Card ──────────────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CURRENT STREAK', style: AppTextStyles.small.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('${home.streak.toString().padLeft(2, '0')} Days', style: AppTextStyles.display.copyWith(fontSize: 40)),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                                    bool isActive = day == 'Sun'; // Dummy check
                                    return Column(
                                      children: [
                                        Text(day, style: AppTextStyles.small.copyWith(fontSize: 10)),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 32,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: isActive ? AppColors.purple : AppColors.bgInput,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text('🔥', style: TextStyle(fontSize: 32)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Daily Challenge ──────────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.mint.withOpacity(0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mint.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('DAILY CHALLENGE', style: AppTextStyles.small.copyWith(color: AppColors.mint, fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                  const Spacer(),
                                  Text('Ends in 14h 22m', style: AppTextStyles.small),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('Two Sum', style: AppTextStyles.h1.copyWith(fontSize: 28)),
                              const SizedBox(height: 12),
                              Text(
                                'Given an array of integers nums and an integer target, return indices of the two numbers...',
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  label: 'Solve Challenge',
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Stats Row ──────────────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Row(
                      children: [
                        _StatItem(label: 'SOLVED', value: '${home.solved}'),
                        _StatItem(label: 'GLOBAL RANK', value: '#${home.rank}'),
                        _StatItem(label: 'ACCURACY', value: '${home.accuracy}%'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Continue Learning ──────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Continue Learning', style: AppTextStyles.h2),
                        Text('View Roadmap', style: AppTextStyles.small.copyWith(color: AppColors.purple)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 450),
                    child: SizedBox(
                      height: 240,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _ContinueLearningCard(
                            title: 'Segment Trees & Fenwick',
                            subtitle: 'ADVANCED DATA STRUCTURES',
                            progress: 0.65,
                            lessonsLeft: 4,
                            imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=500&q=80',
                          ),
                          _ContinueLearningCard(
                            title: 'Microservices with Node.js',
                            subtitle: 'BACKEND ARCHITECTURE',
                            progress: 0.20,
                            lessonsLeft: 12,
                            imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=500&q=80',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h2.copyWith(fontSize: 22)),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.small.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

Widget _buildQuickActionGrid(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          _buildQuickActionCard(
            '🎤', 'Mock Interview', 'Practice DSA & behavioral',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockInterviewSetupScreen())),
          ),
          const SizedBox(width: 12),
          _buildQuickActionCard(
            '📄', 'Resume Check', 'AI review & tips',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeCheckerScreen())),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          _buildQuickActionCard(
            '💼', 'Jobs', 'Remote + startup roles',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen())),
          ),
          const SizedBox(width: 12),
          _buildQuickActionCard(
            '📰', 'News', 'Tech & career updates',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          _buildQuickActionCard(
            '📊', 'Insights', 'Growth scorecards',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartInsightsScreen())),
          ),
          const SizedBox(width: 12),
          _buildQuickActionCard(
            '🗺️', 'Roadmap', 'Plan your next steps',
            () => context.push('/roadmap'),
          ),
        ],
      ),
    ],
  );
}

Widget _buildQuickActionCard(
  String emoji,
  String label,
  String subtitle,
  VoidCallback onTap,
) {
  return Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1550),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    ),
  );
}

class _ContinueLearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int lessonsLeft;
  final String imageUrl;

  const _ContinueLearningCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.lessonsLeft,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtitle, style: AppTextStyles.small.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
                  const SizedBox(height: 8),
                  Text(title, style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.bgInput,
                    valueColor: const AlwaysStoppedAnimation(AppColors.purple),
                    minHeight: 4,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${(progress * 100).toInt()}% Complete', style: AppTextStyles.small),
                      const Spacer(),
                      Text('$lessonsLeft Lessons left', style: AppTextStyles.small),
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
}


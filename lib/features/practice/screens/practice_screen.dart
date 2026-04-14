import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../core/widgets/diff_badge.dart';
import '../../../core/widgets/points_badge.dart';
import '../notifiers/practice_notifier.dart';
import '../../auth/notifiers/auth_notifier.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practice = ref.watch(practiceNotifierProvider);
    final notifier = ref.read(practiceNotifierProvider.notifier);
    final filtered = practice.filteredProblems;
    final userData = ref.watch(userDataProvider);
    
    final categories = ['Coding Practice', 'Algorithms', 'Data Structures', 'DBMS', 'OS'];
    final filters = ['All', 'Easy', 'Medium', 'Hard'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello', style: AppTextStyles.body.copyWith(color: AppColors.textHint)),
                      Text(userData.value?.name ?? 'Rahul Sharma', style: AppTextStyles.h2),
                    ],
                  ),
                  const Spacer(),
                  const PointsBadge(points: '1.2k', icon: Icons.bolt),
                ],
              ),
            ),

            // ── Search & Filter ──────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  onChanged: notifier.setSearch,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search problems, topics...',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Categories ──────────────────────────
            SizedBox(
              height: 40,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  bool isSelected = index == 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.purple : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected ? null : Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        cat,
                        style: AppTextStyles.small.copyWith(
                          color: isSelected ? Colors.white : AppColors.textHint,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Featured Card ──────────────────────
                    Text('Recommended For You', style: AppTextStyles.h2),
                    const SizedBox(height: 16),
                    _FeaturedProblemCard(
                      title: 'Dynamic Programming',
                      subtitle: 'Master optimization techniques',
                      difficulty: 'Hard',
                      acceptance: '45.2%',
                      imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80',
                    ),
                    const SizedBox(height: 32),

                    // ── Complexity Filter ──────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Problems', style: AppTextStyles.h2),
                        Row(
                          children: filters.map((f) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: GestureDetector(
                              onTap: () => notifier.setFilter(f),
                              child: Text(
                                f,
                                style: AppTextStyles.small.copyWith(
                                  color: practice.selectedFilter == f ? AppColors.blue : AppColors.textHint,
                                  fontWeight: practice.selectedFilter == f ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Problem List ──────────────────────
                    ...filtered.asMap().entries.map((entry) {
                      final i = entry.key;
                      final problem = entry.value;
                      return FadeInUp(
                        delay: Duration(milliseconds: i * 50),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassCard(
                            onTap: () => context.push('/code-editor/${problem.id}'),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.code, color: AppColors.purple, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(problem.title, style: AppTextStyles.h3),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.people_outline, color: AppColors.textHint, size: 12),
                                          const SizedBox(width: 4),
                                          Text('125.4k solved', style: AppTextStyles.small.copyWith(fontSize: 10)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _DifficultyBadge(difficulty: problem.difficulty),
                                    const SizedBox(height: 4),
                                    Text('+${problem.coins} XP', style: AppTextStyles.small.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProblemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String difficulty;
  final String acceptance;
  final String imageUrl;

  const _FeaturedProblemCard({
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.acceptance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _DifficultyBadge(difficulty: difficulty),
                const SizedBox(width: 8),
                Text('$acceptance Acceptance', style: AppTextStyles.small.copyWith(color: Colors.white70)),
              ],
            ),
            const Spacer(),
            Text(title, style: AppTextStyles.display.copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.body.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = difficulty == 'Hard' 
      ? AppColors.red 
      : difficulty == 'Medium' 
        ? AppColors.orange 
        : AppColors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        difficulty,
        style: AppTextStyles.small.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}

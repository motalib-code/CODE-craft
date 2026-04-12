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
import '../../../core/widgets/coin_badge.dart';
import '../notifiers/practice_notifier.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practice = ref.watch(practiceNotifierProvider);
    final notifier = ref.read(practiceNotifierProvider.notifier);
    final filtered = practice.filteredProblems;
    final filters = ['All', 'Easy', 'Medium', 'Hard'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: FadeInDown(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      text: '💻 Practice',
                      style: AppTextStyles.h1,
                    ),
                    // Semantic Search Toggle
                    Row(
                      children: [
                        Text('AI Search', style: AppTextStyles.small.copyWith(color: practice.isSemanticSearch ? AppColors.purple : AppColors.textHint)),
                        const SizedBox(width: 4),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: practice.isSemanticSearch,
                            onChanged: notifier.toggleSemanticSearch,
                            activeThumbColor: AppColors.purple,
                            activeTrackColor: AppColors.purple.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: TextField(
                  onChanged: notifier.setSearch,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: practice.isSemanticSearch ? 'Describe concept (e.g. "array addition")' : 'Search problems...',
                    prefixIcon: Icon(
                      practice.isSemanticSearch ? Icons.auto_awesome : Icons.search,
                      color: practice.isSemanticSearch ? AppColors.purple : AppColors.textHint,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.bgInput,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInDown(
                delay: const Duration(milliseconds: 150),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filters.map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TagChip(
                          label: f,
                          selected: practice.selectedFilter == f,
                          onTap: () => notifier.setFilter(f),
                          color: f == 'Easy'
                              ? AppColors.green
                              : f == 'Medium'
                                  ? AppColors.orange
                                  : f == 'Hard'
                                      ? AppColors.red
                                      : AppColors.purple,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Loading / Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeIn(
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} problems',
                      style: AppTextStyles.small,
                    ),
                    if (practice.isLoading) ...[
                      const SizedBox(width: 12),
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.purple),
                      ),
                      const SizedBox(width: 8),
                      Text('Searching with AI...', style: AppTextStyles.small.copyWith(color: AppColors.purple)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Problem list
            Expanded(
              child: filtered.isEmpty && !practice.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🔍',
                              style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text('No problems found',
                              style: AppTextStyles.h3),
                          const SizedBox(height: 4),
                          Text('Try a different filter or search',
                              style: AppTextStyles.body),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final problem = filtered[i];
                        return FadeInUp(
                          delay: Duration(milliseconds: i * 50),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              onTap: () => context
                                  .push('/code-editor/${problem.id}'),
                              child: Row(
                                children: [
                                  // Number
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.bgInput,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: AppTextStyles.h3
                                            .copyWith(
                                                fontSize: 13,
                                                color: AppColors
                                                    .textSecondary),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(problem.title,
                                            style: AppTextStyles.h3
                                                .copyWith(
                                                    fontSize: 14)),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          spacing: 4,
                                          children: problem.tags
                                              .take(2)
                                              .map((t) => Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2),
                                                    decoration:
                                                        BoxDecoration(
                                                      color: AppColors
                                                          .bgInput,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  6),
                                                    ),
                                                    child: Text(t,
                                                        style: AppTextStyles
                                                            .small
                                                            .copyWith(
                                                                fontSize:
                                                                    9)),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right side
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      DiffBadge(
                                          difficulty:
                                              problem.difficulty),
                                      const SizedBox(height: 6),
                                      CoinBadge(coins: problem.coins),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

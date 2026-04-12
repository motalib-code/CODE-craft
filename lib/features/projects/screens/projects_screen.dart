import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/diff_badge.dart';
import '../../../core/widgets/coin_badge.dart';
import '../../../core/widgets/gradient_button.dart';
import '../notifiers/projects_notifier.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: GradientText(
                  text: '🚀 Projects',
                  style: AppTextStyles.h1,
                ),
              ),
              const SizedBox(height: 4),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: Text('Build real-world apps to level up',
                    style: AppTextStyles.body),
              ),
              const SizedBox(height: 20),

              // Project cards
              ...List.generate(projectsState.projects.length, (i) {
                final project = projectsState.projects[i];
                return FadeInUp(
                  delay: Duration(milliseconds: 150 + (i * 80)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassCard(
                      onTap: () => _showProjectDetail(context, project),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(project.title,
                                    style: AppTextStyles.h2),
                              ),
                              DiffBadge(difficulty: project.difficulty),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(project.description,
                              style: AppTextStyles.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 12),
                          // Tech stack
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: project.techStack
                                .map((tech) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.purple.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                            color: AppColors.purple
                                                .withOpacity(0.2)),
                                      ),
                                      child: Text(tech,
                                          style: AppTextStyles.small
                                              .copyWith(
                                                  color: AppColors.purple)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CoinBadge(coins: project.coins),
                              const SizedBox(width: 8),
                              Text('+${project.xp} XP',
                                  style: AppTextStyles.small
                                      .copyWith(color: AppColors.purple)),
                              const Spacer(),
                              Text('~${project.estimatedHours}h',
                                  style: AppTextStyles.small),
                              const SizedBox(width: 4),
                              const Icon(Icons.timer,
                                  color: AppColors.textHint, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectDetail(BuildContext context, dynamic project) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(project.title, style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(project.description, style: AppTextStyles.body),
              const SizedBox(height: 20),
              Text('📋 Steps', style: AppTextStyles.h2),
              const SizedBox(height: 12),
              ...List.generate(project.steps.length, (i) {
                final step = project.steps[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradPurpleBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('${step.order}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(step.title, style: AppTextStyles.h3.copyWith(fontSize: 13)),
                              Text(step.description, style: AppTextStyles.small),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Start Project',
                icon: Icons.rocket_launch,
                width: double.infinity,
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

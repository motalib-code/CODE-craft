import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/tag_chip.dart';
import '../notifiers/roadmap_notifier.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmap = ref.watch(roadmapNotifierProvider);
    final tracks = ['DSA', 'Web Dev', 'Flutter', 'ML/AI', 'System Design'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: FadeInDown(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          text: '🗺️ Learning Roadmap',
                          style: AppTextStyles.h1,
                        ),
                        const SizedBox(height: 4),
                        Text('Your personalized coding path',
                            style: AppTextStyles.body),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.explore_outlined, color: AppColors.purple),
                          tooltip: 'Explore All Roadmaps',
                          onPressed: () => context.push('/roadmap/explorer'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.description_outlined, color: AppColors.purple),
                          tooltip: 'Upload Syllabus',
                          onPressed: () => context.push('/roadmap/syllabus-parser'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Track selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tracks.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TagChip(
                        label: tracks[i],
                        selected: roadmap.selectedTrack == tracks[i],
                        onTap: () => ref
                            .read(roadmapNotifierProvider.notifier)
                            .selectTrack(tracks[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Roadmap nodes
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: roadmap.nodes.length,
                itemBuilder: (_, i) {
                  final node = roadmap.nodes[i];
                  final isLocked = node.status == 'locked';
                  final isCompleted = node.status == 'completed';
                  final progress = node.problems > 0
                      ? node.completed / node.problems
                      : 0.0;

                  return FadeInUp(
                    delay: Duration(milliseconds: 100 + (i * 60)),
                    child: Column(
                      children: [
                        // Connector line
                        if (i > 0)
                          Container(
                            width: 2,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: isLocked
                                  ? null
                                  : AppColors.gradPurpleBlue,
                              color: isLocked
                                  ? AppColors.bgInput
                                  : null,
                            ),
                          ),

                        // Node card
                        GlassCard(
                          onTap: isLocked
                              ? null
                              : () => context
                                  .push('/topic/${node.title}'),
                          borderColor: isCompleted
                              ? AppColors.green
                              : isLocked
                                  ? AppColors.border
                                  : AppColors.borderPurple,
                          gradient: isCompleted
                              ? LinearGradient(colors: [
                                  AppColors.green.withOpacity(0.08),
                                  AppColors.green.withOpacity(0.02),
                                ])
                              : null,
                          child: Opacity(
                            opacity: isLocked ? 0.5 : 1.0,
                            child: Row(
                              children: [
                                // Status icon
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppColors.green
                                            .withOpacity(0.2)
                                        : isLocked
                                            ? AppColors.bgInput
                                            : AppColors.purple
                                                .withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: isLocked
                                        ? const Icon(Icons.lock,
                                            color:
                                                AppColors.textHint,
                                            size: 20)
                                        : Text(node.emoji,
                                            style: const TextStyle(
                                                fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(node.title,
                                          style: AppTextStyles.h3),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${node.completed}/${node.problems} problems',
                                        style: AppTextStyles.small,
                                      ),
                                      if (!isLocked) ...[
                                        const SizedBox(height: 6),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  4),
                                          child:
                                              LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor:
                                                AppColors.bgInput,
                                            valueColor:
                                                AlwaysStoppedAnimation(
                                              isCompleted
                                                  ? AppColors.green
                                                  : AppColors.purple,
                                            ),
                                            minHeight: 4,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Arrow
                                if (!isLocked)
                                  Icon(
                                    isCompleted
                                        ? Icons.check_circle
                                        : Icons.arrow_forward_ios,
                                    color: isCompleted
                                        ? AppColors.green
                                        : AppColors.textHint,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

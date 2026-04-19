import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/leetcode_problem.dart';

class ProblemCard extends StatelessWidget {
  final LeetCodeProblem problem;
  final VoidCallback onTap;
  final bool isSolved;

  const ProblemCard({
    super.key,
    required this.problem,
    required this.onTap,
    this.isSolved = false,
  });

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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSolved ? Colors.green.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Leading icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2070),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      isSolved ? Icons.check : Icons.code,
                      color: isSolved ? Colors.green : AppColors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Title and stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        problem.title,
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      // Stats row with tags
                      Wrap(
                        spacing: 8,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people,
                                  size: 12, color: Colors.white38),
                              const SizedBox(width: 4),
                              Text(
                                '${problem.acceptanceRate.toStringAsFixed(1)}% accepted',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white38,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          ...problem.tags.take(2).map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.purple.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.purple,
                                    fontSize: 10,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing: difficulty and XP
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(problem.difficulty),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        problem.difficulty,
                        style: AppTextStyles.small.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${problem.xpReward} XP',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

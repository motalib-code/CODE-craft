import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../models/badge_model.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = BadgeModel.allBadges;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: GradientText(
          text: '🏅 Badges',
          style: AppTextStyles.h2,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: badges.length,
        itemBuilder: (_, i) {
          final badge = badges[i];
          final earned = i < 4;

          return FadeInUp(
            delay: Duration(milliseconds: i * 60),
            child: GlassCard(
              onTap: () => _showBadgeInfo(context, badge, earned),
              padding: const EdgeInsets.all(10),
              borderColor:
                  earned ? AppColors.gold.withOpacity(0.4) : AppColors.border,
              gradient: earned
                  ? LinearGradient(colors: [
                      AppColors.gold.withOpacity(0.1),
                      AppColors.gold.withOpacity(0.02),
                    ])
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: earned ? 1 : 0.3,
                    child: Text(badge.emoji,
                        style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 8),
                  Text(badge.title,
                      style: AppTextStyles.small
                          .copyWith(fontSize: 10, color: earned ? AppColors.textPrimary : AppColors.textHint),
                      textAlign: TextAlign.center,
                      maxLines: 2),
                  if (!earned)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child:
                          Icon(Icons.lock, color: AppColors.textHint, size: 14),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBadgeInfo(BuildContext context, BadgeModel badge, bool earned) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(badge.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(badge.title, style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(badge.description,
                  style: AppTextStyles.body, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: earned
                      ? AppColors.green.withOpacity(0.1)
                      : AppColors.bgInput,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  earned ? '✅ Earned!' : '🔒 ${badge.requiredXp} XP needed',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 13,
                    color: earned ? AppColors.green : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

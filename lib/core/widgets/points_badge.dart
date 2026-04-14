import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class PointsBadge extends StatelessWidget {
  final String points;
  final IconData icon;
  final Color baseColor;

  const PointsBadge({
    super.key,
    required this.points,
    this.icon = Icons.stars_rounded,
    this.baseColor = AppColors.purple,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: baseColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: baseColor, size: 16),
          const SizedBox(width: 8),
          Text(
            points,
            style: AppTextStyles.small.copyWith(
              color: textPrimaryColor, // We'll assume textPrimary is white/near-white
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color get textPrimaryColor => Colors.white;
}

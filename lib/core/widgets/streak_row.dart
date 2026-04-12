import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StreakRow extends StatelessWidget {
  final List<int> streakDays; // 0=missed, 1=done, 2=today

  const StreakRow({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (i) {
        final state = i < streakDays.length ? streakDays[i] : 0;
        return Column(
          children: [
            Text(
              days[i],
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: state == 1
                    ? AppColors.gradPurpleBlue
                    : state == 2
                        ? const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)])
                        : null,
                color: state == 0 ? AppColors.bgInput : null,
                border: state == 2
                    ? Border.all(color: AppColors.green, width: 2)
                    : null,
                boxShadow: state > 0
                    ? [
                        BoxShadow(
                          color: (state == 1 ? AppColors.purple : AppColors.green)
                              .withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: state == 1
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : state == 2
                        ? const Icon(Icons.local_fire_department,
                            color: Colors.white, size: 16)
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      }),
    );
  }
}

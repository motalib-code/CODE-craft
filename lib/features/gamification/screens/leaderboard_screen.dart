import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/points_badge.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.code_rounded, color: AppColors.blue, size: 28),
                  const SizedBox(width: 8),
                  Text('CodeCraft', style: AppTextStyles.h2),
                  const Spacer(),
                  const PointsBadge(points: '1.2k', icon: Icons.bolt),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=RS&background=7C3AED&color=fff'),
                  ),
                ],
              ),
            ),

            // ── Welcome Text ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text('Global ', style: AppTextStyles.display.copyWith(fontSize: 28)),
                      Text('Rankings', style: AppTextStyles.display.copyWith(fontSize: 28, color: AppColors.purple)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rise through the ranks by solving challenges and maintaining your daily coding streaks.',
                    style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),

            // ── Filter Tabs ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildTab('National', true),
                    _buildTab('College', false),
                    _buildTab('Friends', false),
                  ],
                ),
              ),
            ),

            // ── Podium Section ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPodiumAvatar(
                    rank: 2,
                    name: 'Anya.dev',
                    points: '2,840 pts',
                    img: 'https://ui-avatars.com/api/?name=AD&background=10B981&color=fff',
                    color: const Color(0xFFC0C0C0),
                  ),
                  const SizedBox(width: 20),
                  _buildPodiumAvatar(
                    rank: 1,
                    name: 'Kael_Prime',
                    points: '3,120 pts',
                    img: 'https://ui-avatars.com/api/?name=KP&background=F59E0B&color=fff',
                    color: AppColors.gold,
                    isMain: true,
                  ),
                  const SizedBox(width: 20),
                  _buildPodiumAvatar(
                    rank: 3,
                    name: 'NullPointer',
                    points: '2,610 pts',
                    img: 'https://ui-avatars.com/api/?name=NP&background=CD7F32&color=fff',
                    color: const Color(0xFFCD7F32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── List Headers ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Text('RANK', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textHint)),
                  const SizedBox(width: 20),
                  Text('DEVELOPER', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textHint)),
                  const Spacer(),
                  Text('RATING', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textHint)),
                  const SizedBox(width: 24),
                  Text('STREAK', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textHint)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Rankings List ────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildRankItem(4, 'ByteBoss', '2,450', '42', 'https://i.pravatar.cc/150?u=byte'),
                  const SizedBox(height: 12),
                  // "YOU" Card
                  FadeInUp(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.purple.withOpacity(0.2), AppColors.bgSurface],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.purple.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('24', style: AppTextStyles.h3.copyWith(fontSize: 20)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('You ', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                                    Text('(PixelPioneer)', style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColors.textHint)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('NEXT TIER IN 40PTS', style: AppTextStyles.small.copyWith(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textHint)),
                              ],
                            ),
                          ),
                          Text('1,820', style: AppTextStyles.code.copyWith(fontSize: 14, color: AppColors.purple)),
                          const SizedBox(width: 20),
                          const Icon(Icons.local_fire_department, color: AppColors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text('14', style: AppTextStyles.body.copyWith(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRankItem(5, 'StackOver', '2,390', '28', 'https://i.pravatar.cc/150?u=stack'),
                  const SizedBox(height: 12),
                  _buildRankItem(6, 'CodeWiz', '2,110', '8', 'https://i.pravatar.cc/150?u=wiz'),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.gradPurpleBlue : null,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textHint,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumAvatar({required int rank, required String name, required String points, required String img, required Color color, bool isMain = false}) {
    double radius = isMain ? 45 : 35;
    return Column(
      children: [
        if (isMain) 
          const Icon(Icons.stars, color: AppColors.gold, size: 24),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [color, color.withOpacity(0.2)]),
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundImage: NetworkImage(img),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('RANK $rank', style: const TextStyle(color: AppColors.bg, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(name, style: AppTextStyles.h3.copyWith(fontSize: 14)),
        Text(points, style: AppTextStyles.code.copyWith(fontSize: 12, color: isMain ? AppColors.purple : AppColors.textHint)),
      ],
    );
  }

  Widget _buildRankItem(int rank, String name, String rating, String streak, String img) {
    return FadeInUp(
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(rank < 10 ? '0$rank' : '$rank', style: AppTextStyles.body),
            ),
            CircleAvatar(radius: 18, backgroundImage: NetworkImage(img)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(name, style: AppTextStyles.h3.copyWith(fontSize: 15)),
            ),
            Text(rating, style: AppTextStyles.code.copyWith(fontSize: 14, color: AppColors.blue)),
            const SizedBox(width: 24),
            const Icon(Icons.local_fire_department, color: AppColors.orange, size: 16),
            const SizedBox(width: 4),
            Text(streak, style: AppTextStyles.body.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../core/utils/helpers.dart';
import '../notifiers/gamification_notifier.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationNotifierProvider);
    final notifier = ref.read(gamificationNotifierProvider.notifier);
    final entries = gamification.entries;
    final tabs = ['National', 'City', 'College'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: GradientText(
          text: '🏆 Leaderboard',
          style: AppTextStyles.h2,
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: tabs
                  .map((t) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TagChip(
                          label: t,
                          selected: gamification.tab == t,
                          onTap: () => notifier.setTab(t),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Top 3 podium
          if (entries.length >= 3)
            Padding(
              padding: const EdgeInsets.all(20),
              child: FadeInDown(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 2nd place
                    Expanded(
                      child: _PodiumCard(
                        entry: entries[1],
                        medal: '🥈',
                        height: 100,
                        color: const Color(0xFFC0C0C0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 1st place
                    Expanded(
                      child: _PodiumCard(
                        entry: entries[0],
                        medal: '🥇',
                        height: 130,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 3rd place
                    Expanded(
                      child: _PodiumCard(
                        entry: entries[2],
                        medal: '🥉',
                        height: 80,
                        color: const Color(0xFFCD7F32),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Rest of the list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: entries.length - 3,
              itemBuilder: (_, i) {
                final entry = entries[i + 3];
                return FadeInUp(
                  delay: Duration(milliseconds: i * 50),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text(
                              '#${entry.rank}',
                              style: AppTextStyles.h3.copyWith(
                                  fontSize: 13,
                                  color: AppColors.textSecondary),
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                Helpers.getInitials(entry.name),
                                style: const TextStyle(
                                    color: AppColors.purple,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.name,
                                    style:
                                        AppTextStyles.h3.copyWith(fontSize: 13)),
                                Text(entry.college,
                                    style: AppTextStyles.small),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${Helpers.formatNumber(entry.xp)} XP',
                                  style: AppTextStyles.h3.copyWith(
                                      fontSize: 12,
                                      color: AppColors.purple)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: AppColors.orange, size: 12),
                                  Text('${entry.streak}d',
                                      style: AppTextStyles.small
                                          .copyWith(fontSize: 10)),
                                ],
                              ),
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
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final String medal;
  final double height;
  final Color color;

  const _PodiumCard({
    required this.entry,
    required this.medal,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withOpacity(0.3),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.15),
          color.withOpacity(0.02),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(medal, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(entry.name.split(' ').first,
                style: AppTextStyles.h3.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text('${Helpers.formatNumber(entry.xp)} XP',
                style: AppTextStyles.small
                    .copyWith(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

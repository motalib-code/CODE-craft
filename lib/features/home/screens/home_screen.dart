import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/coin_badge.dart';
import '../../../core/widgets/streak_row.dart';
import '../../../core/widgets/diff_badge.dart';
import '../../../core/utils/helpers.dart';
import '../notifiers/home_notifier.dart';
import '../../auth/notifiers/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeNotifierProvider);
    final userData = ref.watch(userDataProvider);
    final userName = userData.value?.name ?? 'Coder';
    final coins = userData.value?.coins ?? 1200;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Top Bar ──────────────────────────────
              FadeInDown(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradPurpleBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          Helpers.getInitials(userName),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Helpers.greetBasedOnTime(),
                              style: AppTextStyles.small),
                          Text(userName,
                              style: AppTextStyles.h2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    CoinBadge(coins: coins),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Streak Card ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: GlassCard(
                  borderColor: AppColors.borderPurple,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('🔥',
                              style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text('${home.streak} Day Streak',
                              style: AppTextStyles.h2),
                          const Spacer(),
                          GradientButton(
                            label: 'Claim',
                            small: true,
                            icon: Icons.bolt,
                            onTap: () => ref
                                .read(homeNotifierProvider.notifier)
                                .claimStreak(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      StreakRow(streakDays: home.streakDays),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Daily Challenge ──────────────────────
              if (home.dailyChallenge != null)
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: GlassCard(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.purple.withOpacity(0.15),
                        AppColors.blue.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderColor: AppColors.borderPurple,
                    onTap: () => context.push(
                        '/code-editor/${home.dailyChallenge!.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GradientText(
                              text: '🔥 Daily Challenge',
                              style: AppTextStyles.h3,
                            ),
                            const Spacer(),
                            DiffBadge(
                                difficulty:
                                    home.dailyChallenge!.difficulty),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(home.dailyChallenge!.title,
                            style: AppTextStyles.h2),
                        const SizedBox(height: 6),
                        Text(
                          home.dailyChallenge!.description,
                          style: AppTextStyles.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CoinBadge(
                                coins: home.dailyChallenge!.coins),
                            const SizedBox(width: 8),
                            Text('+${home.dailyChallenge!.xp} XP',
                                style: AppTextStyles.small
                                    .copyWith(color: AppColors.purple)),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios,
                                color: AppColors.textHint, size: 14),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ── Stats Row ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    _StatCard(
                        label: 'Solved',
                        value: '${home.solved}',
                        icon: Icons.check_circle,
                        color: AppColors.green),
                    const SizedBox(width: 10),
                    _StatCard(
                        label: 'Rank',
                        value: '#${home.rank}',
                        icon: Icons.leaderboard,
                        color: AppColors.purple),
                    const SizedBox(width: 10),
                    _StatCard(
                        label: 'Accuracy',
                        value: '${home.accuracy}%',
                        icon: Icons.gps_fixed,
                        color: AppColors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Continue Learning ──────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Row(
                  children: [
                    Text('Continue Learning', style: AppTextStyles.h2),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go('/roadmap'),
                      child: Text('See all',
                          style: AppTextStyles.small
                              .copyWith(color: AppColors.purple)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 450),
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: home.continueTopics.length,
                    itemBuilder: (_, i) {
                      final topic = home.continueTopics[i];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: GlassCard(
                          onTap: () =>
                              context.push('/topic/${topic['name']}'),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(topic['emoji'] as String,
                                  style:
                                      const TextStyle(fontSize: 24)),
                              const SizedBox(height: 8),
                              Text(topic['name'] as String,
                                  style: AppTextStyles.h3
                                      .copyWith(fontSize: 14)),
                              const Spacer(),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value:
                                      topic['progress'] as double,
                                  backgroundColor: AppColors.bgInput,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Color(topic['color'] as int),
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Top Coders Preview ──────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Text('Top Coders', style: AppTextStyles.h2),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.push('/leaderboard'),
                      child: Text('See all',
                          style: AppTextStyles.small
                              .copyWith(color: AppColors.purple)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                home.topCoders.length,
                (i) {
                  final coder = home.topCoders[i];
                  final medals = ['🥇', '🥈', '🥉'];
                  return FadeInUp(
                    delay: Duration(milliseconds: 550 + (i * 50)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Text(medals[i],
                                style:
                                    const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(coder['name'] as String,
                                      style: AppTextStyles.h3
                                          .copyWith(fontSize: 14)),
                                  Text(coder['college'] as String,
                                      style: AppTextStyles.small),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${Helpers.formatNumber(coder['xp'] as int)} XP',
                                    style: AppTextStyles.h3.copyWith(
                                        fontSize: 13,
                                        color: AppColors.purple)),
                                Text('#${coder['rank']}',
                                    style: AppTextStyles.small),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // ── Job Alerts ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: Text('💼 Job Alerts', style: AppTextStyles.h2),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 750),
                child: SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: home.jobs.length,
                    itemBuilder: (_, i) {
                      final job = home.jobs[i];
                      return Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: 12),
                        child: GlassCard(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.purple
                                          .withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.business,
                                          color: AppColors.purple,
                                          size: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(job.company,
                                            style:
                                                AppTextStyles.small
                                                    .copyWith(
                                                        color: AppColors
                                                            .purple)),
                                        Text(job.type,
                                            style:
                                                AppTextStyles.small),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(job.title,
                                  style: AppTextStyles.h3
                                      .copyWith(fontSize: 13),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('${job.location} • ${job.salary}',
                                  style: AppTextStyles.small),
                              const Spacer(),
                              Wrap(
                                spacing: 4,
                                children: job.skills
                                    .take(3)
                                    .map(
                                      (s) => Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 6,
                                            vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.bgInput,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  6),
                                        ),
                                        child: Text(s,
                                            style: AppTextStyles.small
                                                .copyWith(
                                                    fontSize: 9)),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: AppTextStyles.h2
                    .copyWith(color: color, fontSize: 18)),
            Text(label, style: AppTextStyles.small),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/coin_badge.dart';
import '../../../core/utils/helpers.dart';
import '../../auth/notifiers/auth_notifier.dart';
import '../../../models/badge_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final user = userData.value;
    final name = user?.name ?? 'Coder';
    final college = user?.college ?? 'Unknown College';
    final xp = user?.xp ?? 12400;
    final coins = user?.coins ?? 1200;
    final solved = user?.problemsSolved ?? 147;
    final streak = user?.streak ?? 15;
    final level = user?.currentLevel ?? 12;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar + name
                    FadeInDown(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppColors.gradPurpleBlue,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purple.withOpacity(0.3),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                Helpers.getInitials(name),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(name, style: AppTextStyles.h1),
                          Text(college, style: AppTextStyles.body),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GradientButton(
                                label: 'Edit Profile',
                                small: true,
                                icon: Icons.edit,
                                onTap: () {},
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  await ref
                                      .read(authNotifierProvider.notifier)
                                      .signOut();
                                  if (context.mounted) {
                                    context.go('/auth/login');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.border),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.logout,
                                      color: AppColors.textSecondary,
                                      size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stats row
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          _ProfileStat(
                              label: 'SOLVED',
                              value: '$solved',
                              icon: Icons.check_circle),
                          _ProfileStat(
                              label: 'STREAK',
                              value: '$streak',
                              icon: Icons.local_fire_department),
                          _ProfileStat(
                              label: 'XP',
                              value: Helpers.formatNumber(xp),
                              icon: Icons.star),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Level bar
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('🏆', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text('Level $level',
                                    style: AppTextStyles.h3),
                                const Spacer(),
                                CoinBadge(coins: coins),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (user?.levelProgress ?? 0.4),
                                backgroundColor: AppColors.bgInput,
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.purple),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                'Level ${level + 1} | ${((user?.levelProgress ?? 0.4) * 100).toInt()}% complete',
                                style: AppTextStyles.small),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Column(
            children: [
              TabBar(
                controller: _tabCtrl,
                indicatorColor: AppColors.purple,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textHint,
                tabs: const [
                  Tab(text: 'Stats'),
                  Tab(text: 'Badges'),
                  Tab(text: 'Resume'),
                  Tab(text: 'Store'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildStatsTab(),
                    _buildBadgesTab(),
                    _buildResumeTab(context),
                    _buildStoreTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skill Distribution', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: 42,
                    title: '42%',
                    color: AppColors.purple,
                    radius: 30,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  PieChartSectionData(
                    value: 28,
                    title: '28%',
                    color: AppColors.blue,
                    radius: 30,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  PieChartSectionData(
                    value: 18,
                    title: '18%',
                    color: AppColors.green,
                    radius: 30,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  PieChartSectionData(
                    value: 12,
                    title: '12%',
                    color: AppColors.pink,
                    radius: 30,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _LegendItem(color: AppColors.purple, label: 'Frontend', value: '42% mastery'),
          const _LegendItem(color: AppColors.blue, label: 'Algorithms', value: '28% mastery'),
          const _LegendItem(color: AppColors.green, label: 'Architecture', value: '18% mastery'),
          const _LegendItem(color: AppColors.pink, label: 'Others', value: '12% mastery'),
          const SizedBox(height: 24),
          Text('Top Accomplishments', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          const _AccomplishmentCard(
              emoji: '👑',
              title: 'Elite Coder Award',
              desc: 'Ranked top 1% in Summer Challenge 2023'),
          const _AccomplishmentCard(
              emoji: '🏆',
              title: 'Binary Conqueror',
              desc: 'Solved 50+ hard-level problems on binary'),
          const _AccomplishmentCard(
              emoji: '🎓',
              title: 'Lead Mentor',
              desc: 'Helped 200+ students in Flutter peer group'),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    final badges = BadgeModel.allBadges;
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (_, i) {
        final badge = badges[i];
        final earned = i < 4; // First 4 earned for demo
        return FadeInUp(
          delay: Duration(milliseconds: i * 60),
          child: GlassCard(
            padding: const EdgeInsets.all(10),
            borderColor:
                earned ? AppColors.gold.withOpacity(0.3) : AppColors.border,
            gradient: earned
                ? LinearGradient(colors: [
                    AppColors.gold.withOpacity(0.08),
                    AppColors.gold.withOpacity(0.02),
                  ])
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(badge.emoji,
                    style: TextStyle(
                        fontSize: 28,
                        color: earned ? null : Colors.grey)),
                const SizedBox(height: 6),
                Text(badge.title,
                    style:
                        AppTextStyles.small.copyWith(fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2),
                if (!earned) ...[
                  const SizedBox(height: 4),
                  const Icon(Icons.lock, color: AppColors.textHint, size: 12),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumeTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GlassCard(
            gradient: LinearGradient(
              colors: [
                AppColors.blue.withOpacity(0.1),
                AppColors.purple.withOpacity(0.05),
              ],
            ),
            child: Column(
              children: [
                const Text('📄', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text('Auto-Generated Resume', style: AppTextStyles.h2),
                const SizedBox(height: 6),
                Text(
                    'Based on your projects, skills, and achievements',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                GradientButton(
                  label: 'View Resume',
                  icon: Icons.visibility,
                  onTap: () => context.push('/resume'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              children: [
                const Text('💼', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text('Mock Interview', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                GradientButton(
                  label: 'Start Interview',
                  small: true,
                  icon: Icons.mic,
                  gradient: AppColors.gradGreenBlue,
                  onTap: () => context.push('/mock-interview'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GlassCard(
            gradient: LinearGradient(
              colors: [
                AppColors.gold.withOpacity(0.1),
                AppColors.gold.withOpacity(0.02),
              ],
            ),
            child: Column(
              children: [
                const Text('🏪', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text('Swag Store', style: AppTextStyles.h2),
                const SizedBox(height: 8),
                const CoinBadge(coins: 1200, large: true),
                const SizedBox(height: 16),
                GradientButton(
                  label: 'Browse Store',
                  icon: Icons.shopping_bag,
                  gradient: AppColors.gradOrangeRed,
                  onTap: () => context.push('/store'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Text(value,
                style: AppTextStyles.h1.copyWith(fontSize: 20)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.small),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem(
      {required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.body),
          const Spacer(),
          Text(value, style: AppTextStyles.small),
        ],
      ),
    );
  }
}

class _AccomplishmentCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;

  const _AccomplishmentCard(
      {required this.emoji, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.h3.copyWith(fontSize: 13)),
                  Text(desc, style: AppTextStyles.small),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

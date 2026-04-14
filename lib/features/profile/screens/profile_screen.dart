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
import '../../../core/widgets/points_badge.dart';
import '../../../core/utils/helpers.dart';
import '../../auth/notifiers/auth_notifier.dart';

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
    final name = user?.name ?? 'Rahul Sharma';
    final handle = '@rahul_codes';
    final college = 'IIT Bombay';
    final xp = '12.4k';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Section ────────────────────────
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Background Nebula Effect
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1506318137071-a8e063b4bec0?w=800&q=80'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(AppColors.bg, BlendMode.multiply),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: FadeInDown(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.mint, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Rahul+Sharma&background=7C3AED&color=fff'),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.bg, width: 3),
                            ),
                            child: const Center(
                              child: Text('6', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Nav Buttons
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CodeCraft', style: AppTextStyles.h2.copyWith(color: AppColors.blue)),
                        const PointsBadge(points: '1.2k', icon: Icons.bolt),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // ── User Details ──────────────────────────
            FadeInUp(
              child: Column(
                children: [
                  Text(name, style: AppTextStyles.display.copyWith(fontSize: 28)),
                  Text(handle, style: AppTextStyles.body.copyWith(color: AppColors.textHint)),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientButton(
                          label: 'Community',
                          onTap: () => context.push('/community'),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => context.push('/offline'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.bgSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.cloud_download_outlined, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.body.copyWith(height: 1.5),
                        children: [
                          const TextSpan(text: '3rd Year @ '),
                          TextSpan(text: college, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const TextSpan(text: ' | '),
                          TextSpan(text: 'Flutter Developer', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' | Passionate about building performant cross-platform experiences and solving algorithmic challenges.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ── Stats Row 1 ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _BigStatCard(
                    title: 'SOLVED',
                    value: '147',
                    progress: 0.7,
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _BigStatCard(
                    title: 'STREAK',
                    value: '15',
                    progress: 0.5,
                    icon: Icons.local_fire_department,
                    subtitle: '🔥 Personal Record',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _BigStatCard(
                    title: 'XP',
                    value: xp,
                    progress: 0.9,
                    icon: Icons.military_tech_outlined,
                    subtitle: 'Level 24 Mastermind',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Learning Activity ────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Learning Activity', style: AppTextStyles.h2),
                        const Spacer(),
                        Text('Less', style: AppTextStyles.small),
                        const SizedBox(width: 4),
                        ...List.generate(4, (index) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withOpacity(0.2 + (index * 0.2)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )),
                        const SizedBox(width: 4),
                        Text('More', style: AppTextStyles.small),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _HeatmapGrid(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Skill Distribution ──────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Skill Distribution', style: AppTextStyles.h2),
                    const SizedBox(height: 32),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(value: 42, color: AppColors.purple, radius: 20, showTitle: false),
                                  PieChartSectionData(value: 38, color: AppColors.blue, radius: 20, showTitle: false),
                                  PieChartSectionData(value: 12, color: AppColors.mint, radius: 20, showTitle: false),
                                  PieChartSectionData(value: 8, color: AppColors.bgInput, radius: 20, showTitle: false),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text('84%', style: AppTextStyles.display.copyWith(fontSize: 32)),
                              Text('OVERALL', style: AppTextStyles.small.copyWith(letterSpacing: 2)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Row(
                      children: [
                        Expanded(child: _SkillLegendItem(color: AppColors.purple, label: 'Frontend', value: '42% mastery')),
                        Expanded(child: _SkillLegendItem(color: AppColors.blue, label: 'Algorithms', value: '38% mastery')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(child: _SkillLegendItem(color: AppColors.mint, label: 'Architecture', value: '12% mastery')),
                        Expanded(child: _SkillLegendItem(color: AppColors.bgInput, label: 'Others', value: '8% mastery')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Top Accomplishments ──────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Accomplishments', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  _AccomplishmentItem(
                    title: 'Elite Coder Award',
                    subtitle: 'Ranked top 1% in Summer Challenge 2023',
                    icon: Icons.verified_outlined,
                  ),
                  _AccomplishmentItem(
                    title: 'Binary Conqueror',
                    subtitle: 'Solved 50+ Hard level problems on first try',
                    icon: Icons.image_search,
                  ),
                  _AccomplishmentItem(
                    title: 'Lead Mentor',
                    subtitle: 'Helped 200+ students in Flutter Peer Groups',
                    icon: Icons.group_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final IconData icon;
  final String? subtitle;

  const _BigStatCard({
    required this.title,
    required this.value,
    required this.progress,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.small),
                    const SizedBox(height: 4),
                    Text(value, style: AppTextStyles.display.copyWith(fontSize: 32)),
                  ],
                ),
                const Spacer(),
                Icon(icon, color: AppColors.textHint.withOpacity(0.3), size: 48),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bgInput,
              valueColor: const AlwaysStoppedAnimation(AppColors.purple),
              minHeight: 6,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: AppColors.red, size: 14),
                  const SizedBox(width: 4),
                  Text(subtitle!, style: AppTextStyles.small.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = 4;
        final int columns = 24;
        final double cellSize = (constraints.maxWidth - (columns - 1) * spacing) / columns;
        
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(columns * 2, (index) {
            final double opacity = (index % 5) * 0.2;
            return Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(opacity == 0 ? 0.1 : opacity),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

class _SkillLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _SkillLegendItem({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.small.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(value, style: AppTextStyles.small.copyWith(fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

class _AccomplishmentItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _AccomplishmentItem({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.purple, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.small),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


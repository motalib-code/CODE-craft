import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/notifiers/auth_notifier.dart';

class ResumeScreen extends ConsumerWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final user = userData.value;
    final name = user?.name ?? 'Student Name';
    final email = user?.email ?? 'student@email.com';
    final college = user?.college ?? 'Engineering College';
    final solved = user?.problemsSolved ?? 147;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: GradientText(
          text: '📄 Resume',
          style: AppTextStyles.h2,
        ),
        actions: [
          GradientButton(
            label: 'Share',
            small: true,
            icon: Icons.share,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume sharing coming soon!')),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FadeInUp(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1a1a2e))),
                      const SizedBox(height: 4),
                      Text(email,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF666666))),
                      const SizedBox(height: 2),
                      Text(college,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF666666))),
                    ],
                  ),
                ),
                const Divider(height: 24),

                // Education
                _ResumeSection(
                  title: 'Education',
                  children: [
                    _ResumeItem(
                      title: 'B.Tech Computer Science',
                      subtitle: college,
                      trailing: '2021 - 2025',
                    ),
                  ],
                ),

                // Skills
                const _ResumeSection(
                  title: 'Technical Skills',
                  children: [
                    _SkillRow(
                        label: 'Languages',
                        skills: 'Python, Java, C++, Dart, JavaScript'),
                    _SkillRow(
                        label: 'Frameworks',
                        skills: 'Flutter, React, Node.js, Django'),
                    _SkillRow(
                        label: 'Tools',
                        skills: 'Git, Firebase, Docker, VS Code'),
                    _SkillRow(
                        label: 'Databases',
                        skills: 'MySQL, MongoDB, Firestore'),
                  ],
                ),

                // Achievements
                _ResumeSection(
                  title: 'Achievements',
                  children: [
                    _ResumeItem(
                      title: 'CodeCraft Platform',
                      subtitle: '$solved problems solved | Top 5% ranking',
                    ),
                    const _ResumeItem(
                      title: 'Elite Coder Award',
                      subtitle: 'Ranked top 1% in Summer Challenge 2023',
                    ),
                    const _ResumeItem(
                      title: 'Lead Mentor',
                      subtitle: 'Helped 200+ students in coding peer group',
                    ),
                  ],
                ),

                // Projects
                const _ResumeSection(
                  title: 'Projects',
                  children: [
                    _ResumeItem(
                      title: 'Weather App',
                      subtitle:
                          'Built with Flutter & OpenWeatherMap API. Features real-time weather data, location services, and beautiful UI.',
                    ),
                    _ResumeItem(
                      title: 'Chat Application',
                      subtitle:
                          'Real-time messaging app using Firebase. Supports text, images, and push notifications.',
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

class _ResumeSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ResumeSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7C3AED))),
        const Divider(height: 8, color: Color(0xFFE0E0E0)),
        ...children,
      ],
    );
  }
}

class _ResumeItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;

  const _ResumeItem(
      {required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a1a2e))),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF666666))),
              ],
            ),
          ),
          if (trailing != null)
            Text(trailing!,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF999999))),
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final String label;
  final String skills;

  const _SkillRow({required this.label, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a2e))),
          ),
          Expanded(
            child: Text(skills,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF666666))),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import 'package:animate_do/animate_do.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Community Hub', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text('College Rooms', style: AppTextStyles.h1),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                child: SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildRoomCard('ACM Chapter', '142 members', AppColors.purple, Icons.group),
                      const SizedBox(width: 16),
                      _buildRoomCard('React Devs', '89 members', AppColors.cyan, Icons.code),
                      const SizedBox(width: 16),
                      _buildRoomCard('DSA Prep 2026', '256 members', AppColors.green, Icons.emoji_events),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInDown(
                child: Text('Q&A Forum', style: AppTextStyles.h1),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    _buildForumPost('How to implement JWT in Node.js securely?', 'Posted by Arpit • 2h ago', 14),
                    const SizedBox(height: 16),
                    _buildForumPost('Best resources for DP on Grids?', 'Posted by Neha • 5h ago', 32),
                    const SizedBox(height: 16),
                    _buildForumPost('Flutter Riverpod vs BLOC in 2026', 'Posted by DevLead • 1d ago', 89),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.purple,
        onPressed: () {},
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }

  Widget _buildRoomCard(String title, String subtitle, Color color, IconData icon) {
    return SizedBox(
      width: 160,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderColor: color.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTextStyles.small, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Join', style: AppTextStyles.small.copyWith(color: color, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForumPost(String title, String meta, int upvotes) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(Icons.arrow_upward, color: AppColors.textHint, size: 20),
              const SizedBox(height: 4),
              Text('$upvotes', style: AppTextStyles.btnSm.copyWith(color: AppColors.purple)),
              const SizedBox(height: 4),
              const Icon(Icons.arrow_downward, color: AppColors.textHint, size: 20),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(meta, style: AppTextStyles.small),
              ],
            ),
          ),
          const Icon(Icons.chat_bubble_outline, color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}

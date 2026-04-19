import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../models/project_model.dart';
import '../core/widgets/glass_card.dart';

class ProjectCard extends StatelessWidget {
  final ProjectItem project;

  const ProjectCard({super.key, required this.project});

  Future<void> _launchUrl(String? urlStr, BuildContext context) async {
    if (urlStr == null) return;
    final Uri url = Uri.parse(urlStr);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlStr')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.purple.withOpacity(0.2),
              child: Text(
                project.number.toString().padLeft(2, '0'),
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.purple),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(project.name, style: AppTextStyles.h2),
                   if (project.industry != null) ...[
                     const SizedBox(height: 4),
                     Text(project.industry!, style: AppTextStyles.small.copyWith(color: AppColors.blue)),
                   ],
                   if (project.description != null) ...[
                     const SizedBox(height: 6),
                     Text(project.description!, style: AppTextStyles.small, maxLines: 2, overflow: TextOverflow.ellipsis),
                   ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (project.demoUrl != null) 
                  IconButton(icon: const Icon(Icons.language, color: Colors.blueAccent), onPressed: () => _launchUrl(project.demoUrl, context), tooltip: 'Live Demo'),
                if (project.githubUrl != null) 
                  IconButton(icon: const Icon(Icons.code, color: Colors.white70), onPressed: () => _launchUrl(project.githubUrl, context), tooltip: 'GitHub'),
                if (project.youtubeUrl != null) 
                  IconButton(icon: const Icon(Icons.play_circle_fill, color: Colors.redAccent), onPressed: () => _launchUrl(project.youtubeUrl, context), tooltip: 'YouTube'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

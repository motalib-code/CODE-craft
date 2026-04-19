import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../models/project_model.dart';
import '../../../../widgets/project_card.dart';

class CategorySection extends StatelessWidget {
  final ProjectCategory category;

  const CategorySection({super.key, required this.category});

  Future<void> _launchUrl(String urlStr) async {
    final Uri url = Uri.parse(urlStr);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purple.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(child: Text(category.title, style: AppTextStyles.h2)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${category.projects.length} Projects',
                style: AppTextStyles.small.copyWith(
                    color: AppColors.purple, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(category.description,
                style: AppTextStyles.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.link, size: 16, color: Colors.blueAccent),
                const SizedBox(width: 4),
                Expanded(
                  child: InkWell(
                    onTap: category.repoUrl == null
                        ? null
                        : () => _launchUrl(category.repoUrl!),
                    child: Text(
                      (category.repoUrl ?? 'No repository URL')
                          .replaceFirst('https://', ''),
                      style: AppTextStyles.small.copyWith(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (category.tags ?? const <String>[])
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(tag,
                            style: AppTextStyles.small
                                .copyWith(color: AppColors.purple)),
                      ))
                  .toList(),
            ),
          ],
        ),
        children: [
          const Divider(color: AppColors.purple),
          ...category.projects.map((p) => ProjectCard(project: p)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

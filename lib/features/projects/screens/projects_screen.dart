import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../notifiers/projects_notifier.dart';
import '../../core/services/github_service.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});
  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showReadme(ProjectModel project) async {
    try {
      final readme = await GithubService.fetchReadme(project.readmeUrl);
      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          builder: (context, scrollController) => Column(
            children: [
              AppBar(title: Text(project.title), actions: [
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => launchUrl(Uri.parse(project.githubUrl), mode: LaunchMode.externalApplication),
                ),
              ]),
              Expanded(
                child: Markdown(
                  data: readme,
                  styleSheet: MarkdownStyleSheet(
                    p: AppTextStyles.body,
                    h1: AppTextStyles.h1,
                    code: const TextStyle(), 
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('README load nahi ho paya')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(filteredProjectsProvider);
    final selectedSector = ref.watch(projectSectorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Search projects, tags, or fields...',
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.purple),
                filled: true,
                fillColor: AppColors.bgInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['All', 'Favorites', 'SIH', 'ROS', 'Flutter'].map((sector) {
                final isSelected = selectedSector == sector;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GlassCard(
                    onTap: () => ref.read(projectSectorProvider.notifier).state = sector,
                    gradient: isSelected ? AppColors.gradPurpleBlue : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(sector, style: const TextStyle().copyWith(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: projects.isEmpty
                ? const Center(child: Text('No projects found', style: AppTextStyles.h2))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      final isFavorite = ref.watch(favoritesProvider).contains(p.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GlassCard(
                          onTap: () => _showReadme(p),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(p.title, style: AppTextStyles.h2)),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : AppColors.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(p.id),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary.withOpacity(0.5)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(p.description, style: AppTextStyles.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: p.tags.map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.purple.withOpacity(0.2)),
                                  ),
                                  child: Text(tag, style: AppTextStyles.small.copyWith(color: AppColors.purple, fontSize: 10)),
                                )).toList(),
                              ),
                            ],
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

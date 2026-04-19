import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/projects_data.dart';
import '../../../models/project_model.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Get filtered projects based on selected category and search
  List<ProjectItem> getFilteredProjects() {
    List<ProjectItem> allProjects = [];
    
    // Flatten the nested structure
    for (final category in ProjectsData.projectCategories) {
      allProjects.addAll(category.projects);
    }

    return allProjects.where((project) {
      final matchesCategory = selectedCategory == 'All' || 
                              _getProjectCategory(project) == selectedCategory;
      final matchesSearch = searchQuery.isEmpty || 
                            project.name.toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                            (project.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Get category name for a project
  String _getProjectCategory(ProjectItem project) {
    for (final category in ProjectsData.projectCategories) {
      if (category.projects.contains(project)) {
        return category.name;
      }
    }
    return 'Unknown';
  }

  // Open URL in browser
  Future<void> _openLink(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...ProjectsData.projectCategories.map((c) => c.name)];
    final filtered = getFilteredProjects();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Projects Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.bg,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => searchQuery = val),
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                hintStyle: AppTextStyles.body.copyWith(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.purple),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.bgSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          // Category Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (String category in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedCategory == category 
                            ? AppColors.purple
                            : Colors.grey[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category 
                              ? Colors.white 
                              : Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

          const SizedBox(height: 16),

          // Project List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppColors.purple),
                        const SizedBox(height: 16),
                        Text('No projects found', style: AppTextStyles.h3),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final project = filtered[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1550),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF2D2070),
                            child: Text(
                              project.number.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            project.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: project.industry != null
                              ? Text(
                                  project.industry!,
                                  style: const TextStyle(
                                    color: Color(0xFF8B7FD4),
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: Icon(
                              project.demoUrl != null ? Icons.language :
                              project.youtubeUrl != null ? Icons.play_circle_outline :
                              project.githubUrl != null ? Icons.code :
                              Icons.link,
                              color: const Color(0xFF6B5CE7),
                            ),
                            onPressed: () => _openLink(project.primaryUrl),
                          ),
                        ),
                      ).animate(delay: Duration(milliseconds: index * 50)).fadeIn().slideY(begin: 0.1);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

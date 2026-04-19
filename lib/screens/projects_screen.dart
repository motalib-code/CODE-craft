import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../data/projects_data.dart';
import '../models/project_model.dart';
import '../widgets/category_chip.dart';
import '../widgets/category_section.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selectedCategory = 'all';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<ProjectCategory> get _filteredCategories {
    List<ProjectCategory> categories = ProjectsData.projectCategories;

    if (selectedCategory != 'all') {
      categories = categories.where((c) => c.id == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      return categories
          .map((cat) {
            final filteredItems = cat.projects.where((p) {
              return p.name.toLowerCase().contains(query) ||
                  (p.description?.toLowerCase().contains(query) ?? false) ||
                  (p.industry?.toLowerCase().contains(query) ?? false);
            }).toList();

            return ProjectCategory(
              id: cat.id,
              name: cat.name,
              title: cat.title,
              repoUrl: cat.repoUrl,
              description: cat.description,
              tags: cat.tags,
              projects: filteredItems,
            );
          })
          .where((cat) => cat.projects.isNotEmpty)
          .toList();
    }

    return categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _filteredCategories;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Projects',
            style: TextStyle(fontWeight: FontWeight.bold)),
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

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CategoryChip(
                  label: 'All',
                  isSelected: selectedCategory == 'all',
                  onTap: () => setState(() => selectedCategory = 'all'),
                ),
                CategoryChip(
                  label: 'Web & Full Stack',
                  isSelected: selectedCategory == 'web',
                  onTap: () => setState(() => selectedCategory = 'web'),
                ),
                CategoryChip(
                  label: 'AI Agents',
                  isSelected: selectedCategory == 'ai',
                  onTap: () => setState(() => selectedCategory = 'ai'),
                ),
                CategoryChip(
                  label: 'ML & AI',
                  isSelected: selectedCategory == 'ml',
                  onTap: () => setState(() => selectedCategory = 'ml'),
                ),
                CategoryChip(
                  label: 'C++ DSA',
                  isSelected: selectedCategory == 'cpp',
                  onTap: () => setState(() => selectedCategory = 'cpp'),
                ),
                CategoryChip(
                  label: 'Final Year',
                  isSelected: selectedCategory == 'final',
                  onTap: () => setState(() => selectedCategory = 'final'),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),
          ),

          const SizedBox(height: 16),

          // Project List
          Expanded(
            child: filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64, color: AppColors.purple),
                        const SizedBox(height: 16),
                        Text('No projects found', style: AppTextStyles.h1),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      return CategorySection(
                              category: filteredCategories[index])
                          .animate()
                          .fadeIn(
                              delay:
                                  Duration(milliseconds: 200 + (index * 100)))
                          .slideY(begin: 0.1);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

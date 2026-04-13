import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../models/roadmap_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/roadmap_notifier.dart';
import 'package:go_router/go_router.dart';

class RoadmapExplorerScreen extends ConsumerStatefulWidget {
  const RoadmapExplorerScreen({super.key});

  @override
  ConsumerState<RoadmapExplorerScreen> createState() => _RoadmapExplorerScreenState();
}

class _RoadmapExplorerScreenState extends ConsumerState<RoadmapExplorerScreen> {
  List<RoadmapSummary> _allRoadmaps = [];
  List<RoadmapSummary> _filteredRoadmaps = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoadmaps();
  }

  Future<void> _loadRoadmaps() async {
    try {
      final String response = await rootBundle.loadString('assets/data/roadmaps_summary.json');
      final data = await json.decode(response) as List;
      setState(() {
        _allRoadmaps = data.map((e) => RoadmapSummary.fromJson(e)).toList();
        _filteredRoadmaps = _allRoadmaps;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading roadmaps: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filter(String query) {
    setState(() {
      _filteredRoadmaps = _allRoadmaps
          .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        GradientText(
                          text: 'Explore Roadmaps',
                          style: AppTextStyles.h2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filter,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search for skills, roles...',
                        hintStyle: const TextStyle(color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.search, color: AppColors.purple),
                        filled: true,
                        fillColor: AppColors.bgInput,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRoadmaps.isEmpty
                      ? const Center(child: Text('No roadmaps found', style: TextStyle(color: Colors.white)))
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _filteredRoadmaps.length,
                          itemBuilder: (context, i) {
                            final roadmap = _filteredRoadmaps[i];
                            return FadeInUp(
                              delay: Duration(milliseconds: i * 50),
                              child: GlassCard(
                                onTap: () {
                                  // Update the roadmap notifier with selected roadmap
                                  ref.read(roadmapNotifierProvider.notifier).loadRoadmap(roadmap.name);
                                  // Navigate to the main roadmap view
                                  context.go('/roadmap');
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.purple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.map, color: AppColors.purple, size: 24),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      roadmap.name,
                                      style: AppTextStyles.h3,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${roadmap.topicsCount} topics',
                                      style: AppTextStyles.small,
                                    ),
                                    const Spacer(),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: roadmap.sampleTopics
                                          .take(2)
                                          .map((t) => Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white10,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  t,
                                                  style: const TextStyle(fontSize: 9, color: Colors.white70),
                                                  maxLines: 1,
                                                ),
                                              ))
                                          .toList(),
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
      ),
    );
  }
}

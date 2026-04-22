import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/job.dart';
import '../services/job_service.dart';
import '../services/notification_service.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<Job> allJobs = [];
  List<Job> filteredJobs = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedFilter = 'All';
  bool showSavedOnly = false;
  final TextEditingController searchCtrl = TextEditingController();

  final List<String> filters = [
    'All', 'Remote', 'Flutter', 'React', 'Python', 'AI/ML',
    'Backend', 'Frontend', 'DevOps', 'Java', 'iOS', 'Android',
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
    NotificationService.startJobPolling(
      onNewJob: (job) => setState(() {
        if (!allJobs.any((j) => j.id == job.id)) {
          allJobs.insert(0, job);
          _applyFilters();
        }
      }),
      interval: const Duration(minutes: 30),
    );
  }

  Future<void> _loadJobs() async {
    setState(() => isLoading = true);
    try {
      final jobs = await JobService.fetchAllJobs(
        query: selectedFilter != 'All' ? selectedFilter : null,
      );
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('saved_jobs') ?? [];
      final appliedIds = prefs.getStringList('applied_jobs') ?? [];

      setState(() {
        allJobs = jobs.map((j) {
          j.isSaved = savedIds.contains(j.id);
          j.isApplied = appliedIds.contains(j.id);
          return j;
        }).toList();
        _applyFilters();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _applyFilters() {
    filteredJobs = allJobs.where((j) {
      final matchesSearch = searchQuery.isEmpty ||
        j.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        j.company.toLowerCase().contains(searchQuery.toLowerCase()) ||
        j.tags.any((t) => t.toLowerCase().contains(searchQuery.toLowerCase()));

      final matchesFilter = selectedFilter == 'All' ||
        (selectedFilter == 'Remote' && j.isRemote) ||
        j.tags.any((t) => t.toLowerCase().contains(selectedFilter.toLowerCase())) ||
        j.title.toLowerCase().contains(selectedFilter.toLowerCase());

      final matchesSaved = !showSavedOnly || j.isSaved;
      return matchesSearch && matchesFilter && matchesSaved;
    }).toList();
  }

  Future<void> _toggleSave(Job job) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_jobs') ?? [];
    setState(() => job.isSaved = !job.isSaved);
    if (job.isSaved) saved.add(job.id);
    else saved.remove(job.id);
    await prefs.setStringList('saved_jobs', saved);
    _applyFilters();
  }

  Future<void> _applyJob(Job job) async {
    final prefs = await SharedPreferences.getInstance();
    final applied = prefs.getStringList('applied_jobs') ?? [];
    setState(() => job.isApplied = true);
    applied.add(job.id);
    await prefs.setStringList('applied_jobs', applied);

    final uri = Uri.parse(job.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Applied to ${job.title} at ${job.company}!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildStatsCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1550),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = filteredJobs.length;
    final remoteCount = filteredJobs.where((j) => j.isRemote).length;
    final savedCount = filteredJobs.where((j) => j.isSaved).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Career Jobs')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies, skills',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchCtrl.clear();
                                setState(() {
                                  searchQuery = '';
                                  _applyFilters();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _applyFilters();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final selected = filter == selectedFilter;
                        return ChoiceChip(
                          label: Text(filter),
                          selected: selected,
                          selectedColor: const Color(0xFF6B5CE7),
                          backgroundColor: const Color(0xFF2D2070),
                          onSelected: (_) {
                            setState(() {
                              selectedFilter = filter;
                              _loadJobs();
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: showSavedOnly,
                        onChanged: (value) => setState(() {
                          showSavedOnly = value ?? false;
                          _applyFilters();
                        }),
                      ),
                      const Text('Show saved only', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1550),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  _buildStatsCard('Total', '$total'),
                  const SizedBox(width: 10),
                  _buildStatsCard('Remote', '$remoteCount'),
                  const SizedBox(width: 10),
                  _buildStatsCard('Saved', '$savedCount'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B5CE7)))
                  : RefreshIndicator(
                      onRefresh: _loadJobs,
                      color: const Color(0xFF6B5CE7),
                      child: filteredJobs.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(height: 120),
                                const Center(child: Text('No jobs match your filter', style: TextStyle(color: Colors.white54))),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredJobs.length,
                              itemBuilder: (context, index) {
                                final job = filteredJobs[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1550),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(job.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            ),
                                            if (job.isNew)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.greenAccent.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Text('NEW', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text('${job.company} • ${job.location}', style: const TextStyle(color: Colors.white54)),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: job.tags.map((tag) => Chip(
                                            label: Text(tag, style: const TextStyle(color: Colors.white70)),
                                            backgroundColor: const Color(0xFF2D2070),
                                          )).toList(),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(color: Color(0xFF6B5CE7)),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                ),
                                                onPressed: () => _toggleSave(job),
                                                child: Text(job.isSaved ? 'Saved' : 'Save', style: const TextStyle(color: Color(0xFF6B5CE7))),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: job.isApplied ? Colors.grey : const Color(0xFF6B5CE7),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                ),
                                                onPressed: job.isApplied ? null : () => _applyJob(job),
                                                child: Text(job.isApplied ? 'Applied' : 'Apply', style: const TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(job.salary, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

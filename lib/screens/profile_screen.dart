import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';
import '../widgets/experience_timeline.dart';
import '../widgets/skill_bar_chart.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _linkedinCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _collegeCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  final List<String> _collegeSuggestions = const [
    'IIT Bombay',
    'IIT Delhi',
    'IIT Madras',
    'NIT Trichy',
    'BITS Pilani',
    'VIT Vellore',
    'Manipal Institute of Technology',
    'Delhi Technological University',
  ];

  Future<void> _openUrl(String value) async {
    final uri = Uri.parse(value);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _linkedinCtrl.dispose();
    _githubCtrl.dispose();
    _collegeCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Smart Profile Builder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF21184A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _linkedinCtrl,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn Profile URL',
                      hintText: 'linkedin.com/in/username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _githubCtrl,
                    decoration: const InputDecoration(
                      labelText: 'GitHub Profile URL',
                      hintText: 'github.com/username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Autocomplete<String>(
                    optionsBuilder: (value) {
                      if (value.text.isEmpty) return const Iterable<String>.empty();
                      return _collegeSuggestions.where(
                        (c) => c.toLowerCase().contains(value.text.toLowerCase()),
                      );
                    },
                    onSelected: (selected) => _collegeCtrl.text = selected,
                    fieldViewBuilder: (_, controller, focusNode, __) {
                      controller.text = _collegeCtrl.text;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (v) => _collegeCtrl.text = v,
                        decoration: const InputDecoration(
                          labelText: 'College Name',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _locationCtrl,
                    decoration: InputDecoration(
                      labelText: 'Current Location',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: () async {
                          final loc = await ref
                              .read(profileProvider)
                              .detectCurrentLocation();
                          if (loc != null) {
                            _locationCtrl.text = loc;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.purple, Color(0xFF4A3E99)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: profileState.isLoading
                            ? null
                            : () => ref.read(profileProvider).buildProfile(
                                  githubUrl: _githubCtrl.text,
                                  linkedinUrl: _linkedinCtrl.text,
                                  college: _collegeCtrl.text,
                                  location: _locationCtrl.text,
                                ),
                        child: Text(
                          profileState.isLoading
                              ? profileState.stepLabel
                              : 'Build My Profile',
                        ),
                      ),
                    ),
                  ),
                  if (profileState.error != null) ...[
                    const SizedBox(height: 10),
                    Text(profileState.error!, style: const TextStyle(color: Colors.redAccent)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (profileState.isLoading)
              const LinearProgressIndicator(minHeight: 4)
            else if (profile != null) ...[
              _HeroCard(profile: profile, onOpenUrl: _openUrl).animate().fadeIn(),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Skills (Top 8)',
                child: SkillBarChart(
                  data: _skillData(profile.skills, profile.languageStats),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Experience Timeline',
                child: ExperienceTimeline(experiences: profile.experiences),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Top GitHub Projects',
                child: Column(
                  children: profile.topRepos
                      .map(
                        (repo) => Card(
                          color: const Color(0xFF2A2060),
                          child: ListTile(
                            title: Text(repo.name),
                            subtitle: Text(repo.description),
                            trailing: Text('⭐ ${repo.stars}'),
                            leading: Chip(label: Text(repo.language)),
                            onTap: () => _openUrl(repo.url),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Education',
                child: Column(
                  children: [
                    ...profile.educations.map(
                      (e) => Card(
                        color: const Color(0xFF2A2060),
                        child: ListTile(
                          leading: const Icon(Icons.school),
                          title: Text('${e.degree} ${e.fieldOfStudy}'.trim()),
                          subtitle: Text('${e.school}\n${e.startDate} - ${e.endDate}'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(20.5937, 78.9629),
                          initialZoom: 3.8,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.codecraft.hackthon_app',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'College Batch Network Insights',
                child: Column(
                  children: profile.networkInsights
                      .map(
                        (i) => ListTile(
                          leading: const Icon(Icons.insights),
                          title: Text(i),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Connection Strength Score',
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 62,
                    lineWidth: 10,
                    percent: (profile.profileStrengthScore / 100).clamp(0.0, 1.0),
                    progressColor: AppColors.purple,
                    center: Text(
                      '${profile.profileStrengthScore}/100',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    footer: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('Profile Strength'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Who Should Connect With You',
                child: SizedBox(
                  height: 210,
                  child: PageView(
                    children: profile.connectionSuggestions.map((item) {
                      return Card(
                        color: const Color(0xFF2A2060),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['personType'] ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(item['reason'] ?? ''),
                              const Spacer(),
                              Chip(label: Text(item['searchKeyword'] ?? '')),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, double> _skillData(List<String> skills, Map<String, int> languageStats) {
    final data = <String, double>{};

    for (final entry in languageStats.entries) {
      data[entry.key] = entry.value.toDouble();
    }

    for (final s in skills) {
      data[s] = (data[s] ?? 0) + 1;
    }

    return data;
  }
}

class _HeroCard extends StatelessWidget {
  final dynamic profile;
  final Future<void> Function(String) onOpenUrl;

  const _HeroCard({required this.profile, required this.onOpenUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.purple, Color(0xFF1A1033)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: CachedNetworkImageProvider(profile.avatarUrl),
              ),
              const SizedBox(height: 12),
              Text(
                profile.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                profile.bio,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.code, color: Colors.white),
                    onPressed: () => onOpenUrl('https://github.com/${profile.githubUsername}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.business, color: Colors.white),
                    onPressed: () => onOpenUrl(profile.linkedinUrl),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, color: Colors.white),
                      Text(profile.location),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _statChip('${profile.githubRepos} Repos'),
                  _statChip('${profile.githubStars} Stars'),
                  _statChip('${profile.githubFollowers} Followers'),
                  _statChip('${profile.linkedinConnections} Connections'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF21184A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

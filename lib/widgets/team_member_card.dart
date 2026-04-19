import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/hackathon_team.dart';

class TeamMemberCard extends StatelessWidget {
  final String role;
  final TeamCandidate candidate;
  final VoidCallback onMessage;

  const TeamMemberCard({
    super.key,
    required this.role,
    required this.candidate,
    required this.onMessage,
  });

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF21184A),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(candidate.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(candidate.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('@${candidate.githubUsername}', style: const TextStyle(color: Colors.white70)),
                      Text('Role: $role', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Text('${candidate.matchScore}%'),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: candidate.topSkills
                  .map((s) => Chip(label: Text(s), backgroundColor: Colors.white12))
                  .toList(),
            ),
            const SizedBox(height: 8),
            if (candidate.topRepos.isNotEmpty)
              Text(
                'Top Repo: ${(candidate.topRepos.first['name'] ?? '').toString()} ⭐${candidate.topRepos.first['stars'] ?? 0}',
                style: const TextStyle(fontSize: 13),
              ),
            const SizedBox(height: 8),
            Text(candidate.matchReasons.join(' | ')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _open(candidate.githubUrl),
                    child: const Text('GitHub'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: candidate.linkedinUrl == null
                        ? null
                        : () => _open(candidate.linkedinUrl!),
                    child: const Text('LinkedIn'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onMessage,
                    child: const Text('Message'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

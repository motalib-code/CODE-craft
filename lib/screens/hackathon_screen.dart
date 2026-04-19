import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/hackathon_provider.dart';
import '../widgets/team_member_card.dart';

class HackathonScreen extends ConsumerStatefulWidget {
  const HackathonScreen({super.key});

  @override
  ConsumerState<HackathonScreen> createState() => _HackathonScreenState();
}

class _HackathonScreenState extends ConsumerState<HackathonScreen> {
  final _problemCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();

  String _type = 'Open Innovation';
  int _teamSize = 4;

  @override
  void dispose() {
    _problemCtrl.dispose();
    _githubCtrl.dispose();
    _linkedinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hackathonProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hackathon Team Finder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _problemCtrl,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Paste your Hackathon Problem Statement',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                'Web App',
                'Mobile App',
                'AI/ML',
                'Blockchain',
                'IoT',
                'Open Innovation'
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
              decoration: const InputDecoration(labelText: 'Hackathon Type'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _teamSize,
              items: const [2, 3, 4, 5]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e members')))
                  .toList(),
              onChanged: (v) => setState(() => _teamSize = v ?? _teamSize),
              decoration: const InputDecoration(labelText: 'Team Size'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _githubCtrl,
              decoration: const InputDecoration(labelText: 'Your GitHub Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _linkedinCtrl,
              decoration: const InputDecoration(labelText: 'Your LinkedIn URL (optional)'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => ref.read(hackathonProvider).findTeam(
                          problemStatement: _problemCtrl.text,
                          hackathonType: _type,
                          teamSize: _teamSize,
                          githubUsername: _githubCtrl.text,
                          linkedinUrl: _linkedinCtrl.text.isEmpty ? null : _linkedinCtrl.text,
                        ),
                child: Text(state.isLoading ? 'Finding team...' : 'Find Best Team Members'),
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(state.error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 16),
            if (state.analysis != null)
              _problemAnalysisCard(state),
            const SizedBox(height: 12),
            if (state.result != null) _teamCard(state),
            if (state.result != null) ...[
              const SizedBox(height: 12),
              _strengthWeaknessCard(state),
              const SizedBox(height: 12),
              _allCandidatesCard(state),
            ]
          ],
        ),
      ),
    );
  }

  Widget _problemAnalysisCard(HackathonProvider state) {
    final analysis = state.analysis!;
    return Card(
      color: const Color(0xFF3D2D87),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(analysis.problemSummary),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: analysis.techStack.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 8),
            const Text('Roles Needed:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: analysis.requiredRoles
                  .map((e) => Chip(label: Text('${e.role} (${e.importance})')))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamCard(HackathonProvider state) {
    final result = state.result!;
    return Card(
      color: const Color(0xFF21184A),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Dream Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Team Chemistry: ${result.teamChemistryScore}% | Win Probability: ${result.winProbability}'),
            const SizedBox(height: 10),
            ...result.recommendedTeam.map((recommendation) {
              final message = ref.read(hackathonProvider).generateMessageTemplate(
                    name: recommendation.candidate.name,
                    hackathonType: _type,
                    problemSummary: state.analysis?.problemSummary ?? '',
                    topSkills: recommendation.candidate.topSkills,
                  );

              return TeamMemberCard(
                role: recommendation.role,
                candidate: recommendation.candidate,
                onMessage: () async {
                  await ref.read(hackathonProvider).copyMessageTemplate(message);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message copied to clipboard.')),
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _strengthWeaknessCard(HackathonProvider state) {
    final result = state.result!;
    return Card(
      color: const Color(0xFF21184A),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Team Strengths', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.teamStrengths
                  .map((e) => Chip(label: Text(e), backgroundColor: Colors.green.withOpacity(0.2)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            const Text('Team Weaknesses', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.teamWeaknesses
                  .map((e) => Chip(label: Text(e), backgroundColor: Colors.red.withOpacity(0.2)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text('Pitch Strategy: ${result.pitchAdvice}'),
          ],
        ),
      ),
    );
  }

  Widget _allCandidatesCard(HackathonProvider state) {
    return Card(
      color: const Color(0xFF21184A),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All Candidates', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...state.allCandidates.map(
              (c) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage((c['avatar'] ?? '').toString()),
                ),
                title: Text((c['name'] ?? c['login'] ?? '').toString()),
                subtitle: Text('Followers: ${(c['followers'] ?? 0)} | Location: ${(c['location'] ?? 'N/A')}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

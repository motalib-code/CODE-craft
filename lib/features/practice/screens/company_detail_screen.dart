import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/lc_problems_data.dart';
import '../../../models/company.dart';
import '../../../models/lc_problem.dart';
import 'problem_detail_screen.dart';

class CompanyDetailScreen extends StatelessWidget {
  const CompanyDetailScreen({super.key, required this.company, required this.tricks});

  final Company company;
  final String tricks;

  Future<void> _open(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LCProblem> companyProblems = allProblems
        .where((p) => p.companies.map((e) => e.toLowerCase()).contains(company.name.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1033),
      appBar: AppBar(
        title: Text('${company.name} Problems'),
        backgroundColor: const Color(0xFF1A1033),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1550),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.4)),
            ),
            child: Text('Tricks: $tricks', style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _open(company.problemsUrl),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
            child: const Text('LeetCode Company Problems -> GitHub'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _open('https://drive.google.com/drive/folders/1NlbJI1MAfb4UfL5h5AoaeO6-UlA3hF22'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('DSA Problems Sheet -> Drive'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _open('https://roadmap.swadhin.cv'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('FAANG Playbook -> roadmap.swadhin.cv'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _open('https://leetcode.com/problemset/?search=${company.slug}'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
            child: const Text('LeetCode Filter -> company search'),
          ),
          const SizedBox(height: 20),
          Text(
            'Top Problems for ${company.name}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          if (companyProblems.isEmpty)
            const Text('No mapped problems yet for this company.', style: TextStyle(color: Colors.white54))
          else
            ...companyProblems.take(25).map((p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(p.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${p.difficulty} | ${p.pattern}', style: const TextStyle(color: Colors.white60)),
                  trailing: Text('#${p.id}', style: const TextStyle(color: Color(0xFF6B5CE7))),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProblemDetailScreen(problemSlug: p.id.toString(), problem: p),
                      ),
                    );
                  },
                )),
        ],
      ),
    );
  }
}

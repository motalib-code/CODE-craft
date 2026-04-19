import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CareerHomeScreen extends StatelessWidget {
  final VoidCallback onOpenResumeChecker;

  const CareerHomeScreen({
    super.key,
    required this.onOpenResumeChecker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1033), Color(0xFF100B22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Text(
            'Portfolio & Career Assistant',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Build your profile, improve resume, plan roadmap, and find hackathon teams.',
          ),
          const SizedBox(height: 16),
          _featureCard(
            title: 'Smart Profile Builder',
            subtitle: 'Fetch GitHub + LinkedIn and generate AI networking insights.',
            icon: Icons.person_search,
          ),
          _featureCard(
            title: 'Roadmap Advisor',
            subtitle: 'Get AI milestones, weekly tasks, and job-readiness tracking.',
            icon: Icons.map,
          ),
          _featureCard(
            title: 'Hackathon Team Finder',
            subtitle: 'Analyze statement, discover and rank ideal teammates.',
            icon: Icons.groups_rounded,
          ),
          Card(
            color: const Color(0xFF2B1E5A),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: const Text('AI Resume Checker'),
              subtitle: const Text('Upload PDF or paste text and get ATS-ready feedback.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: onOpenResumeChecker,
            ),
          ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.purple, Color(0xFF4A3E99)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: onOpenResumeChecker,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Check My Resume Now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      color: const Color(0xFF21184A),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF3A2C82),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

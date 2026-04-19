import 'package:flutter/material.dart';

import 'career_home_screen.dart';
import 'hackathon_screen.dart';
import 'profile_screen.dart';
import 'resume_checker_screen.dart';
import 'roadmap_screen.dart';
import 'projects_screen.dart';

class CareerAssistantShellScreen extends StatefulWidget {
  const CareerAssistantShellScreen({super.key});

  @override
  State<CareerAssistantShellScreen> createState() =>
      _CareerAssistantShellScreenState();
}

class _CareerAssistantShellScreenState
    extends State<CareerAssistantShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      CareerHomeScreen(
        onOpenResumeChecker: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ResumeCheckerScreen()),
          );
        },
      ),
      const CareerRoadmapScreen(),
      const ProjectsScreen(),
      const ProfileScreen(),
      const HackathonScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Roadmap'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Team'),
        ],
      ),
    );
  }
}

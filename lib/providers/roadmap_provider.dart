import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/roadmap.dart';
import '../services/gemini_service.dart';

final roadmapProvider = ChangeNotifierProvider<RoadmapProvider>((ref) {
  return RoadmapProvider(geminiService: CareerGeminiService());
});

class RoadmapAnswers {
  final String goal;
  final String domain;
  final String level;
  final String dailyHours;
  final String timeline;
  final List<String> currentSkills;
  final List<String> completedProjects;

  const RoadmapAnswers({
    required this.goal,
    required this.domain,
    required this.level,
    required this.dailyHours,
    required this.timeline,
    required this.currentSkills,
    required this.completedProjects,
  });
}

class RoadmapProvider extends ChangeNotifier {
  RoadmapProvider({required CareerGeminiService geminiService})
      : _geminiService = geminiService;

  final CareerGeminiService _geminiService;

  RoadmapAnswers? answers;
  CareerRoadmap? roadmap;
  bool isLoading = false;
  String? error;

  final Set<String> _completedTaskKeys = <String>{};

  Future<void> loadTaskState() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('career_weekly_task_checks') ?? <String>[];
    _completedTaskKeys
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  Future<void> saveAnswers(RoadmapAnswers value) async {
    answers = value;
    notifyListeners();
  }

  Future<void> generateRoadmap() async {
    if (answers == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final a = answers!;
      final response = await _geminiService.generateJson(
        prompt: '''
You are a senior tech career coach. Based on this profile:
- Goal: ${a.goal}
- Domain: ${a.domain}
- Current Skills: ${a.currentSkills.join(', ')}
- Completed Projects: ${a.completedProjects.join(', ')}
- Level: ${a.level}
- Daily time: ${a.dailyHours}
- Timeline: ${a.timeline}
Create a detailed roadmap and return ONLY JSON:
{
  "currentStatus": "You are at X level in Y domain",
  "completedItems": [{"item": "...", "evidence": "...", "completedDate": "..."}],
  "inProgressItems": [{"item": "...", "percentDone": 60, "nextStep": "..."}],
  "todoItems": [{
    "priority": 1,
    "title": "...",
    "description": "...",
    "estimatedDays": 30,
    "resources": [{"name": "...", "url": "...", "type": "video/article/course", "isFree": true}],
    "milestone": "Week 1-2"
  }],
  "weeklyPlan": [{"week": 1, "focus": "...", "tasks": ["task1", "task2"], "goal": "..."}],
  "milestones": [{"month": 1, "achievement": "...", "checkItems": ["...", "..."]}],
  "jobReadinessScore": 0,
  "nextImportantAction": "The single most important thing to do TODAY"
}
''',
      );

      roadmap = CareerRoadmap.fromJson(response);
    } catch (e) {
      error = 'Failed to generate roadmap: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isTaskComplete(int week, String task) {
    return _completedTaskKeys.contains(_key(week, task));
  }

  Future<void> toggleTaskComplete(int week, String task) async {
    final key = _key(week, task);
    if (_completedTaskKeys.contains(key)) {
      _completedTaskKeys.remove(key);
    } else {
      _completedTaskKeys.add(key);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'career_weekly_task_checks',
      _completedTaskKeys.toList(),
    );
    notifyListeners();
  }

  double getCompletionPercentage() {
    final weekly = roadmap?.weeklyPlan ?? <WeeklyPlan>[];
    final total = weekly.fold<int>(0, (sum, w) => sum + w.tasks.length);
    if (total == 0) return 0;

    var done = 0;
    for (final w in weekly) {
      for (final task in w.tasks) {
        if (isTaskComplete(w.week, task)) {
          done++;
        }
      }
    }
    return done / total;
  }

  String exportRoadmapJson() {
    if (roadmap == null) return '{}';
    return const JsonEncoder.withIndent('  ').convert({
      'currentStatus': roadmap!.currentStatus,
      'jobReadinessScore': roadmap!.jobReadinessScore,
      'nextImportantAction': roadmap!.nextImportantAction,
      'todoCount': roadmap!.todoItems.length,
      'completedCount': roadmap!.completedItems.length,
    });
  }

  String _key(int week, String task) => '$week::$task';
}

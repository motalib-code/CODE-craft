import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hackathon_team.dart';
import '../services/gemini_service.dart';
import '../services/github_service.dart';

final hackathonProvider = ChangeNotifierProvider<HackathonProvider>((ref) {
  return HackathonProvider(
    geminiService: CareerGeminiService(),
    githubService: GithubApiService(),
  );
});

class HackathonProvider extends ChangeNotifier {
  HackathonProvider({
    required CareerGeminiService geminiService,
    required GithubApiService githubService,
  })  : _geminiService = geminiService,
        _githubService = githubService;

  final CareerGeminiService _geminiService;
  final GithubApiService _githubService;

  ProblemAnalysis? analysis;
  HackathonTeamResult? result;
  List<Map<String, dynamic>> allCandidates = <Map<String, dynamic>>[];
  bool isLoading = false;
  String? error;

  Future<void> findTeam({
    required String problemStatement,
    required String hackathonType,
    required int teamSize,
    required String githubUsername,
    String? linkedinUrl,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      analysis = await analyzeProblem(
        statement: problemStatement,
        hackathonType: hackathonType,
      );

      allCandidates = await searchGitHubCandidates(analysis!.requiredRoles);

      result = await scoreAndRankCandidates(
        roles: analysis!.requiredRoles,
        problemSummary: analysis!.problemSummary,
        candidateProfiles: allCandidates,
      );

      // Keep requested team size limit in UI model.
      if (result != null) {
        result = HackathonTeamResult(
          recommendedTeam: result!.recommendedTeam.take(teamSize).toList(),
          teamChemistryScore: result!.teamChemistryScore,
          winProbability: result!.winProbability,
          teamStrengths: result!.teamStrengths,
          teamWeaknesses: result!.teamWeaknesses,
          pitchAdvice: result!.pitchAdvice,
        );
      }
    } catch (e) {
      error = 'Hackathon analysis failed: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ProblemAnalysis> analyzeProblem({
    required String statement,
    required String hackathonType,
  }) async {
    final response = await _geminiService.generateJson(
      prompt: '''
Analyze this hackathon problem statement and return ONLY JSON:
Problem: $statement
Type: $hackathonType
{
  "problemSummary": "...",
  "requiredRoles": [
    {
      "role": "Full Stack Developer",
      "skills": ["React", "Node.js", "MongoDB"],
      "importance": "critical/important/nice-to-have",
      "githubSearchQuery": "language:javascript stars:>10",
      "linkedinSearchQuery": "Full Stack Developer React Node.js"
    }
  ],
  "techStack": ["React", "Python", "TensorFlow"],
  "winningStrategy": "...",
  "yourRole": "Based on user skills, they should be the ..."
}
''',
    );

    return ProblemAnalysis.fromJson(response);
  }

  Future<List<Map<String, dynamic>>> searchGitHubCandidates(
    List<RequiredRole> roles,
  ) async {
    final pool = <Map<String, dynamic>>[];
    final seen = <String>{};

    for (final role in roles) {
      final users = await _githubService.searchUsersByQuery(role.githubSearchQuery);
      for (final user in users) {
        final login = (user['login'] ?? '').toString();
        if (login.isEmpty || seen.contains(login)) continue;
        seen.add(login);
        final profile = await _githubService.fetchCandidateProfile(login);
        pool.add(profile);
      }
    }

    return pool;
  }

  Future<HackathonTeamResult> scoreAndRankCandidates({
    required List<RequiredRole> roles,
    required String problemSummary,
    required List<Map<String, dynamic>> candidateProfiles,
  }) async {
    final rolesJson = roles
        .map(
          (r) => {
            'role': r.role,
            'skills': r.skills,
            'importance': r.importance,
          },
        )
        .toList();

    final response = await _geminiService.generateJson(
      prompt: '''
You are a hackathon team builder expert.
Required roles: ${jsonEncode(rolesJson)}
Problem: $problemSummary
Candidate profiles: ${jsonEncode(candidateProfiles)}
Score each candidate for each role (0-100) and return ONLY JSON:
{
  "recommendedTeam": [
    {
      "role": "Full Stack Developer",
      "candidate": {
        "githubUsername": "...",
        "name": "...",
        "matchScore": 85,
        "matchReasons": ["..."],
        "topSkills": ["React", "Node.js"],
        "topRepos": [{"name": "...", "stars": 23, "url": "..."}],
        "githubUrl": "...",
        "avatarUrl": "...",
        "contactSuggestion": "Message on GitHub issues or LinkedIn"
      }
    }
  ],
  "teamChemistryScore": 88,
  "winProbability": "72%",
  "teamStrengths": ["..."],
  "teamWeaknesses": ["..."],
  "pitchAdvice": "..."
}
''',
      maxTokens: 8192,
    );

    return HackathonTeamResult.fromJson(response);
  }

  String generateMessageTemplate({
    required String name,
    required String hackathonType,
    required String problemSummary,
    required List<String> topSkills,
  }) {
    return 'Hi $name! I am building a team for $hackathonType hackathon. '
        'Our problem: $problemSummary. Your ${topSkills.join(', ')} skills would be perfect. Interested?';
  }

  Future<void> copyMessageTemplate(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

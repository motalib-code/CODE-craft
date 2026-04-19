import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/user_profile.dart';
import '../services/gemini_service.dart';
import '../services/github_service.dart';
import '../services/linkedin_service.dart';

final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  return ProfileProvider(
    githubApi: GithubApiService(),
    linkedinApi: LinkedinService(),
    geminiApi: CareerGeminiService(),
  );
});

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({
    required GithubApiService githubApi,
    required LinkedinService linkedinApi,
    required CareerGeminiService geminiApi,
  })  : _githubApi = githubApi,
        _linkedinApi = linkedinApi,
        _geminiApi = geminiApi;

  final GithubApiService _githubApi;
  final LinkedinService _linkedinApi;
  final CareerGeminiService _geminiApi;

  UserProfile? profile;
  bool isLoading = false;
  String? error;
  String stepLabel = '';

  Future<String?> detectCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final asked = await Geolocator.requestPermission();
        if (asked == LocationPermission.denied ||
            asked == LocationPermission.deniedForever) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (places.isEmpty) return null;
      final p = places.first;
      return [p.locality, p.administrativeArea, p.country]
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .join(', ');
    } catch (_) {
      return null;
    }
  }

  Future<void> buildProfile({
    required String githubUrl,
    required String linkedinUrl,
    required String college,
    required String location,
  }) async {
    isLoading = true;
    error = null;
    stepLabel = 'Fetching GitHub...';
    notifyListeners();

    try {
      final githubProfile = await _githubApi.fetchProfile(githubUrl);
      final topRepos = await _githubApi.fetchTopRepositories(githubUrl);
      final allRepos = await _githubApi.fetchAllRepositories(githubUrl);
      final stars = _githubApi.calculateTotalStars(allRepos);
      final languageStats = _githubApi.aggregateLanguageStats(allRepos);

      stepLabel = 'Fetching LinkedIn...';
      notifyListeners();

      final linkedin = await _linkedinApi.fetchProfileByUrl(linkedinUrl);

      final mergedSkills = <String>{
        ...languageStats.keys.where((e) => e.toLowerCase() != 'unknown'),
        ...linkedin.skills,
      }.toList();

      stepLabel = 'Generating AI insights...';
      notifyListeners();

      final networkInsights = await _generateBatchNetworkInsights(
        college: college,
        experiences: linkedin.experiences.map((e) => e.title).join(', '),
        connections: linkedin.connectionsCount,
      );

      final connectSuggestions = await _generateConnectSuggestions(
        name: linkedin.fullName.isNotEmpty ? linkedin.fullName : githubProfile.name,
        skills: mergedSkills,
        experience: linkedin.experiences.map((e) => e.title).join(', '),
        repos: topRepos.map((e) => e.name).join(', '),
        college: college,
        location: location,
      );

      final strengthScore = _calculateStrengthScore(
        githubRepos: githubProfile.publicRepos,
        linkedinConnections: linkedin.connectionsCount,
        skillsCount: mergedSkills.length,
        experienceCount: linkedin.experiences.length,
      );

      profile = UserProfile(
        githubUsername: githubProfile.username,
        linkedinUrl: linkedinUrl,
        name: linkedin.fullName.isNotEmpty ? linkedin.fullName : githubProfile.name,
        bio: linkedin.headline.isNotEmpty ? linkedin.headline : githubProfile.bio,
        avatarUrl: linkedin.profilePicture.isNotEmpty
            ? linkedin.profilePicture
            : githubProfile.avatarUrl,
        location: location.isNotEmpty ? location : githubProfile.location,
        college: college,
        githubRepos: githubProfile.publicRepos,
        githubStars: stars,
        githubFollowers: githubProfile.followers,
        linkedinConnections: linkedin.connectionsCount,
        skills: mergedSkills,
        experiences: linkedin.experiences,
        educations: linkedin.educations,
        topRepos: topRepos.take(5).toList(),
        languageStats: languageStats,
        profileStrengthScore: strengthScore,
        connectionSuggestions: connectSuggestions,
        networkInsights: networkInsights,
      );
      stepLabel = 'Done!';
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int _calculateStrengthScore({
    required int githubRepos,
    required int linkedinConnections,
    required int skillsCount,
    required int experienceCount,
  }) {
    final repos = (githubRepos / 50 * 25).clamp(0, 25).round();
    final connections = (linkedinConnections / 500 * 25).clamp(0, 25).round();
    final skills = (skillsCount / 20 * 25).clamp(0, 25).round();
    final exp = (experienceCount / 6 * 25).clamp(0, 25).round();
    return repos + connections + skills + exp;
  }

  Future<List<String>> _generateBatchNetworkInsights({
    required String college,
    required int connections,
    required String experiences,
  }) async {
    final response = await _geminiApi.generateJson(
      prompt: '''
Given this person studied at $college and their LinkedIn shows $connections connections, and experience: $experiences,
suggest peer network insights and collaborations they should seek.
Return only JSON with shape:
{
  "insights": ["You likely have X batchmates on LinkedIn", "Best people to connect from your college for Y", "Your college alumni working at top companies"]
}
''',
    );

    return (response['insights'] as List? ?? <dynamic>[])
        .map((e) => e.toString())
        .toList();
  }

  Future<List<Map<String, String>>> _generateConnectSuggestions({
    required String name,
    required List<String> skills,
    required String experience,
    required String repos,
    required String college,
    required String location,
  }) async {
    final response = await _geminiApi.generateJson(
      prompt: '''
Based on this developer profile: $name,
skills: ${skills.join(', ')},
experience: $experience,
projects: $repos,
college: $college,
location: $location.
Suggest top 5 types of people who should connect with them on LinkedIn and why.
Return JSON array only with fields: personType, reason, searchKeyword
{
 "items": [
   {"personType": "...", "reason": "...", "searchKeyword": "..."}
 ]
}
''',
    );

    return (response['items'] as List? ?? <dynamic>[])
        .whereType<Map>()
        .map(
          (e) => {
            'personType': (e['personType'] ?? '').toString(),
            'reason': (e['reason'] ?? '').toString(),
            'searchKeyword': (e['searchKeyword'] ?? '').toString(),
          },
        )
        .toList();
  }
}

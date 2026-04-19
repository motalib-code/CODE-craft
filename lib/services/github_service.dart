import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/github_profile.dart';

class GithubApiService {
  GithubApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    if (ApiConfig.githubToken.startsWith('ghp_')) {
      headers['Authorization'] = 'Bearer ${ApiConfig.githubToken}';
    }
    return headers;
  }

  String extractUsername(String input) {
    if (input.contains('github.com/')) {
      final chunk = input.split('github.com/').last;
      return chunk.split('/').first.trim();
    }
    return input.trim().replaceAll('@', '');
  }

  Future<GithubProfile> fetchProfile(String usernameOrUrl) async {
    final username = extractUsername(usernameOrUrl);
    final response = await _client.get(
      Uri.parse('${ApiConfig.githubBase}/users/$username'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('GitHub profile not found (${response.statusCode}).');
    }

    return GithubProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<GithubRepo>> fetchTopRepositories(String usernameOrUrl) async {
    final username = extractUsername(usernameOrUrl);
    final response = await _client.get(
      Uri.parse(
        '${ApiConfig.githubBase}/users/$username/repos?sort=stars&per_page=10',
      ),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Unable to fetch top repositories (${response.statusCode}).');
    }

    final repos = (jsonDecode(response.body) as List)
        .map((e) => GithubRepo.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.stars.compareTo(a.stars));

    return repos;
  }

  Future<List<GithubRepo>> fetchAllRepositories(String usernameOrUrl) async {
    final username = extractUsername(usernameOrUrl);
    final response = await _client.get(
      Uri.parse('${ApiConfig.githubBase}/users/$username/repos?per_page=100'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch repositories (${response.statusCode}).');
    }

    return (jsonDecode(response.body) as List)
        .map((e) => GithubRepo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, int> aggregateLanguageStats(List<GithubRepo> repos) {
    final stats = <String, int>{};
    for (final repo in repos) {
      final language = repo.language.isEmpty ? 'Unknown' : repo.language;
      stats[language] = (stats[language] ?? 0) + 1;
    }
    return stats;
  }

  int calculateTotalStars(List<GithubRepo> repos) {
    return repos.fold<int>(0, (sum, repo) => sum + repo.stars);
  }

  Future<List<Map<String, dynamic>>> searchUsersByQuery(String query) async {
    final encoded = Uri.encodeQueryComponent(query);
    final response = await _client.get(
      Uri.parse(
        '${ApiConfig.githubBase}/search/users?q=$encoded&sort=followers&per_page=5',
      ),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('GitHub user search failed (${response.statusCode}).');
    }

    final items =
        (jsonDecode(response.body) as Map<String, dynamic>)['items'] as List?;
    if (items == null) return <Map<String, dynamic>>[];

    return items
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> fetchCandidateProfile(String username) async {
    final profile = await fetchProfile(username);
    final repos = await fetchTopRepositories(username);

    final languageSet = <String>{
      ...repos.map((e) => e.language).where((e) => e.isNotEmpty),
    };

    return {
      'name': profile.name,
      'login': profile.username,
      'avatar': profile.avatarUrl,
      'bio': profile.bio,
      'location': profile.location,
      'public_repos': profile.publicRepos,
      'followers': profile.followers,
      'top_languages': languageSet.toList(),
      'top_repos': repos
          .take(5)
          .map(
            (e) => {
              'name': e.name,
              'stars': e.stars,
              'url': e.url,
              'language': e.language,
            },
          )
          .toList(),
      'github_url': profile.htmlUrl,
    };
  }
}

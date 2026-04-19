import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/github_profile_model.dart';

class GithubService {
  static Future<String> fetchReadme(String readmeUrl) async {
    final response = await http.get(Uri.parse(readmeUrl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('README fetch failed');
    }
  }

  static Future<GitHubProfile> fetchGitHubProfile(String username) async {
    // Clean username if full URL pasted
    final cleanUser = username.contains('github.com/')
        ? username.split('github.com/').last.split('/').first
        : username;

    // 1. Get User Profile
    final userRes = await http.get(Uri.parse('https://api.github.com/users/$cleanUser'));
    if (userRes.statusCode != 200) throw Exception('GitHub user not found');

    final userData = jsonDecode(userRes.body);

    // 2. Get Top 5 Repos
    final repoRes = await http.get(Uri.parse('https://api.github.com/users/$cleanUser/repos?sort=updated&per_page=5'));
    final List<dynamic> repoList = repoRes.statusCode == 200 ? jsonDecode(repoRes.body) : [];

    final repos = repoList.map((r) => GitHubRepo(
      name: r['name'],
      description: r['description'],
      stars: r['stargazers_count'],
      language: r['language'],
      htmlUrl: r['html_url'],
    )).toList();

    return GitHubProfile(
      username: cleanUser,
      avatarUrl: userData['avatar_url'],
      name: userData['name'],
      bio: userData['bio'],
      location: userData['location'],
      followers: userData['followers'],
      following: userData['following'],
      topRepos: repos,
    );
  }
}

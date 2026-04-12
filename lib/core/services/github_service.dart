import 'dart:convert';
import 'package:http/http.dart' as http;

class GithubService {
  static const _base = 'https://api.github.com';

  Future<Map<String, dynamic>?> getUserProfile(String username) async {
    try {
      final response = await http
          .get(Uri.parse('$_base/users/$username'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserRepos(String username) async {
    try {
      final response = await http
          .get(Uri.parse(
              '$_base/users/$username/repos?sort=updated&per_page=10'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

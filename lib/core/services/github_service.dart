import 'package:http/http.dart' as http;

class GithubService {
  static Future<String> fetchReadme(String readmeUrl) async {
    final response = await http.get(Uri.parse(readmeUrl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('README fetch failed');
    }
  }
}

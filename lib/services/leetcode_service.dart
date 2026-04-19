import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../models/leetcode_problem.dart';

class LeetCodeService {
  static final LeetCodeService _instance = LeetCodeService._internal();

  factory LeetCodeService() {
    return _instance;
  }

  LeetCodeService._internal();

  Future<List<LeetCodeProblem>> fetchProblems({
    int limit = 50,
    int offset = 0,
    String difficulty = '',
  }) async {
    try {
      final query = '''
      {
        problemsetQuestionList(
          categorySlug: ""
          limit: $limit
          skip: $offset
          filters: ${difficulty.isNotEmpty ? '{"difficulty":"$difficulty"}' : '{}'}
        ) {
          total: totalNum
          questions: data {
            acRate
            difficulty
            freqBar
            frontendQuestionId: questionFrontendId
            isFavor
            paidOnly: isPaidOnly
            status
            title
            titleSlug
            topicTags {
              name
              id
              slug
            }
            hasSolution
            hasVideoSolution
          }
        }
      }
      ''';

      final response = await http.post(
        Uri.parse(ApiConfig.leetcodeGraphQL),
        headers: {
          'Content-Type': 'application/json',
          'Referer': 'https://leetcode.com',
        },
        body: jsonEncode({'query': query}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          final problems = data['data']['problemsetQuestionList']['questions'] as List?;
          return problems?.map((p) => LeetCodeProblem.fromJson(p)).toList() ?? [];
        }
      }
      return [];
    } catch (e) {
      print('LeetCode fetch error: $e');
      return [];
    }
  }

  Future<LeetCodeProblem?> fetchProblemDetail(String titleSlug) async {
    try {
      final query = '''
      {
        question(titleSlug: "$titleSlug") {
          questionId
          title
          content
          difficulty
          topicTags { name }
          hints
          sampleTestCase
          exampleTestcaseList
          likes
          dislikes
          similarQuestions
        }
      }
      ''';

      final response = await http.post(
        Uri.parse(ApiConfig.leetcodeGraphQL),
        headers: {
          'Content-Type': 'application/json',
          'Referer': 'https://leetcode.com',
        },
        body: jsonEncode({'query': query}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data']?['question'] != null) {
          return LeetCodeProblem.fromJson(data['data']['question']);
        }
      }
      return null;
    } catch (e) {
      print('LeetCode detail fetch error: $e');
      return null;
    }
  }

  Future<List<LeetCodeProblem>> searchProblems(String query) async {
    try {
      final graphqlQuery = '''
      {
        problemsetQuestionList(
          categorySlug: ""
          limit: 50
          skip: 0
          filters: {}
        ) {
          questions: data {
            acRate
            difficulty
            frontendQuestionId: questionFrontendId
            paidOnly: isPaidOnly
            title
            titleSlug
            topicTags {
              name
            }
          }
        }
      }
      ''';

      final response = await http.post(
        Uri.parse(ApiConfig.leetcodeGraphQL),
        headers: {
          'Content-Type': 'application/json',
          'Referer': 'https://leetcode.com',
        },
        body: jsonEncode({'query': graphqlQuery}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final problems = data['data']['problemsetQuestionList']['questions'] as List?;

        // Filter by search query (client-side)
        final filtered = problems
                ?.where((p) => p['title'].toLowerCase().contains(query.toLowerCase()))
                .map((p) => LeetCodeProblem.fromJson(p))
                .toList() ??
            [];
        return filtered;
      }
      return [];
    } catch (e) {
      print('LeetCode search error: $e');
      return [];
    }
  }
}

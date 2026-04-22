import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class CareerGeminiService {
  CareerGeminiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> generateJson({
    required String prompt,
    double temperature = 0.2,
    int maxTokens = 4096,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.geminiUrl}?key=${ApiConfig.geminiApiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': temperature,
          'maxOutputTokens': maxTokens,
          'responseMimeType': 'application/json',
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini request failed (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = ((body['candidates'] as List?)?.firstOrNull as Map<String, dynamic>?)?['content']
        as Map<String, dynamic>?;
    final parts = (text?['parts'] as List?) ?? <dynamic>[];
    final raw = parts.isNotEmpty ? (parts.first as Map<String, dynamic>)['text']?.toString() ?? '{}' : '{}';

    final clean = raw.replaceAll('```json', '').replaceAll('```', '').trim();
    final decoded = jsonDecode(clean);
    if (decoded is Map<String, dynamic>) return decoded;
    throw Exception('Gemini returned non-object JSON.');
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class PracticeGeminiService {
  PracticeGeminiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> _askJson(String prompt) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.geminiUrl}?key=${ApiConfig.geminiApiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.2,
          'maxOutputTokens': 4096,
          'responseMimeType': 'application/json',
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini request failed (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = ((body['candidates'] as List?)?.firstOrNull as Map<String, dynamic>?)?['content']
        as Map<String, dynamic>?;
    final parts = (text?['parts'] as List?) ?? <dynamic>[];
    final raw = parts.isNotEmpty ? (parts.first as Map<String, dynamic>)['text']?.toString() ?? '{}' : '{}';
    final clean = raw.replaceAll('```json', '').replaceAll('```', '').trim();
    final decoded = jsonDecode(clean);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw Exception('Gemini returned non-object JSON.');
  }

  Future<Map<String, dynamic>> explainProblem(dynamic problem) async {
    final prompt = '''Explain LeetCode #${problem.id} "${problem.title}" (${problem.difficulty}) simply for students. Pattern: ${problem.pattern}.
Return JSON: {
  "whatAsked": "2-3 lines simple",
  "approach": ["step1","step2","step3"],
  "dataStructure": "what to use",
  "timeComplexity": "O(?)",
  "spaceComplexity": "O(?)",
  "commonMistakes": ["mistake1"],
  "similarProblems": ["prob1","prob2"]
}''';
    return _askJson(prompt);
  }

  Future<Map<String, dynamic>> explainPattern(String patternName) async {
    final prompt = '''Explain DSA pattern "$patternName" for interview preparation.
Return JSON: {
  "definition": "simple definition",
  "whenToUse": ["condition1", "condition2"],
  "template": ["step1", "step2"],
  "mistakes": ["mistake1"],
  "exampleProblems": ["problem1", "problem2"]
}''';
    return _askJson(prompt);
  }

  Future<Map<String, dynamic>> reviewCode(String code, String language, dynamic problem) async {
    final prompt = '''Review this $language code for LeetCode problem '${problem.title}'.
Code:
$code

Provide JSON:
{
  "correct": true,
  "timeComplexity": "O(n)",
  "spaceComplexity": "O(1)",
  "issues": ["issue1"],
  "improvements": ["improvement1"],
  "betterApproach": "description or null"
}''';
    return _askJson(prompt);
  }

  /// Generate optimized YouTube search link using Groq API (ultra-fast)
  Future<String> generateYoutubeSearchLink({
    required String problemTitle,
    required String difficulty,
    required List<String> tags,
  }) async {
    try {
      final prompt = '''Generate a concise YouTube search query for learning this coding problem.
Problem: $problemTitle
Difficulty: $difficulty
Tags: ${tags.join(', ')}

Respond with ONLY the search query (15-30 characters), no explanation. 
Example: "Two Sum LeetCode" or "Merge Sorted Arrays"''';

      final response = await http.post(
        Uri.parse(ApiConfig.groqBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
        },
        body: jsonEncode({
          'model': ApiConfig.groqModel,
          'messages': [
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'temperature': 0.2,
          'max_tokens': 50,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final message = (body['choices'] as List?)?.firstOrNull as Map<String, dynamic>?;
        final searchQuery = message?['message']?['content']?.toString()?.trim() ?? '';
        
        if (searchQuery.isNotEmpty) {
          final encoded = Uri.encodeComponent(searchQuery);
          return 'https://www.youtube.com/results?search_query=$encoded';
        }
      }
      
      // Fallback to basic search
      final fallback = Uri.encodeComponent('$problemTitle tutorial');
      return 'https://www.youtube.com/results?search_query=$fallback';
    } catch (e) {
      print('YouTube link generation error: $e');
      // Fallback search
      final fallback = Uri.encodeComponent('$problemTitle tutorial');
      return 'https://www.youtube.com/results?search_query=$fallback';
    }
  }

  /// Fast text generation using Groq API (ultra-fast inference)
  Future<String> generateFastText({
    required String prompt,
    double temperature = 0.5,
    int maxTokens = 500,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.groqBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
        },
        body: jsonEncode({
          'model': ApiConfig.groqModel,
          'messages': [
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'temperature': temperature,
          'max_tokens': maxTokens,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final message = (body['choices'] as List?)?.firstOrNull as Map<String, dynamic>?;
        final text = message?['message']?['content']?.toString()?.trim() ?? '';
        return text.isNotEmpty ? text : 'Unable to generate text';
      }
      return 'Error: ${response.statusCode}';
    } catch (e) {
      print('Groq fast text generation error: $e');
      return 'Error generating text: $e';
    }
  }

  /// Research trends using Groq API for DSA/coding trends
  Future<String> researchTrends({
    required String topic,
    int maxTokens = 800,
  }) async {
    try {
      final prompt = '''Research and summarize current trends in $topic. 
Provide key insights, popular patterns, and what's trending in 2024-2025.
Format as bullet points.''';

      final response = await http.post(
        Uri.parse(ApiConfig.groqBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
        },
        body: jsonEncode({
          'model': ApiConfig.groqModel,
          'messages': [
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'temperature': 0.7,
          'max_tokens': maxTokens,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final message = (body['choices'] as List?)?.firstOrNull as Map<String, dynamic>?;
        final trends = message?['message']?['content']?.toString()?.trim() ?? '';
        return trends.isNotEmpty ? trends : 'No trends data available';
      }
      return 'Error fetching trends: ${response.statusCode}';
    } catch (e) {
      print('Groq trend research error: $e');
      return 'Error researching trends: $e';
    }
  }
}

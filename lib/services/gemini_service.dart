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
      Uri.parse('${ApiConfig.geminiUrl}?key=${ApiConfig.geminiKey}'),
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
      Uri.parse('${ApiConfig.geminiUrl}?key=${ApiConfig.geminiKey}'),
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
}

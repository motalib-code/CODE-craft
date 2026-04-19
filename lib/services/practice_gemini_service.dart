import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';

class PracticeGeminiService {
  static final PracticeGeminiService _instance = PracticeGeminiService._internal();

  factory PracticeGeminiService() {
    return _instance;
  }

  PracticeGeminiService._internal();

  Future<Map<String, dynamic>> explainProblem({
    required String title,
    required String difficulty,
    required List<String> tags,
    double temperature = 0.3,
    int maxTokens = 2000,
  }) async {
    try {
      final prompt = '''Explain this coding problem in simple terms for a student.

Problem: $title
Difficulty: $difficulty
Tags: ${tags.join(', ')}

Return explanation in this JSON structure:
{
  "whatIsAsked": "2-3 lines explaining what problem asks",
  "approach": "Step-by-step thinking (numbered list)",
  "dataStructure": "Which DS/Algorithm to use",
  "timeComplexity": "O(n) format",
  "spaceComplexity": "O(n) format",
  "commonMistakes": ["mistake 1", "mistake 2", "mistake 3"],
  "similarProblems": ["problem 1", "problem 2", "problem 3"]
}

Keep it beginner friendly!''';

      final response = await http.post(
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
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final content = (body['candidates'] as List?)?.firstOrNull as Map<String, dynamic>?;
        final parts = (content?['content']['parts'] as List?) ?? <dynamic>[];
        final rawText = parts.isNotEmpty ? (parts.first as Map<String, dynamic>)['text']?.toString() ?? '{}' : '{}';

        final clean = rawText.replaceAll('```json', '').replaceAll('```', '').trim();
        return jsonDecode(clean);
      }
      return {};
    } catch (e) {
      print('Gemini explain error: $e');
      return {};
    }
  }

  Future<String> generateConceptExplanation(String concept) async {
    try {
      final prompt = '''Provide a comprehensive explanation of "$concept" for a programming student.

Include:
1. Definition and key concepts
2. Real-world applications
3. Time and Space complexity (if applicable)
4. Implementation tips
5. Common pitfalls

Keep it concise and beginner-friendly.''';

      final response = await http.post(
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
            'temperature': 0.3,
            'maxOutputTokens': 1500,
          }
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final content = (body['candidates'] as List?)?.firstOrNull as Map<String, dynamic>?;
        final parts = (content?['content']['parts'] as List?) ?? <dynamic>[];
        return parts.isNotEmpty ? (parts.first as Map<String, dynamic>)['text']?.toString() ?? '' : '';
      }
      return '';
    } catch (e) {
      print('Concept explanation error: $e');
      return '';
    }
  }
}

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

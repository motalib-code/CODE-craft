import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';

class GroqService {
  static const _key = ApiKeys.groqApiKey;
  static const _base = 'https://api.groq.com/openai/v1/chat/completions';

  final _client = http.Client();

  Future<String> chat({
    required String message,
    required List<Map<String, String>> history,
    String? context,
    double temperature = 0.7,
  }) async {
    final messages = [
      {
        'role': 'system',
        'content': context ?? 'You are a helpful coding assistant. Be concise and practical.'
      },
      ...history.map((m) => {
        'role': m['role'] ?? 'user',
        'content': m['content'] ?? ''
      }),
      {'role': 'user', 'content': message},
    ];

    try {
      final response = await _client
          .post(
            Uri.parse(_base),
            headers: {
              'Authorization': 'Bearer $_key',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'llama-3.1-70b-versatile', // Updated to a more powerful model
              'messages': messages,
              'temperature': temperature,
              'max_tokens': 1024,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Groq error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } catch (e) {
      throw Exception('Groq service error: $e');
    }
  }

  // Fast code review
  Future<String> reviewCode({
    required String code,
    required String language,
  }) async {
    final message =
        '''Review this $language code for bugs and improvements:
```$language
$code
```

Provide:
1. Bugs found (if any)
2. 2-3 improvements
3. Performance tips

Keep it short. Be friendly.''';

    return chat(message: message, history: const [], temperature: 0.3);
  }

  // Explain concept quickly
  Future<String> explainConcept(String concept) async {
    final message =
        '''Explain "$concept" in programming in 2-3 short sentences.
Use simple terms, no jargon. For beginners.''';

    return chat(message: message, history: const [], temperature: 0.2);
  }

  void dispose() {
    _client.close();
  }
}

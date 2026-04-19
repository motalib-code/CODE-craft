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
        if (response.statusCode == 401) {
          throw Exception('Groq API Authentication Failed: Invalid API key. Status: ${response.statusCode}');
        } else if (response.statusCode == 429) {
          throw Exception('Groq API Rate Limited: Too many requests. Please try again later.');
        } else if (response.statusCode == 500) {
          throw Exception('Groq API Server Error: Try again in a moment.');
        }
        throw Exception('Groq error: ${response.statusCode} - ${response.body}');
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

  // Research company - comprehensive research
  Future<String> researchCompany({
    required String companyName,
    required List<String> interests,
    required List<String> jobRoles,
  }) async {
    final message = '''
You are an expert company researcher and business analyst. Research the company: "$companyName"

User Interests: ${interests.join(", ")}
Job Roles Interested In: ${jobRoles.join(", ")}

Provide a JSON response with this exact structure:
{
  "companyName": "Company Name",
  "industry": "Industry",
  "founded": "Year or date",
  "headquarters": "Location",
  "employees": "Employee count or range",
  "description": "Brief company overview",
  "isVerified": true/false,
  "isLegitimate": true/false,
  "products": ["product1", "product2"],
  "jobRoles": ["role1", "role2"],
  "verdict": "Is this a real/legitimate company?",
  "detailedAnalysis": "Detailed analysis of the company",
  "risks": ["risk1", "risk2"],
  "opportunities": ["opportunity1", "opportunity2"],
  "legitimacyScore": 0.95
}

IMPORTANT:
- If company is not real or is a scam, set isLegitimate to false and explain in verdict
- Legitimacy score 0-1 (1 being most legitimate)
- Be thorough and factual
- If uncertain, mark as unverified
- Return ONLY valid JSON, no markdown formatting

Current date context: April 2026
''';

    final response = await chat(
      message: message,
      history: const [],
      temperature: 0.3,
    );

    return response;
  }

  void dispose() {
    _client.close();
  }
}

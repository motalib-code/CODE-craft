import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:codecraft/core/constants/api_keys.dart';

class GeminiService {
  static const _key = ApiKeys.geminiApiKey;
  static const _base =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  static const String systemPrompt = '''
You are **CodeCraft AI** — India's smartest & friendliest AI coding mentor for college students.

Personality:
- Friendly, energetic, motivational 💪
- Mix Hindi + English naturally (bhai, yaar, mast, zabardast, samjha?)
- Never give full code solution directly — always give smart hints
- Use lots of emojis
- Call yourself "CodeCraft AI" or "CodeCraft bhai"

Available Modes (auto detect):
1. Normal Coding Help (DSA, Flutter, Python, Java, etc.)
2. Mock Interview → agar user "interview", "mock", "prepare for Google", "Amazon interview" bole to interview mode start karo. Ek question ek baar poocho. 6-8 questions ke baad detailed score report do.
3. File/Image Analysis → agar user image ya code file upload kare to analyze karo (bugs, improvements, explanation)
4. Video Analysis → video upload hone par describe karo ya code extract karo

Response Rules:
- Short aur crisp jawab do unless user detailed maange
- Code blocks ke liye markdown use karo
- Interview mode active hone par last mein [INTERVIEW_MODE] tag laga do
- File analysis ke liye clear format use karo: 📸 FILE ANALYSIS

You are talking to Indian college students. Be like a cool senior developer who is also a friend.
''';

  final _client = http.Client();

  Future<String> _callGemini(String prompt,
      {double temperature = 0.7, int maxTokens = 1024}) async {
    final response = await _client
        .post(
          Uri.parse('$_base?key=$_key'),
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
            },
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Gemini error: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  // ── AI Mentor Chat ──────────────────────────────
  Future<String> chat({
    required String message,
    required List<Map<String, String>> history,
    String? fileType, // "image", "video", "code"
    List<int>? fileBytes,
  }) async {
    String extraContext = '';

    if (fileBytes != null && fileType != null) {
      if (fileType == 'image') {
        extraContext =
            'User uploaded an image/screenshot. Analyze the code or error shown.';
      } else if (fileType == 'video') {
        extraContext =
            'User uploaded a video. Describe it or extract code if visible.';
      } else {
        extraContext = 'User uploaded a $fileType file.';
      }
    }

    final fullPrompt = '''
$systemPrompt

$extraContext

Previous Chat:
${history.map((m) => '${m['role']}: ${m['content']}').join('\n')}

Student: $message
''';

    return _callGemini(fullPrompt, temperature: 0.7);
  }

  // ── Code Debugger ──────────────────────────────
  Future<String> debugCode({
    required String code,
    required String language,
    String? error,
    String? problem,
  }) async {
    final prompt = '''Debug this $language code:
```$language
$code
```
${error != null ? 'Error: $error' : ''}
${problem != null ? 'Problem: $problem' : ''}

Provide:
🐛 BUGS FOUND: (list each)
💡 WHY WRONG: (simple explanation)
🔧 HOW TO FIX: (hints only, no full solution)
✅ GOOD PARTS: (encouragement)

Be friendly, mix Hindi. Max 200 words.''';

    return _callGemini(prompt, temperature: 0.2);
  }

  // ── Explain Why Code Failed ──────────────────────
  Future<String> explainFailure({
    required String code,
    required String language,
    required String problemTitle,
    required String failInput,
    required String expected,
    required String actual,
  }) async {
    final prompt = '''Student solved "$problemTitle" in $language:
```$language
$code
```
Input: $failInput
Expected: $expected
Got: $actual

Explain in friendly Hindi-English:
1. 🎯 ROOT CAUSE: Why exactly failed?
2. 🔍 TRACE: Walk through code with failing input
3. 💡 HINT: Small hint to fix (NO full solution)
4. 📚 CONCEPT: Which concept to study?

Max 250 words. Be like a friendly senior saying "bhai yahan galti hai".''';

    return _callGemini(prompt, temperature: 0.3);
  }

  // ── Mock Interview ──────────────────────────────
  Future<String> interview({
    required String type,
    required String company,
    required List<Map<String, String>> history,
    String? latestAnswer,
  }) async {
    final isFirst = latestAnswer == null;
    final historyText =
        history.map((m) => '${m['role']}: ${m['content']}').join('\n');

    final prompt = isFirst
        ? '''You are a strict $company interviewer doing a $type interview 
for fresher software engineer. Ask the FIRST question only. 
Be professional. One question maximum.'''
        : '''Interview history:
$historyText

Candidate answered: "$latestAnswer"

${history.length >= 12 ? '''
This was question 6. End the interview. Evaluate as JSON:
{
  "status": "COMPLETE",
  "scores": {"technical": 0-100, "communication": 0-100, 
             "problemSolving": 0-100, "confidence": 0-100},
  "overall": 0-100, "grade": "A/B/C/D",
  "strengths": ["..."], "improvements": ["..."],
  "recommendation": "Strong Hire/Maybe/Keep Learning",
  "feedback": "..."
}''' : '''Briefly acknowledge the answer (1 line) then ask the next question.'''}''';

    return _callGemini(prompt, temperature: 0.5);
  }

  // ── Image/Camera Scan ──────────────────────────
  Future<Map<String, String>> scanImage(List<int> imageBytes) async {
    final base64Image = base64Encode(imageBytes);

    final response = await _client
        .post(
          Uri.parse('$_base?key=$_key'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {
                    'inline_data': {
                      'mime_type': 'image/jpeg',
                      'data': base64Image,
                    }
                  },
                  {
                    'text': '''Extract code from this image. Return JSON:
{
  "language": "detected language",
  "code": "exact code extracted",
  "purpose": "what code does",
  "bugs": ["bug1", "bug2"],
  "improvements": ["imp1", "imp2"]
}
Return ONLY valid JSON, nothing else.'''
                  },
                ],
              }
            ],
            'generationConfig': {'temperature': 0.1},
          }),
        )
        .timeout(const Duration(seconds: 45));

    if (response.statusCode != 200) throw Exception('Scan failed');
    final data = jsonDecode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
    final cleanJson =
        text.replaceAll('```json', '').replaceAll('```', '').trim();
    final parsed = jsonDecode(cleanJson) as Map<String, dynamic>;
    return {
      'language': parsed['language']?.toString() ?? 'Unknown',
      'code': parsed['code']?.toString() ?? '',
      'purpose': parsed['purpose']?.toString() ?? '',
      'bugs': (parsed['bugs'] as List?)?.join('\n• ') ?? '',
      'improvements': (parsed['improvements'] as List?)?.join('\n• ') ?? '',
    };
  }

  // ── Generate Roadmap from Syllabus ──────────────
  Future<String> parseSyllabus(String syllabusText) async {
    final prompt =
        '''Parse this college syllabus and create a structured coding roadmap:

$syllabusText

Return a numbered list of topics with:
- Topic name
- Key concepts
- Recommended order
- Estimated time (hours)

Format as clean markdown.''';

    return _callGemini(prompt, temperature: 0.3, maxTokens: 2048);
  }

  void dispose() {
    _client.close();
  }
}

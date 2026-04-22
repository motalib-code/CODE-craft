import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class GroqService {
  static Future<String> _call({
    required List<Map<String, String>> messages,
    double temperature = 0.7,
    int maxTokens = 500,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.groqBaseUrl),
        headers: {
          'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': ApiConfig.groqModel,
          'messages': messages,
          'temperature': temperature,
          'max_tokens': maxTokens,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Groq ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Groq Error: $e');
    }
  }

  // ── START INTERVIEW ──
  static Future<String> startInterview({
    required String type,
    required String company,
    required String level,
    required String difficulty,
    required String language,
  }) async {
    final langInstruction = language == 'Hindi'
        ? 'Respond in Hindi language.'
        : language == 'Hinglish'
            ? 'Mix Hindi and English naturally.'
            : 'Respond in English.';

    return await _call(
      messages: [
        {
          'role': 'system',
          'content': '''You are a senior interviewer at $company conducting 
a $type interview for a $level candidate. Difficulty: $difficulty.
$langInstruction
Start with a warm professional welcome (1-2 lines) then ask your FIRST question.
Keep responses under 100 words. Be professional but friendly.
Number your questions like "Question 1:"'''
        },
        {
          'role': 'user',
          'content': 'Please start the interview.'
        }
      ],
      maxTokens: 200,
    );
  }

  // ── CONTINUE INTERVIEW ──
  static Future<String> continueInterview({
    required List<Map<String, String>> history,
    required String userAnswer,
    required int questionNumber,
    required int totalQuestions,
    required String language,
  }) async {
    final isLast = questionNumber >= totalQuestions;
    final langInstruction = language == 'Hindi'
        ? 'Respond in Hindi.'
        : language == 'Hinglish'
            ? 'Mix Hindi and English.'
            : 'Respond in English.';

    return await _call(
      messages: [
        {
          'role': 'system',
          'content': '''You are conducting a mock interview.
This is Question $questionNumber of $totalQuestions.
$langInstruction
${isLast
            ? "This is the LAST question. After the answer, wrap up warmly and say the interview is complete. Do NOT ask another question."
            : "Briefly acknowledge the answer in 1 line. Then ask Question ${questionNumber + 1}:"}
Keep under 80 words total.'''
        },
        ...history,
        {'role': 'user', 'content': userAnswer},
      ],
      maxTokens: 200,
    );
  }

  // ── EVALUATE SINGLE ANSWER ──
  static Future<Map<String, dynamic>> evaluateAnswer({
    required String question,
    required String answer,
    required String interviewType,
    required String level,
  }) async {
    if (answer.trim().isEmpty) {
      return {
        'score': 0,
        'clarity': 0,
        'technical_accuracy': 0,
        'communication': 0,
        'strengths': [],
        'improvements': ['No answer provided'],
        'ideal_answer_hint': 'Please provide a detailed answer',
        'star_rating': 0.0,
      };
    }

    final prompt = '''
Evaluate this interview answer objectively.
Question: $question
Answer: $answer
Interview Type: $interviewType, Level: $level

Return ONLY valid JSON (no markdown, no extra text):
{
  "score": 7,
  "clarity": 8,
  "technical_accuracy": 7,
  "communication": 8,
  "strengths": ["Clear structure", "Good examples"],
  "improvements": ["Add time complexity", "More specific examples"],
  "ideal_answer_hint": "Brief 1-line hint about ideal answer",
  "star_rating": 3.5
}''';

    final result = await _call(
      messages: [
        {
          'role': 'system',
          'content': 'Expert interview evaluator. Return ONLY valid JSON. No extra text.'
        },
        {'role': 'user', 'content': prompt},
      ],
      temperature: 0.2,
      maxTokens: 350,
    );

    try {
      String cleaned = result
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final start = cleaned.indexOf('{');
      final end = cleaned.lastIndexOf('}');
      if (start >= 0 && end > start) {
        cleaned = cleaned.substring(start, end + 1);
      }
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      return {
        'score': 5,
        'clarity': 5,
        'technical_accuracy': 5,
        'communication': 5,
        'strengths': [],
        'improvements': ['Could not parse feedback'],
        'ideal_answer_hint': '',
        'star_rating': 2.5,
      };
    }
  }

  // ── GENERATE FINAL REPORT ──
  static Future<Map<String, dynamic>> generateFinalReport({
    required String interviewType,
    required String company,
    required String level,
    required List<Map<String, dynamic>> questionResults,
  }) async {
    double avgScore = questionResults.isEmpty
        ? 5.0
        : questionResults.fold<double>(0.0,
                (sum, r) => sum + ((r['score'] as num?) ?? 5).toDouble()) /
            questionResults.length;

    double avgClarity = questionResults.isEmpty
        ? 5.0
        : questionResults.fold<double>(0.0,
                (sum, r) => sum + ((r['clarity'] as num?) ?? 5).toDouble()) /
            questionResults.length;

    double avgTech = questionResults.isEmpty
        ? 5.0
        : questionResults.fold<double>(0.0,
                (sum, r) => sum + ((r['technical_accuracy'] as num?) ?? 5).toDouble()) /
            questionResults.length;

    double avgComm = questionResults.isEmpty
        ? 5.0
        : questionResults.fold<double>(0.0,
                (sum, r) => sum + ((r['communication'] as num?) ?? 5).toDouble()) /
            questionResults.length;

    final prompt = '''
Generate a comprehensive interview performance report.
Company: $company
Interview Type: $interviewType
Candidate Level: $level
Questions Attempted: ${questionResults.length}
Average Score: ${avgScore.toStringAsFixed(1)}/10
Average Clarity: ${avgClarity.toStringAsFixed(1)}/10
Average Technical: ${avgTech.toStringAsFixed(1)}/10
Average Communication: ${avgComm.toStringAsFixed(1)}/10

Return ONLY valid JSON:
{
  "overall_score": ${avgScore.toStringAsFixed(1)},
  "grade": "B+",
  "hire_recommendation": "Yes",
  "overall_feedback": "Comprehensive 3-4 line assessment of performance",
  "top_strengths": ["Strength 1", "Strength 2", "Strength 3"],
  "top_improvements": ["Area 1", "Area 2", "Area 3"],
  "communication_score": ${avgComm.toStringAsFixed(1)},
  "technical_score": ${avgTech.toStringAsFixed(1)},
  "problem_solving_score": ${avgScore.toStringAsFixed(1)},
  "confidence_score": ${avgClarity.toStringAsFixed(1)},
  "next_steps": ["Specific action 1", "Specific action 2", "Specific action 3"],
  "ready_for_company": ${avgScore >= 7},
  "estimated_prep_time": "X weeks of focused practice",
  "recommended_resources": ["Resource 1", "Resource 2"]
}''';

    final result = await _call(
      messages: [
        {
          'role': 'system',
          'content': 'Generate interview performance report. Return ONLY valid JSON.'
        },
        {'role': 'user', 'content': prompt},
      ],
      temperature: 0.2,
      maxTokens: 600,
    );

    try {
      String cleaned = result
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final start = cleaned.indexOf('{');
      final end = cleaned.lastIndexOf('}');
      if (start >= 0 && end > start) {
        cleaned = cleaned.substring(start, end + 1);
      }
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      return {
        'overall_score': avgScore,
        'grade': avgScore >= 8 ? 'A' : avgScore >= 7 ? 'B+' :
                 avgScore >= 6 ? 'B' : avgScore >= 5 ? 'C' : 'D',
        'hire_recommendation': avgScore >= 7 ? 'Yes' : 'Maybe',
        'overall_feedback': 'Interview completed with ${questionResults.length} questions.',
        'top_strengths': ['Completed the interview'],
        'top_improvements': ['Practice more'],
        'communication_score': avgComm,
        'technical_score': avgTech,
        'problem_solving_score': avgScore,
        'confidence_score': avgClarity,
        'next_steps': ['Continue practicing'],
        'ready_for_company': avgScore >= 7,
        'estimated_prep_time': '2-4 weeks',
      };
    }
  }

  // ── COMPANY TIPS ──
  static Future<String> getCompanyInterviewTips(String company) async {
    return await _call(
      messages: [
        {
          'role': 'system',
          'content': 'Give concise, actionable interview tips.'
        },
        {
          'role': 'user',
          'content': '''Give 5 specific tips for $company technical interview.
Format as numbered list. Each tip max 2 lines. Focus on what $company actually looks for.'''
        },
      ],
      maxTokens: 300,
    );
  }
}

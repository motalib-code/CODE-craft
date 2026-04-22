import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';

class InterviewSession {
  final String id;
  final String interviewType;
  final String company;
  final String position;
  final List<InterviewQuestion> questions;
  final List<InterviewAnswer> answers;
  int currentQuestionIndex = 0;
  late DateTime startTime;

  InterviewSession({
    required this.id,
    required this.interviewType,
    required this.company,
    required this.position,
    required this.questions,
  })  : answers = [],
        startTime = DateTime.now();

  int get totalQuestions => questions.length;
  int get answeredQuestions => answers.length;
  bool get isComplete => answeredQuestions >= totalQuestions;
  int get durationSeconds => DateTime.now().difference(startTime).inSeconds;
}

class InterviewQuestion {
  final int id;
  final String question;
  final String category;
  final String difficulty;
  final List<String> keywords;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    required this.keywords,
  });
}

class InterviewAnswer {
  final int questionId;
  final String answer;
  final DateTime answeredAt;
  Map<String, dynamic>? feedback;

  InterviewAnswer({
    required this.questionId,
    required this.answer,
    required this.answeredAt,
    this.feedback,
  });
}

class InterviewFeedback {
  final double confidenceScore;
  final double clarityScore;
  final double technicalScore;
  final double overallScore;
  final List<String> strengths;
  final List<String> improvements;
  final String summary;
  final int durationSeconds;

  InterviewFeedback({
    required this.confidenceScore,
    required this.clarityScore,
    required this.technicalScore,
    required this.overallScore,
    required this.strengths,
    required this.improvements,
    required this.summary,
    required this.durationSeconds,
  });
}

class MockInterviewService {
  static final MockInterviewService _instance = MockInterviewService._internal();

  factory MockInterviewService() {
    return _instance;
  }

  MockInterviewService._internal();

  final Map<String, InterviewSession> _sessions = {};

  InterviewSession? getSession(String id) => _sessions[id];

  Future<InterviewSession> startInterview({
    required String interviewType,
    required String company,
    required String position,
    int questionCount = 5,
  }) async {
    try {
      final questions = await _generateQuestions(
        interviewType,
        company,
        position,
        questionCount,
      );

      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final session = InterviewSession(
        id: sessionId,
        interviewType: interviewType,
        company: company,
        position: position,
        questions: questions,
      );

      _sessions[sessionId] = session;
      return session;
    } catch (e) {
      throw Exception('Failed to start interview: $e');
    }
  }

  Future<List<InterviewQuestion>> _generateQuestions(
    String type,
    String company,
    String position,
    int count,
  ) async {
    try {
      final prompt = '''Generate $count interview questions for a $type interview at $company for the position: $position.

Return the response as a JSON array with this structure:
[
  {
    "id": 1,
    "question": "Question text",
    "category": "Category (e.g., Technical, Behavioral, System Design)",
    "difficulty": "Easy|Medium|Hard",
    "keywords": ["keyword1", "keyword2", "keyword3"]
  }
]

Make the questions realistic and challenging for the role. Focus on:
- Technical depth
- Problem-solving approach
- Communication skills
- Real-world experience
- Company-specific knowledge if applicable
''';

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
            'temperature': 0.7,
            'maxOutputTokens': 3000,
            'responseMimeType': 'application/json',
          }
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final content = (body['candidates'] as List?)?.firstOrNull as Map<String, dynamic>?;
        final parts = (content?['content']['parts'] as List?) ?? <dynamic>[];
        final rawText = parts.isNotEmpty ? (parts.first as Map<String, dynamic>)['text']?.toString() ?? '[]' : '[]';

        final clean = rawText.replaceAll('```json', '').replaceAll('```', '').trim();
        final jsonData = jsonDecode(clean) as List;

        return jsonData.map<InterviewQuestion>((q) {
          return InterviewQuestion(
            id: q['id'] ?? 0,
            question: q['question'] ?? '',
            category: q['category'] ?? 'General',
            difficulty: q['difficulty'] ?? 'Medium',
            keywords: List<String>.from(q['keywords'] ?? []),
          );
        }).toList();
      }
      throw Exception('Failed to generate questions: ${response.statusCode}');
    } catch (e) {
      print('Error generating questions: $e');
      rethrow;
    }
  }

  Future<void> submitAnswer(
    String sessionId,
    int questionId,
    String answer,
  ) async {
    final session = _sessions[sessionId];
    if (session == null) throw Exception('Session not found');

    final interviewAnswer = InterviewAnswer(
      questionId: questionId,
      answer: answer,
      answeredAt: DateTime.now(),
    );

    session.answers.add(interviewAnswer);

    // Get AI feedback on the answer
    try {
      final feedback = await _analyzeAnswer(
        session.questions.firstWhere((q) => q.id == questionId),
        answer,
        session.interviewType,
      );
      interviewAnswer.feedback = feedback;
    } catch (e) {
      print('Error analyzing answer: $e');
    }
  }

  Future<Map<String, dynamic>> _analyzeAnswer(
    InterviewQuestion question,
    String answer,
    String interviewType,
  ) async {
    try {
      final prompt = '''Analyze this interview answer and provide feedback.

Question: ${question.question}
Category: ${question.category}
Interview Type: $interviewType
Keywords: ${question.keywords.join(', ')}

Answer: $answer

Provide feedback as JSON with this structure:
{
  "score": 0-10,
  "strengths": ["strength1", "strength2"],
  "improvements": ["improvement1", "improvement2"],
  "keywordsCovered": ["keyword1", "keyword2"],
  "feedback": "Brief constructive feedback",
  "completeness": "complete|partial|incomplete"
}

Be constructive and specific.
''';

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
            'temperature': 0.5,
            'maxOutputTokens': 1500,
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
      print('Error analyzing answer: $e');
      return {};
    }
  }

  Future<InterviewFeedback> getInterviewFeedback(String sessionId) async {
    final session = _sessions[sessionId];
    if (session == null) throw Exception('Session not found');

    try {
      final prompt = '''Generate comprehensive interview feedback based on these answers.

Interview Type: ${session.interviewType}
Company: ${session.company}
Position: ${session.position}
Duration: ${session.durationSeconds} seconds

Questions and Answers:
${session.questions.asMap().entries.map((e) {
        final answer = session.answers.firstWhere(
          (a) => a.questionId == e.value.id,
          orElse: () => InterviewAnswer(
            questionId: e.value.id,
            answer: 'Not answered',
            answeredAt: DateTime.now(),
          ),
        );
        return '''
Question ${e.key + 1}: ${e.value.question}
Difficulty: ${e.value.difficulty}
Answer: ${answer.answer}
---
''';
      }).join('\n')}

Provide overall interview feedback as JSON with this structure:
{
  "confidenceScore": 0-10,
  "clarityScore": 0-10,
  "technicalScore": 0-10,
  "overallScore": 0-10,
  "strengths": ["strength1", "strength2", "strength3"],
  "improvements": ["improvement1", "improvement2", "improvement3"],
  "summary": "Overall interview summary and recommendations"
}

Be detailed and constructive in the summary.
''';

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
            'temperature': 0.5,
            'maxOutputTokens': 2000,
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
        final feedbackData = jsonDecode(clean);

        return InterviewFeedback(
          confidenceScore: (feedbackData['confidenceScore'] ?? 0).toDouble(),
          clarityScore: (feedbackData['clarityScore'] ?? 0).toDouble(),
          technicalScore: (feedbackData['technicalScore'] ?? 0).toDouble(),
          overallScore: (feedbackData['overallScore'] ?? 0).toDouble(),
          strengths: List<String>.from(feedbackData['strengths'] ?? []),
          improvements: List<String>.from(feedbackData['improvements'] ?? []),
          summary: feedbackData['summary'] ?? '',
          durationSeconds: session.durationSeconds,
        );
      }
      throw Exception('Failed to get feedback: ${response.statusCode}');
    } catch (e) {
      print('Error getting interview feedback: $e');
      rethrow;
    }
  }

  void deleteSession(String id) {
    _sessions.remove(id);
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/groq_service.dart';
import '../services/notification_service.dart';
import 'interview_result_screen.dart';

class MockInterviewActiveScreen extends StatefulWidget {
  final String interviewType;
  final String company;
  final String level;
  final int durationMinutes;
  final String difficulty;
  final String language;

  const MockInterviewActiveScreen({
    super.key,
    required this.interviewType,
    required this.company,
    required this.level,
    required this.durationMinutes,
    required this.difficulty,
    required this.language,
  });

  @override
  State<MockInterviewActiveScreen> createState() => _MockInterviewActiveScreenState();
}

class _MockInterviewActiveScreenState extends State<MockInterviewActiveScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _speechAvailable = false;
  bool isAISpeaking = false;
  bool isListening = false;
  String liveTranscript = '';
  String currentQuestion = '';
  int questionNumber = 0;
  late int totalQuestions;
  late int secondsRemaining;
  Timer? _timer;
  bool isInterviewComplete = false;
  bool isLoading = true;
  String loadingMessage = 'Preparing your interview...';
  List<Map<String, String>> conversationHistory = [];
  List<Map<String, dynamic>> questionResults = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    totalQuestions = (widget.durationMinutes / 4).round().clamp(3, 12);
    secondsRemaining = widget.durationMinutes * 60;
    _initSpeech();
    _startInterview();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (e) {},
      onStatus: (status) {},
    );
    await _tts.setLanguage(widget.language == 'Hindi' ? 'hi-IN' : 'en-US');
    await _tts.setSpeechRate(0.85);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> _startInterview() async {
    try {
      setState(() {
        isLoading = true;
        loadingMessage = 'Connecting to AI Interviewer...';
      });

      final firstMessage = await GroqService.startInterview(
        type: widget.interviewType,
        company: widget.company,
        level: widget.level,
        difficulty: widget.difficulty,
        language: widget.language,
      );

      setState(() {
        conversationHistory.add({'role': 'assistant', 'content': firstMessage});
        currentQuestion = firstMessage;
        questionNumber = 1;
        isLoading = false;
      });

      _startTimer();
      await _tts.speak(firstMessage);
      setState(() => isAISpeaking = false);
      _scrollToBottom();
    } catch (e) {
      setState(() {
        isLoading = false;
        conversationHistory.add({
          'role': 'assistant',
          'content': 'Hello! Welcome to your ${widget.interviewType} interview at ${widget.company}. Let\'s begin. Can you please introduce yourself and tell me about your background?',
        });
        currentQuestion = conversationHistory.last['content']!;
        questionNumber = 1;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining <= 0) {
        t.cancel();
        _endInterview();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  Future<void> _startListening() async {
    if (!_speechAvailable || isAISpeaking) return;
    await _tts.stop();
    setState(() {
      isListening = true;
      liveTranscript = '';
    });
    await _speech.listen(
      onResult: (result) {
        setState(() => liveTranscript = result.recognizedWords);
      },
      listenFor: const Duration(minutes: 3),
      pauseFor: const Duration(seconds: 3),
      localeId: widget.language == 'Hindi' ? 'hi_IN' : 'en_US',
      cancelOnError: false,
    );
  }

  Future<void> _stopListeningAndSend() async {
    await _speech.stop();
    setState(() {
      isListening = false;
    });
    if (liveTranscript.trim().isEmpty) return;
    await _sendAnswer(liveTranscript.trim());
  }

  Future<void> _sendAnswer(String answer) async {
    setState(() {
      conversationHistory.add({'role': 'user', 'content': answer});
      isAISpeaking = true;
      liveTranscript = '';
    });

    _scrollToBottom();

    GroqService.evaluateAnswer(
      question: currentQuestion,
      answer: answer,
      interviewType: widget.interviewType,
      level: widget.level,
    ).then((eval) {
      questionResults.add({
        'question': currentQuestion,
        'answer': answer,
        'evaluation': eval,
        'score': eval['score'] ?? 5,
        'clarity': eval['clarity'] ?? 5,
        'technical_accuracy': eval['technical_accuracy'] ?? 5,
        'communication': eval['communication'] ?? 5,
      });
    });

    try {
      final aiResponse = await GroqService.continueInterview(
        history: conversationHistory,
        userAnswer: answer,
        questionNumber: questionNumber,
        totalQuestions: totalQuestions,
        language: widget.language,
      );

      setState(() {
        conversationHistory.add({'role': 'assistant', 'content': aiResponse});
        currentQuestion = aiResponse;
        questionNumber++;
      });

      _scrollToBottom();
      await _tts.speak(aiResponse);
      setState(() => isAISpeaking = false);

      if (questionNumber > totalQuestions) {
        await Future.delayed(const Duration(seconds: 2));
        _endInterview();
      }
    } catch (e) {
      setState(() {
        isAISpeaking = false;
        conversationHistory.add({
          'role': 'assistant',
          'content': 'Sorry, I had a connection issue. Please continue with your answer or we can move to the next topic.',
        });
      });
      _scrollToBottom();
    }
  }

  Future<void> _endInterview() async {
    _timer?.cancel();
    await _tts.stop();
    await _speech.stop();

    if (isInterviewComplete) return;
    setState(() {
      isInterviewComplete = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1550),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(color: Color(0xFF6B5CE7)),
            SizedBox(height: 16),
            Text('Generating your report...', style: TextStyle(color: Colors.white)),
            SizedBox(height: 8),
            Text('Powered by Groq AI', style: TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );

    try {
      final report = await GroqService.generateFinalReport(
        interviewType: widget.interviewType,
        company: widget.company,
        level: widget.level,
        questionResults: questionResults,
      );

      if (!mounted) return;
      Navigator.pop(context);

      await NotificationService.showInterviewCompleteAlert(
        grade: report['grade'] ?? 'B',
        company: widget.company,
        score: (report['overall_score'] as num?)?.toDouble() ?? 5.0,
      );

      await _saveToHistory(report);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InterviewResultScreen(
            report: report,
            questionResults: questionResults,
            company: widget.company,
            interviewType: widget.interviewType,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _saveToHistory(Map<String, dynamic> report) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('interview_history') ?? [];
    history.insert(0, jsonEncode({
      'date': DateTime.now().toIso8601String(),
      'company': widget.company,
      'type': widget.interviewType,
      'level': widget.level,
      'report': report,
      'totalQuestions': questionResults.length,
    }));
    if (history.length > 20) history.removeRange(20, history.length);
    await prefs.setStringList('interview_history', history);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speech.cancel();
    _tts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBubble(Map<String, String> message) {
    final isAssistant = message['role'] == 'assistant';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAssistant ? const Color(0xFF251D4F) : const Color(0xFF2D205E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            isAssistant ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (isAssistant)
            const Text('Interviewer', style: TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold)),
          if (!isAssistant)
            const Text('You', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            message['content'] ?? '',
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Interview'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: Text(_formatTime(secondsRemaining), style: const TextStyle(fontSize: 16))),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(color: Color(0xFF6B5CE7)),
                        SizedBox(height: 16),
                        Text('Preparing the interview...', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: conversationHistory.length,
                    itemBuilder: (context, index) => _buildBubble(conversationHistory[index]),
                  ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E1550),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (liveTranscript.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(liveTranscript, style: const TextStyle(color: Colors.white70)),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isListening ? Colors.redAccent : const Color(0xFF6B5CE7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: isListening ? _stopListeningAndSend : _startListening,
                        icon: Icon(isListening ? Icons.stop : Icons.mic, color: Colors.white),
                        label: Text(isListening ? 'Stop & Send' : 'Speak Answer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B1F5D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onPressed: conversationHistory.isNotEmpty && !isAISpeaking
                          ? () async {
                              if (conversationHistory.isNotEmpty) {
                                await _sendAnswer('I would like to continue with the interview.');
                              }
                            }
                          : null,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

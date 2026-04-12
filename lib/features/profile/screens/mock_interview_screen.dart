import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/services/gemini_service.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  final _gemini = GeminiService();
  final _answerCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  String _type = '';
  String _company = '';
  bool _started = false;
  bool _loading = false;
  bool _completed = false;
  List<Map<String, String>> _messages = [];
  String _results = '';

  final _types = ['Technical', 'HR', 'System Design'];
  final _companies = ['Google', 'Amazon', 'Microsoft', 'Flipkart', 'Razorpay', 'PhonePe'];

  Future<void> _startInterview() async {
    if (_type.isEmpty || _company.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select type and company')),
      );
      return;
    }

    setState(() { _started = true; _loading = true; });

    try {
      final question = await _gemini.interview(
        type: _type,
        company: _company,
        history: [],
      );

      setState(() {
        _messages.add({'role': 'interviewer', 'content': question});
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'interviewer',
          'content': 'Error starting interview: $e'
        });
        _loading = false;
      });
    }
  }

  Future<void> _submitAnswer() async {
    if (_answerCtrl.text.trim().isEmpty) return;

    final answer = _answerCtrl.text.trim();
    _answerCtrl.clear();

    setState(() {
      _messages.add({'role': 'candidate', 'content': answer});
      _loading = true;
    });

    _scrollToBottom();

    try {
      final response = await _gemini.interview(
        type: _type,
        company: _company,
        history: _messages,
        latestAnswer: answer,
      );

      if (response.contains('"status": "COMPLETE"') ||
          response.contains('"COMPLETE"')) {
        setState(() {
          _completed = true;
          _results = response;
          _loading = false;
        });
      } else {
        setState(() {
          _messages.add({'role': 'interviewer', 'content': response});
          _loading = false;
        });
      }
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'interviewer',
          'content': 'Error: $e'
        });
        _loading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _reset() {
    setState(() {
      _type = '';
      _company = '';
      _started = false;
      _completed = false;
      _messages = [];
      _results = '';
    });
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: GradientText(
          text: '💼 Mock Interview',
          style: AppTextStyles.h2,
        ),
        actions: [
          if (_started)
            IconButton(
              icon: const Icon(Icons.restart_alt, color: AppColors.textSecondary),
              onPressed: _reset,
            ),
        ],
      ),
      body: !_started ? _buildSetup() : _completed ? _buildResults() : _buildInterview(),
    );
  }

  Widget _buildSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInDown(
            child: GlassCard(
              gradient: LinearGradient(
                colors: [
                  AppColors.blue.withOpacity(0.1),
                  AppColors.purple.withOpacity(0.05),
                ],
              ),
              child: Column(
                children: [
                  const Text('🎙️', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('AI Mock Interview', style: AppTextStyles.h1),
                  const SizedBox(height: 8),
                  Text(
                    'Practice with AI interviewer powered by Gemini.\n6 questions, scored on 4 parameters.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text('Interview Type', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types.map((t) {
              final selected = _type == t;
              return GestureDetector(
                onTap: () => setState(() => _type = t),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: selected ? AppColors.gradPurpleBlue : null,
                    color: selected ? null : AppColors.bgInput,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.purple : AppColors.border,
                    ),
                  ),
                  child: Text(t,
                      style: AppTextStyles.h3.copyWith(
                          fontSize: 13,
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Text('Target Company', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _companies.map((c) {
              final selected = _company == c;
              return GestureDetector(
                onTap: () => setState(() => _company = c),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: selected ? AppColors.gradGreenBlue : null,
                    color: selected ? null : AppColors.bgInput,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.green : AppColors.border,
                    ),
                  ),
                  child: Text(c,
                      style: AppTextStyles.h3.copyWith(
                          fontSize: 13,
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          GradientButton(
            label: 'Start Interview',
            icon: Icons.play_arrow,
            onTap: _startInterview,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildInterview() {
    return Column(
      children: [
        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_loading ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == _messages.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.purple),
                  ),
                );
              }
              final msg = _messages[i];
              final isInterviewer = msg['role'] == 'interviewer';
              return FadeInUp(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isInterviewer
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isInterviewer) ...[
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('👔', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: isInterviewer
                                ? null
                                : AppColors.gradPurpleBlue,
                            color: isInterviewer ? AppColors.bgSurface : null,
                            borderRadius: BorderRadius.circular(14),
                            border: isInterviewer
                                ? Border.all(color: AppColors.border)
                                : null,
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: AppTextStyles.body.copyWith(
                              color: isInterviewer
                                  ? AppColors.textPrimary
                                  : Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Answer input
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.bgCard,
            border: Border(
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerCtrl,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    maxLines: 3,
                    minLines: 1,
                    onSubmitted: (_) => _submitAnswer(),
                    decoration: InputDecoration(
                      hintText: 'Type your answer...',
                      filled: true,
                      fillColor: AppColors.bgInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _loading ? null : _submitAnswer,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradPurpleBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          FadeInDown(
            child: GlassCard(
              gradient: LinearGradient(
                colors: [
                  AppColors.green.withOpacity(0.1),
                  AppColors.blue.withOpacity(0.05),
                ],
              ),
              borderColor: AppColors.green.withOpacity(0.3),
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('Interview Complete!', style: AppTextStyles.h1),
                  const SizedBox(height: 8),
                  Text('$_type Interview at $_company',
                      style: AppTextStyles.body),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: GlassCard(
              child: SelectableText(
                _results,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textPrimary, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: 'Try Again',
            icon: Icons.replay,
            onTap: _reset,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

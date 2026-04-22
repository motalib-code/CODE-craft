import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/points_badge.dart';
import '../../../services/mock_interview_service.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  final MockInterviewService _interviewService = MockInterviewService();
  final _answerCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // Setup state
  String _selectedType = 'Technical';
  String _selectedCompany = 'Google';
  String _selectedPosition = 'Software Engineer';
  int _selectedDuration = 5; // questions count

  // Interview state
  InterviewSession? _currentSession;
  bool _isLoadingQuestions = false;
  bool _isLoadingFeedback = false;
  InterviewFeedback? _feedback;
  int _currentQuestionIdx = 0;

  // UI state
  bool _started = false;
  bool _completed = false;

  final List<String> _interviewTypes = ['Technical', 'HR', 'System Design', 'Behavioral'];
  final List<String> _companies = [
    'Google',
    'Amazon',
    'Microsoft',
    'Apple',
    'Facebook',
    'Netflix',
    'Tesla',
    'Flipkart',
    'Razorpay',
    'PhonePe',
    'Swiggy',
    'Zomato'
  ];
  final List<String> _positions = [
    'Software Engineer',
    'Senior Engineer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'DevOps Engineer',
    'Data Engineer',
  ];
  final List<int> _durations = [3, 5, 7, 10];

  @override
  void dispose() {
    _answerCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _startInterview() async {
    setState(() => _isLoadingQuestions = true);
    try {
      final session = await _interviewService.startInterview(
        interviewType: _selectedType,
        company: _selectedCompany,
        position: _selectedPosition,
        questionCount: _selectedDuration,
      );
      setState(() {
        _currentSession = session;
        _started = true;
        _isLoadingQuestions = false;
        _currentQuestionIdx = 0;
        _answerCtrl.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      setState(() => _isLoadingQuestions = false);
    }
  }

  Future<void> _submitAnswer() async {
    if (_answerCtrl.text.isEmpty || _currentSession == null) return;

    final answer = _answerCtrl.text;
    final question = _currentSession!.questions[_currentQuestionIdx];

    try {
      await _interviewService.submitAnswer(
        _currentSession!.id,
        question.id,
        answer,
      );

      if (_currentQuestionIdx < _currentSession!.questions.length - 1) {
        setState(() {
          _currentQuestionIdx++;
          _answerCtrl.clear();
        });
        _scrollCtrl.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // All questions answered, get feedback
        await _getInterviewFeedback();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _getInterviewFeedback() async {
    if (_currentSession == null) return;
    setState(() => _isLoadingFeedback = true);
    try {
      final feedback = await _interviewService.getInterviewFeedback(_currentSession!.id);
      setState(() {
        _feedback = feedback;
        _completed = true;
        _isLoadingFeedback = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      setState(() => _isLoadingFeedback = false);
    }
  }

  void _reset() {
    setState(() {
      _currentSession = null;
      _feedback = null;
      _started = false;
      _completed = false;
      _currentQuestionIdx = 0;
      _answerCtrl.clear();
      _selectedType = 'Technical';
      _selectedCompany = 'Google';
      _selectedPosition = 'Software Engineer';
      _selectedDuration = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text('CodeCraft', style: AppTextStyles.h2),
                  const Spacer(),
                  const PointsBadge(points: '1.2k', icon: Icons.bolt),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=rahul'),
                  ),
                ],
              ),
            ),

            // ── Main Content ──────────────────────────
            Expanded(
              child: _completed && _feedback != null
                  ? _buildResults()
                  : (!_started
                      ? _buildSetup()
                      : _isLoadingFeedback
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: Color(0xFF6B5CE7)),
                                  SizedBox(height: 16),
                                  Text('Analyzing your interview...',
                                      style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                            )
                          : _buildInterview()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInDown(
            child: Column(
              children: [
                const Text('🎙️', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 12),
                Text('AI Mock Interview', style: AppTextStyles.display),
                const SizedBox(height: 8),
                Text(
                  'Master your skills with AI-powered interviews',
                  style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Interview Type Selection
          FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Interview Type', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interviewTypes.map((type) {
                    final isSelected = _selectedType == type;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.purple
                              : AppColors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.purple
                                : Colors.white12,
                          ),
                        ),
                        child: Text(
                          type,
                          style: AppTextStyles.body.copyWith(
                            color: isSelected ? Colors.white : AppColors.textHint,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Company Selection
          FadeInUp(
            delay: const Duration(milliseconds: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Company', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCompany,
                    isExpanded: true,
                    dropdownColor: AppColors.bg,
                    style: AppTextStyles.body,
                    underline: const SizedBox(),
                    items: _companies.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCompany = value ?? 'Google'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Position Selection
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Position', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedPosition,
                    isExpanded: true,
                    dropdownColor: AppColors.bg,
                    style: AppTextStyles.body,
                    underline: const SizedBox(),
                    items: _positions.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedPosition = value ?? 'Software Engineer'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Duration Selection
          FadeInUp(
            delay: const Duration(milliseconds: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Number of Questions', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                Row(
                  children: _durations.map((duration) {
                    final isSelected = _selectedDuration == duration;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDuration = duration),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.purple
                                : AppColors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.purple
                                  : Colors.white12,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$duration',
                              style: AppTextStyles.h3.copyWith(
                                color: isSelected ? Colors.white : AppColors.textHint,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: GradientButton(
              label: _isLoadingQuestions ? 'Starting...' : 'Start Interview',
              onTap: _isLoadingQuestions ? null : _startInterview,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInterview() {
    if (_currentSession == null) {
      return const Center(child: Text('Loading interview...'));
    }

    final question = _currentSession!.questions[_currentQuestionIdx];
    final progress = (_currentQuestionIdx + 1) / _currentSession!.questions.length;

    return ListView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(24),
      children: [
        // Progress Bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIdx + 1}/${_currentSession!.questions.length}',
                  style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.h3.copyWith(color: AppColors.purple),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Question Card
        FadeIn(
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question.category,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.question,
                  style: AppTextStyles.display.copyWith(fontSize: 24, height: 1.3),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: question.difficulty == 'Hard'
                            ? Colors.red.withOpacity(0.2)
                            : question.difficulty == 'Medium'
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        question.difficulty,
                        style: AppTextStyles.small.copyWith(
                          color: question.difficulty == 'Hard'
                              ? Colors.red
                              : question.difficulty == 'Medium'
                                  ? Colors.orange
                                  : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Answer Input
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Answer', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _answerCtrl,
                maxLines: 6,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Share your thoughts and reasoning here...',
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            if (_currentQuestionIdx > 0)
              Expanded(
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentQuestionIdx--;
                          final prevAnswer = _currentSession!.answers
                              .firstWhere(
                                (a) => a.questionId ==
                                    _currentSession!.questions[_currentQuestionIdx].id,
                                orElse: () => InterviewAnswer(
                                  questionId: -1,
                                  answer: '',
                                  answeredAt: DateTime.now(),
                                ),
                              )
                              .answer;
                          _answerCtrl.text = prevAnswer;
                        });
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back, color: Colors.white),
                            const SizedBox(width: 8),
                            Text('Previous', style: AppTextStyles.h3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentQuestionIdx > 0) const SizedBox(width: 12),
            Expanded(
              child: GradientButton(
                label: _currentQuestionIdx == _currentSession!.questions.length - 1
                    ? 'Finish'
                    : 'Next',
                onTap: _answerCtrl.text.isEmpty ? null : _submitAnswer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildResults() {
    if (_feedback == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final overallGrade = _getGrade(_feedback!.overallScore);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          FadeInDown(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_selectedType\nInterview Results',
                  style: AppTextStyles.display.copyWith(fontSize: 40, height: 1.1),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_selectedCompany} • ${_selectedPosition} • ${_formatDuration(_feedback!.durationSeconds)}',
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textHint, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Overall Score Card
          FadeInUp(
            child: GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      overallGrade,
                      style: AppTextStyles.display.copyWith(
                        fontSize: 90,
                        color: _getScoreColor(_feedback!.overallScore),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_feedback!.overallScore.toStringAsFixed(1)}/10',
                      style: AppTextStyles.small.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Score Breakdown
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildScoreRow(
                    'Technical Knowledge',
                    _feedback!.technicalScore,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildScoreRow(
                    'Clarity & Communication',
                    _feedback!.clarityScore,
                    Colors.purple,
                  ),
                  const SizedBox(height: 16),
                  _buildScoreRow(
                    'Confidence',
                    _feedback!.confidenceScore,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Summary
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _buildEvaluationSection(
              title: 'Summary',
              icon: Icons.info_outline,
              color: AppColors.purple,
              content: _feedback!.summary,
            ),
          ),
          const SizedBox(height: 24),

          // Strengths
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _buildEvaluationSection(
              title: 'Strengths',
              icon: Icons.check_circle,
              color: Colors.green,
              items: _feedback!.strengths,
            ),
          ),
          const SizedBox(height: 24),

          // Improvements
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildEvaluationSection(
              title: 'Areas to Improve',
              icon: Icons.lightbulb_outline,
              color: Colors.orange,
              items: _feedback!.improvements,
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          GradientButton(
            label: 'Try Another Interview',
            onTap: _reset,
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Back', style: AppTextStyles.h3),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, double score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body),
            Text(
              '${score.toStringAsFixed(1)}/10',
              style: AppTextStyles.h3.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 10,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationSection({
    required String title,
    required IconData icon,
    required Color color,
    String? content,
    List<String>? items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.h2),
          ],
        ),
        const SizedBox(height: 16),
        if (content != null)
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Text(
              content,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textHint,
                height: 1.6,
              ),
            ),
          )
        else if (items != null)
          Column(
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textHint),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  String _getGrade(double score) {
    if (score >= 9) return 'A+';
    if (score >= 8) return 'A';
    if (score >= 7) return 'B+';
    if (score >= 6) return 'B';
    if (score >= 5) return 'C+';
    return 'C';
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.blue;
    if (score >= 4) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes == 0) return '${secs}s';
    return '${minutes}m ${secs}s';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/diff_badge.dart';
import '../../../core/widgets/coin_badge.dart';
import '../../../core/services/judge0_service.dart';
import '../../../core/services/gemini_service.dart';
import '../notifiers/practice_notifier.dart';
import '../../../models/problem_model.dart';

class CodeEditorScreen extends ConsumerStatefulWidget {
  final String problemId;
  const CodeEditorScreen({super.key, required this.problemId});

  @override
  ConsumerState<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends ConsumerState<CodeEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _codeCtrl = TextEditingController();
  final _judge0 = Judge0Service();
  final _gemini = GeminiService();

  String _selectedLang = 'python';
  String _output = '';
  bool _running = false;
  bool _explaining = false;
  String _explanation = '';
  ProblemModel? _problem;

  final _languages = ['python', 'java', 'cpp', 'javascript', 'c'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProblem());
  }

  void _loadProblem() {
    final practice = ref.read(practiceNotifierProvider);
    final problem = practice.problems
        .where((p) => p.id == widget.problemId)
        .firstOrNull;
    if (problem != null) {
      setState(() {
        _problem = problem;
        _codeCtrl.text = problem.boilerplate;
      });
    }
  }

  Future<void> _runCode() async {
    setState(() { _running = true; _output = 'Running...'; });
    try {
      final result = await _judge0.runCode(
        code: _codeCtrl.text,
        language: _selectedLang,
        stdin: _problem?.testCases.isNotEmpty == true
            ? _problem!.testCases.first.input
            : '',
      );
      setState(() {
        _output = result['stdout']?.isNotEmpty == true
            ? result['stdout']!
            : result['stderr']?.isNotEmpty == true
                ? '❌ Error:\n${result['stderr']}'
                : result['compileOutput']?.isNotEmpty == true
                    ? '❌ Compile Error:\n${result['compileOutput']}'
                    : '✅ ${result['status']}\nTime: ${result['time']}s | Memory: ${result['memory']}KB';
        _running = false;
      });
      _tabCtrl.animateTo(2); // Switch to output tab
    } catch (e) {
      setState(() { _output = '❌ Error: $e'; _running = false; });
    }
  }

  Future<void> _submitCode() async {
    if (_problem == null) return;
    setState(() { _running = true; _output = 'Testing all cases...'; });

    int passed = 0;
    final total = _problem!.testCases.length;
    final results = <String>[];

    for (final tc in _problem!.testCases) {
      try {
        final result = await _judge0.runCode(
          code: _codeCtrl.text,
          language: _selectedLang,
          stdin: tc.input,
        );
        final stdout = result['stdout']?.trim() ?? '';
        if (stdout == tc.expectedOutput.trim()) {
          passed++;
          results.add('✅ Test $passed: Passed');
        } else {
          results
              .add('❌ Test: Expected "${tc.expectedOutput}" got "$stdout"');
        }
      } catch (e) {
        results.add('❌ Test: Error - $e');
      }
    }

    setState(() {
      _output = '${passed == total ? '🎉 All Passed!' : '⚠️ $passed/$total Passed'}\n\n${results.join('\n')}';
      _running = false;
    });
    _tabCtrl.animateTo(2);
  }

  Future<void> _explainFailure() async {
    if (_problem == null) return;
    setState(() { _explaining = true; _explanation = 'Analyzing...'; });

    try {
      final explanation = await _gemini.explainFailure(
        code: _codeCtrl.text,
        language: _selectedLang,
        problemTitle: _problem!.title,
        failInput: _problem!.testCases.isNotEmpty
            ? _problem!.testCases.first.input
            : '',
        expected: _problem!.testCases.isNotEmpty
            ? _problem!.testCases.first.expectedOutput
            : '',
        actual: _output.split('\n').last,
      );
      setState(() { _explanation = explanation; _explaining = false; });
    } catch (e) {
      setState(() { _explanation = 'Error: $e'; _explaining = false; });
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: Text(_problem?.title ?? 'Code Editor',
            style: AppTextStyles.h3),
        actions: [
          if (_problem != null) ...[
            DiffBadge(difficulty: _problem!.difficulty),
            const SizedBox(width: 8),
            CoinBadge(coins: _problem!.coins),
            const SizedBox(width: 16),
          ],
        ],
      ),
      body: Column(
        children: [
          // Tabs
          TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.purple,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textHint,
            tabs: const [
              Tab(text: '📋 Problem'),
              Tab(text: '💻 Code'),
              Tab(text: '📤 Output'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // Problem tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _problem != null
                      ? FadeIn(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_problem!.title,
                                  style: AppTextStyles.h1),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  DiffBadge(
                                      difficulty: _problem!.difficulty),
                                  const SizedBox(width: 8),
                                  Text(
                                      '${_problem!.acceptanceRate}% acceptance',
                                      style: AppTextStyles.small),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(_problem!.description,
                                  style: AppTextStyles.body.copyWith(
                                      color: AppColors.textPrimary,
                                      height: 1.6)),
                              const SizedBox(height: 20),
                              Text('Test Cases:', style: AppTextStyles.h3),
                              const SizedBox(height: 8),
                              ...List.generate(
                                _problem!.testCases.length,
                                (i) {
                                  final tc = _problem!.testCases[i];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12),
                                    child: GlassCard(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Test Case ${i + 1}',
                                              style: AppTextStyles.h3
                                                  .copyWith(fontSize: 13)),
                                          const SizedBox(height: 8),
                                          _CodeBlock(
                                              label: 'Input',
                                              text: tc.input),
                                          const SizedBox(height: 6),
                                          _CodeBlock(
                                              label: 'Expected',
                                              text: tc.expectedOutput),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (_problem!.hint != null) ...[
                                const SizedBox(height: 12),
                                GlassCard(
                                  gradient: LinearGradient(colors: [
                                    AppColors.orange.withOpacity(0.1),
                                    AppColors.orange.withOpacity(0.02),
                                  ]),
                                  child: Row(
                                    children: [
                                      const Text('💡',
                                          style: TextStyle(fontSize: 18)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(_problem!.hint!,
                                            style: AppTextStyles.body),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.purple)),
                ),

                // Code tab
                Column(
                  children: [
                    // Language selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: AppColors.bgCard,
                      child: Row(
                        children: [
                          const Icon(Icons.code,
                              color: AppColors.purple, size: 18),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _selectedLang,
                            dropdownColor: AppColors.bgCard,
                            style: AppTextStyles.h3.copyWith(fontSize: 13),
                            underline: const SizedBox(),
                            items: _languages
                                .map((l) => DropdownMenuItem(
                                      value: l,
                                      child: Text(l.toUpperCase()),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _selectedLang = v);
                              }
                            },
                          ),
                          const Spacer(),
                          GradientButton(
                            label: 'Run',
                            small: true,
                            icon: Icons.play_arrow,
                            loading: _running,
                            onTap: _runCode,
                          ),
                          const SizedBox(width: 8),
                          GradientButton(
                            label: 'Submit',
                            small: true,
                            icon: Icons.check,
                            gradient: AppColors.gradGreenBlue,
                            loading: _running,
                            onTap: _submitCode,
                          ),
                        ],
                      ),
                    ),
                    // Code editor
                    Expanded(
                      child: Container(
                        color: const Color(0xFF0A0818),
                        child: TextField(
                          controller: _codeCtrl,
                          maxLines: null,
                          expands: true,
                          style: AppTextStyles.code.copyWith(fontSize: 13),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: '// Write your code here...',
                            hintStyle: TextStyle(
                                color: AppColors.textHint, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Output tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Output', style: AppTextStyles.h3),
                                const Spacer(),
                                if (_output.contains('❌'))
                                  GradientButton(
                                    label: 'Why Failed?',
                                    small: true,
                                    icon: Icons.auto_awesome,
                                    gradient: AppColors.gradPinkPurple,
                                    loading: _explaining,
                                    onTap: _explainFailure,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A0818),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SelectableText(
                                _output.isEmpty
                                    ? 'Run your code to see output...'
                                    : _output,
                                style: AppTextStyles.code
                                    .copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_explanation.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        GlassCard(
                          gradient: LinearGradient(colors: [
                            AppColors.pink.withOpacity(0.08),
                            AppColors.purple.withOpacity(0.05),
                          ]),
                          borderColor: AppColors.pink.withOpacity(0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('🤖',
                                      style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text('AI Explanation',
                                      style: AppTextStyles.h3),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SelectableText(
                                _explanation,
                                style: AppTextStyles.body.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String label;
  final String text;
  const _CodeBlock({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.small.copyWith(color: AppColors.purple)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0818),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(text, style: AppTextStyles.code.copyWith(fontSize: 12)),
        ),
      ],
    );
  }
}

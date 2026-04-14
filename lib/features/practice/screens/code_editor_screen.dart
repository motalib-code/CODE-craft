import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/points_badge.dart';
import '../../../core/services/judge0_service.dart';
import '../../../core/services/gemini_service.dart';
import '../notifiers/practice_notifier.dart';
import '../../../models/problem_model.dart';
import '../../auth/notifiers/auth_notifier.dart';

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

  String _selectedLang = 'cpp';
  String _output = '';
  bool _running = false;
  ProblemModel? _problem;

  final _languages = ['cpp', 'python', 'java', 'javascript', 'c'];

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

  @override
  void dispose() {
    _tabCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom Top Bar ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text('CodeCraft', style: AppTextStyles.h2.copyWith(color: AppColors.blue)),
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

            // ── Problem Header ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_problem?.title ?? 'Two Sum', style: AppTextStyles.display.copyWith(fontSize: 28)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('Easy', style: AppTextStyles.small.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.people_outline, color: AppColors.textHint, size: 14),
                            const SizedBox(width: 4),
                            Text('125.4k solved', style: AppTextStyles.small),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Language Selector & Tabs ────────────
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: _languages.map((lang) {
                  bool isSelected = lang == _selectedLang;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLang = lang),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lang.toUpperCase(),
                            style: AppTextStyles.small.copyWith(
                              color: isSelected ? AppColors.purple : AppColors.textHint,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 12,
                              height: 2,
                              color: AppColors.purple,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(color: AppColors.border, height: 1),

            // ── Editor Area ──────────────────────────
            Expanded(
              child: Container(
                color: const Color(0xFF03030F),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line numbers
                    Container(
                      width: 40,
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: List.generate(20, (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text('${i + 1}', style: AppTextStyles.code.copyWith(color: AppColors.textHint.withOpacity(0.3), fontSize: 12)),
                        )),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _codeCtrl,
                        maxLines: null,
                        expands: true,
                        style: AppTextStyles.code.copyWith(fontSize: 14, height: 1.5, color: Colors.blue[100]),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 16, right: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Footer Actions ────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                border: const Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (_problem != null) _codeCtrl.text = _problem!.boilerplate;
                    },
                    icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 20),
                    label: Text('Reset', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                  ),
                  const Spacer(),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.bgInput,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.terminal, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  GradientButton(
                    label: 'Run',
                    small: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  GradientButton(
                    label: 'Submit Code',
                    gradient: AppColors.gradGreenBlue,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


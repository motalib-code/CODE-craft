import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/glass_card.dart';
import '../notifiers/auth_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _collegeCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  String _year = '';
  String _level = '';

  @override
  void dispose() {
    _collegeCtrl.dispose();
    _githubCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && _collegeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your institution')),
      );
      return;
    }
    if (_step == 1 && _year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your year')),
      );
      return;
    }
    if (_step == 2 && _level.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your coding level')),
      );
      return;
    }

    if (_step < 3) {
      setState(() => _step++);
    } else {
      _save();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    }
  }

  Future<void> _save() async {
    final notifier = ref.read(userDataProvider.notifier);
    await notifier.saveOnboarding(
      college: _collegeCtrl.text.trim(),
      year: _year,
      level: _level,
      githubUsername:
          _githubCtrl.text.trim().isNotEmpty ? _githubCtrl.text.trim() : null,
    );
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Subtle background grid or glow effect as seen in "Which college?"
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDynamicTopBar(),

                // Step content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildStep(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTopBar() {
    if (_step == 1 || _step == 3) {
      // Dots style (CodeCraft theme)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.terminal, color: AppColors.purple, size: 16),
                ),
                const SizedBox(width: 12),
                Text('CodeCraft', style: AppTextStyles.h3),
              ],
            ),
            Row(
              children: List.generate(4, (i) {
                return Container(
                  width: _step == i ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _step >= i ? AppColors.purple : AppColors.bgInput,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            TextButton(
              onPressed: () => context.go('/auth/login'),
              child: Text('EXIT', style: AppTextStyles.small.copyWith(letterSpacing: 1.2)),
            )
          ],
        ),
      );
    } else {
      // Progress line style (The Neon Scholar theme)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.code, color: AppColors.purple, size: 16),
                ),
                const SizedBox(width: 12),
                Text('The Neon Scholar', style: AppTextStyles.h3),
                const Spacer(),
                if (_step == 0) TextButton(
                   onPressed: () {},
                   child: Text('SUPPORT', style: AppTextStyles.small.copyWith(letterSpacing: 1.2)),
                )
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('STEP 0 / 04', style: AppTextStyles.btnSm.copyWith(color: AppColors.textSecondary)),
                Text('% COMPLETE', style: AppTextStyles.small),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bgInput,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: _step + 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.gradPurpleBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3 - _step,
                    child: const SizedBox(),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildCollegeStep();
      case 1:
        return _buildYearStep();
      case 2:
        return _buildLevelStep();
      case 3:
        return _buildGithubStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCollegeStep() {
    return FadeInRight(
      key: const ValueKey(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Which college?', style: AppTextStyles.display.copyWith(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              "Tell us where you're sharpening your\\ndigital blades.",
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary, height: 1.4, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _collegeCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for your institution...',
                hintStyle: AppTextStyles.body.copyWith(fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 22),
                filled: true,
                fillColor: const Color(0xFF1E1C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 32),
            Text('TRENDING INSTITUTIONS', style: AppTextStyles.small.copyWith(letterSpacing: 1.5)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildPill('IIT Bombay', true),
                _buildPill('NIT Trichy', false),
                _buildPill('BITS Pilani', true),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.textHint),
                  label: Text('Back', style: AppTextStyles.h3.copyWith(color: AppColors.textHint)),
                ),
                ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      Text('Continue', style: AppTextStyles.btn),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© 2024 THE NEON SCHOLAR // DIGITAL ACADEMY',
                style: AppTextStyles.small.copyWith(letterSpacing: 1.5, fontSize: 10, color: AppColors.textHint.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _collegeCtrl.text = title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _collegeCtrl.text == title ? AppColors.bgInput.withOpacity(0.8) : const Color(0xFF131120),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _collegeCtrl.text == title ? AppColors.purple.withOpacity(0.5) : AppColors.border.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            const Icon(Icons.add, size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildYearStep() {
    final levels = [
      {'num': '01', 'title': '1st Year', 'desc': 'The Foundation Phase', 'icon': Icons.rocket_launch},
      {'num': '02', 'title': '2nd Year', 'desc': 'Deepening the Core', 'icon': Icons.auto_awesome},
      {'num': '03', 'title': '3rd Year', 'desc': 'System Engineering', 'icon': Icons.architecture},
      {'num': '04', 'title': '4th Year', 'desc': 'Career Synthesis', 'icon': Icons.workspace_premium},
    ];

    return FadeInRight(
      key: const ValueKey(1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.display.copyWith(fontSize: 36, height: 1.2),
                children: [
                  const TextSpan(text: 'What '),
                  TextSpan(text: 'year', style: AppTextStyles.display.copyWith(color: AppColors.purple, fontStyle: FontStyle.italic, fontSize: 36)),
                  const TextSpan(text: ' are you\\n in?'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "We'll tailor your roadmap based on your\\ncurrent academic standing and\\nupcoming milestones.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(height: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.separated(
                itemCount: levels.length,
                separatorBuilder: (c, i) => const SizedBox(height: 16),
                itemBuilder: (c, i) {
                  final l = levels[i];
                  final isSelected = _year == l['title'];
                  return GestureDetector(
                    onTap: () => setState(() => _year = l['title'] as String),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13111E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('LEVEL ', style: AppTextStyles.small.copyWith(letterSpacing: 2, color: AppColors.textHint)),
                                  Icon(l['icon'] as IconData, color: isSelected ? AppColors.purple : AppColors.textHint, size: 20),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(l['title'] as String, style: AppTextStyles.h2.copyWith(fontSize: 22)),
                              const SizedBox(height: 4),
                              Text(l['desc'] as String, style: AppTextStyles.body),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: -8,
                            right: -8,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.check_circle, color: AppColors.bg, size: 24),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              onTap: _next,
              label: 'Next',
              width: 160,
            ),
            const SizedBox(height: 16),
            Text('STEP 02 OF 04', style: AppTextStyles.small.copyWith(letterSpacing: 2)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelStep() {
    final levels = [
      {'title': 'Beginner', 'emoji': Icons.eco_outlined, 'desc': 'Foundational syntax and logic. Ready to\\nplant the first seeds of digital logic.'},
      {'title': 'Intermediate', 'emoji': Icons.grass, 'desc': 'Comfortable with APIs and data\\nstructures. Building complexity and\\nscaling branches.'},
      {'title': 'Advanced', 'emoji': Icons.account_tree_outlined, 'desc': 'Architecting distributed systems.\\nMastering the deep algorithms of the\\nforest.'},
    ];

    return FadeInRight(
      key: const ValueKey(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text('Your coding\\nlevel?', textAlign: TextAlign.center, style: AppTextStyles.display.copyWith(fontSize: 42, height: 1.1)),
            const SizedBox(height: 16),
            Text(
              "We tailor your academic track based on\\nyour current technical mastery. Select\\nthe tier that mirrors your journey.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(height: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: levels.length,
                separatorBuilder: (c, i) => const SizedBox(height: 16),
                itemBuilder: (c, i) {
                  final l = levels[i];
                  final isSelected = _level == l['title'];
                  return GestureDetector(
                    onTap: () => setState(() => _level = l['title'] as String),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161522),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppColors.purple : Colors.transparent, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF221F33),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(l['emoji'] as IconData, color: Colors.white, size: 28),
                              ),
                              const SizedBox(height: 24),
                              Text(l['title'] as String, style: AppTextStyles.h2.copyWith(fontSize: 22)),
                              const SizedBox(height: 8),
                              Text(l['desc'] as String, style: AppTextStyles.body.copyWith(height: 1.4)),
                              if (isSelected) ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text('SELECTED', style: AppTextStyles.small.copyWith(color: AppColors.purple, letterSpacing: 1.5)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.check, size: 14, color: AppColors.purple),
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Positioned(
                            top: 24,
                            right: 24,
                            child: Icon(Icons.check_circle, color: AppColors.purple, size: 24),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ]
              ),
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Initialize Path', style: AppTextStyles.btn.copyWith(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _back,
              child: Text('BACK TO PREVIOUS STEP', style: AppTextStyles.small.copyWith(letterSpacing: 1.5)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGithubStep() {
    return FadeInRight(
      key: const ValueKey(3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 1),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A2E),
                border: Border.all(color: AppColors.purple.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue.withOpacity(0.2),
                ),
                child: const Icon(Icons.code, size: 48, color: AppColors.blue),
              ),
            ),
            const SizedBox(height: 32),
            Text('Connect GitHub\n(Optional)', textAlign: TextAlign.center, style: AppTextStyles.display.copyWith(fontSize: 36, height: 1.2)),
            const SizedBox(height: 16),
            Text(
              "Link your GitHub to sync your\nprojects and showcase your\nskills to recruiters.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 48),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('GITHUB USERNAME', style: AppTextStyles.small.copyWith(letterSpacing: 1.5)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _githubCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'johndoe_dev',
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.alternate_email, color: AppColors.textHint),
                filled: true,
                fillColor: const Color(0xFF1E1C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Complete Setup', style: AppTextStyles.btn.copyWith(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _save,
              child: Text('Skip for now', style: AppTextStyles.h3.copyWith(color: AppColors.textHint)),
            ),
            const Spacer(flex: 2),
            const Divider(color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: AppColors.green),
                      const SizedBox(width: 8),
                      Text('ENCRYPTED SYNC', style: AppTextStyles.small.copyWith(letterSpacing: 1.2, color: AppColors.textSecondary)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 16, color: AppColors.purple),
                      const SizedBox(width: 8),
                      Text('AUTO-PORTFOLIO', style: AppTextStyles.small.copyWith(letterSpacing: 1.2, color: AppColors.textSecondary)),
                    ],
                  )
                ],
              ),
            ),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            Text('STEP 04 | FINALIZING CODECRAFT PROTOCOL', style: AppTextStyles.small.copyWith(letterSpacing: 2, color: AppColors.textHint.withOpacity(0.5))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Background painter for the subtle grid seen in Neon Scholar
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.2)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

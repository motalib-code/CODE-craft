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
        const SnackBar(content: Text('Please enter your college name')),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress bar
              Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        gradient:
                            i <= _step ? AppColors.gradPurpleBlue : null,
                        color:
                            i > _step ? AppColors.bgInput : null,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text('Step ${_step + 1} of 4', style: AppTextStyles.small),
              const SizedBox(height: 32),

              // Step content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(),
                ),
              ),

              // Buttons
              Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _step--),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text('Back', style: AppTextStyles.btn
                                .copyWith(color: AppColors.textSecondary)),
                          ),
                        ),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      label: _step == 3 ? "Let's Go! 🚀" : 'Next',
                      onTap: _step == 3 && _githubCtrl.text.isEmpty
                          ? _save
                          : _next,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              if (_step == 3) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _save,
                    child: Text('Skip for now',
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.purple)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            text: '🎓 What college are you from?',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 8),
          Text('This helps us connect you with peers',
              style: AppTextStyles.body),
          const SizedBox(height: 24),
          TextFormField(
            controller: _collegeCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'e.g. IIT Bombay, NIT Trichy...',
              prefixIcon:
                  Icon(Icons.school_outlined, color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearStep() {
    final years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
    final emojis = ['🌱', '🌿', '🌳', '🎯'];

    return FadeInRight(
      key: const ValueKey(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            text: '📅 Which year are you in?',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 24),
          ...List.generate(years.length, (i) {
            final selected = _year == years[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                onTap: () => setState(() => _year = years[i]),
                borderColor:
                    selected ? AppColors.purple : AppColors.border,
                gradient: selected
                    ? LinearGradient(
                        colors: [
                          AppColors.purple.withOpacity(0.15),
                          AppColors.blue.withOpacity(0.05),
                        ],
                      )
                    : null,
                child: Row(
                  children: [
                    Text(emojis[i],
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 16),
                    Text(years[i], style: AppTextStyles.h3),
                    const Spacer(),
                    if (selected)
                      const Icon(Icons.check_circle,
                          color: AppColors.purple, size: 22),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLevelStep() {
    final levels = [
      {'title': 'Beginner', 'emoji': '🌱', 'desc': 'Just starting to code'},
      {'title': 'Intermediate', 'emoji': '🔥', 'desc': 'Know basics, building skills'},
      {'title': 'Advanced', 'emoji': '⚡', 'desc': 'Ready for hard problems'},
    ];

    return FadeInRight(
      key: const ValueKey(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            text: '💪 What\'s your coding level?',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 24),
          ...levels.map((l) {
            final selected = _level == l['title'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                onTap: () => setState(() => _level = l['title']!),
                borderColor:
                    selected ? AppColors.purple : AppColors.border,
                gradient: selected
                    ? LinearGradient(
                        colors: [
                          AppColors.purple.withOpacity(0.15),
                          AppColors.blue.withOpacity(0.05),
                        ],
                      )
                    : null,
                child: Row(
                  children: [
                    Text(l['emoji']!,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l['title']!, style: AppTextStyles.h3),
                          Text(l['desc']!, style: AppTextStyles.small),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle,
                          color: AppColors.purple, size: 22),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGithubStep() {
    return FadeInRight(
      key: const ValueKey(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            text: '🔗 Connect your GitHub',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 8),
          Text('Show off your projects and contributions',
              style: AppTextStyles.body),
          const SizedBox(height: 24),
          TextFormField(
            controller: _githubCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'GitHub username (optional)',
              prefixIcon:
                  Icon(Icons.code, color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '✨ This is optional. You can always add it later from your profile.',
            style: AppTextStyles.small,
          ),
        ],
      ),
    );
  }
}

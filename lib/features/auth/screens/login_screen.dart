import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/utils/validators.dart';
import '../notifiers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authNotifierProvider.notifier);
    final success = await notifier.signInWithEmail(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (success && mounted) context.go('/home');
  }

  Future<void> _loginGoogle() async {
    final notifier = ref.read(authNotifierProvider.notifier);
    final success = await notifier.signInWithGoogle();
    if (!mounted) return;
    if (success) {
      final authState = ref.read(authNotifierProvider);
      if (authState.isNewUser) {
        context.go('/auth/onboarding');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header Logo ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.code_rounded, color: AppColors.purple, size: 28),
                    const SizedBox(width: 8),
                    Text('CodeCraft', style: AppTextStyles.h2),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        ref.read(authNotifierProvider.notifier).setGuestMode(true);
                        context.go('/home');
                      },
                      child: Text(
                        'Skip →',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textHint,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Hero Section ────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=1000',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.bg.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 2),
                              color: Colors.black26,
                            ),
                            child: const Icon(Icons.code, color: Colors.white, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Welcome Text ────────────────────────
              FadeInDown(
                child: Text(
                  'Welcome back,\nCoder!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display.copyWith(fontSize: 36, height: 1.1),
                ),
              ),
              const SizedBox(height: 12),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Continue your journey to becoming a 10x developer',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ── Login Form ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EMAIL ADDRESS', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textHint)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        validator: Validators.email,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'college@email.com',
                          prefixIcon: const Icon(Icons.email_outlined, size: 20),
                          fillColor: AppColors.bgSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text('PASSWORD', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textHint)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text('Forgot?', style: AppTextStyles.small.copyWith(color: AppColors.purple)),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        validator: Validators.password,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          fillColor: AppColors.bgSurface.withOpacity(0.5),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: 'Sign In',
                        width: double.infinity,
                        loading: authState.isLoading,
                        onTap: _loginEmail,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR', style: AppTextStyles.small.copyWith(color: AppColors.textHint)),
                          ),
                          const Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _loginGoogle,
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                                height: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('New here? ', style: AppTextStyles.body.copyWith(color: AppColors.textHint)),
                          GestureDetector(
                            onTap: () => context.go('/auth/signup'),
                            child: Text('Create account', style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          '© 2024 CODECRAFT ECOSYSTEM • LEVEL UP YOUR GAME',
                          style: AppTextStyles.small.copyWith(fontSize: 9, color: AppColors.textHint, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

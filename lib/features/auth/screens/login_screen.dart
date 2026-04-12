import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/glass_card.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).setGuestMode(true);
              context.go('/home');
            },
            child: const Text(
              'Skip →',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                FadeInDown(
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradPurpleBlue,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('</>',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: GradientText(
                    text: 'Welcome Back!',
                    style: AppTextStyles.display,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Sign in to continue your coding journey',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 36),

                // Error message
                if (authState.error != null)
                  FadeIn(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(authState.error!,
                                style: AppTextStyles.small
                                    .copyWith(color: AppColors.red)),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Email field
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: Validators.email,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: AppColors.textHint),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: Validators.password,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textHint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textHint,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 550),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showResetDialog();
                      },
                      child: Text('Forgot Password?',
                          style: AppTextStyles.small
                              .copyWith(color: AppColors.purple)),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Login button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: GradientButton(
                    label: 'Log In',
                    loading: authState.isLoading,
                    onTap: _loginEmail,
                    width: double.infinity,
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                            color: AppColors.border, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR',
                            style: AppTextStyles.small),
                      ),
                      const Expanded(
                        child: Divider(
                            color: AppColors.border, thickness: 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Google sign in
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: GlassCard(
                    onTap: authState.isLoading ? null : _loginGoogle,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text('G',
                                style: TextStyle(
                                    color: Color(0xFF4285F4),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Continue with Google',
                            style: AppTextStyles.h3),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Sign up link
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: AppTextStyles.body),
                      GestureDetector(
                        onTap: () => context.go('/auth/signup'),
                        child: Text('Sign Up',
                            style: AppTextStyles.h3
                                .copyWith(color: AppColors.purple)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResetDialog() {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reset Password', style: AppTextStyles.h2),
        content: TextField(
          controller: emailCtrl,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(authNotifierProvider.notifier)
                  .resetPassword(emailCtrl.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset email sent!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

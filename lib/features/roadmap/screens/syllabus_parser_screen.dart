import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/services/gemini_service.dart';

class SyllabusParserScreen extends StatefulWidget {
  const SyllabusParserScreen({super.key});

  @override
  State<SyllabusParserScreen> createState() => _SyllabusParserScreenState();
}

class _SyllabusParserScreenState extends State<SyllabusParserScreen> {
  final _gemini = GeminiService();
  final _controller = TextEditingController();
  String? _result;
  bool _isLoading = false;

  Future<void> _parse() async {
    if (_controller.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final res = await _gemini.parseSyllabus(_controller.text);
      setState(() {
        _result = res;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _gemini.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Syllabus Parser'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Text(
                'Upload or Paste your Syllabus 📄',
                style: AppTextStyles.h2,
              ),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'AI will analyze your college curriculum and create a personalized learning path for you.',
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 24),

            FadeInUp(
              child: GlassCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      maxLines: 8,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Paste topics from your college PDF or website here...',
                        filled: true,
                        fillColor: AppColors.bgInput.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      label: _isLoading ? 'Analyzing...' : 'Generate Roadmap',
                      onTap: _isLoading ? null : _parse,
                      loading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),

            if (_result != null) ...[
              const SizedBox(height: 32),
              FadeInUp(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.purple, size: 24),
                        const SizedBox(width: 8),
                        GradientText(
                          text: 'AI Generated Path',
                          style: AppTextStyles.h2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: MarkdownBody(
                        data: _result!,
                        styleSheet: MarkdownStyleSheet(
                          p: AppTextStyles.body,
                          h2: AppTextStyles.h3.copyWith(color: AppColors.purple),
                          listBullet: AppTextStyles.body,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'Add to My Tracks',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to your tracks! 🎉')),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

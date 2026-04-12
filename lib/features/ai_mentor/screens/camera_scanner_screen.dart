import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/utils/platform_utils.dart';

class CameraScannerScreen extends StatefulWidget {
  const CameraScannerScreen({super.key});

  @override
  State<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen> {
  final _gemini = GeminiService();
  final _picker = ImagePicker();

  bool _scanning = false;
  Map<String, String>? _result;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image == null) return;

      setState(() { _scanning = true; _error = null; _result = null; });

      final bytes = await image.readAsBytes();
      final result = await _gemini.scanImage(bytes);

      setState(() { _result = result; _scanning = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _scanning = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: Text('📸 Code Scanner', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            FadeInDown(
              child: GlassCard(
                gradient: LinearGradient(
                  colors: [
                    AppColors.pink.withOpacity(0.1),
                    AppColors.purple.withOpacity(0.05),
                  ],
                ),
                borderColor: AppColors.pink.withOpacity(0.3),
                child: Column(
                  children: [
                    const Text('📸', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    GradientText(
                      text: 'Scan Code from Image',
                      style: AppTextStyles.h2,
                      gradient: AppColors.gradPinkPurple,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a photo or upload an image of code.\nAI will extract, analyze, and find bugs!',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  if (!PlatformUtils.isWeb) ...[
                    Expanded(
                      child: GradientButton(
                        label: 'Camera',
                        icon: Icons.camera_alt,
                        gradient: AppColors.gradPinkPurple,
                        loading: _scanning,
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: GradientButton(
                      label: 'Gallery',
                      icon: Icons.photo_library,
                      loading: _scanning,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Loading
            if (_scanning)
              FadeIn(
                child: GlassCard(
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: AppColors.purple,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('🔍 Analyzing code...',
                          style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text('AI is extracting and reviewing your code',
                          style: AppTextStyles.body),
                    ],
                  ),
                ),
              ),

            // Error
            if (_error != null)
              FadeIn(
                child: GlassCard(
                  borderColor: AppColors.red.withOpacity(0.3),
                  child: Column(
                    children: [
                      const Text('❌', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text('Scan Failed', style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(_error!, style: AppTextStyles.body),
                      const SizedBox(height: 12),
                      GradientButton(
                        label: 'Try Again',
                        small: true,
                        onTap: () =>
                            setState(() { _error = null; }),
                      ),
                    ],
                  ),
                ),
              ),

            // Result
            if (_result != null) ...[
              FadeInUp(
                child: GlassCard(
                  borderColor: AppColors.green.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('✅ Code Extracted!',
                              style: AppTextStyles.h3),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _result!['language'] ?? 'Unknown',
                              style: AppTextStyles.small
                                  .copyWith(color: AppColors.purple),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('📋 Purpose:', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(_result!['purpose'] ?? '', style: AppTextStyles.body),
                      const SizedBox(height: 12),
                      Text('💻 Code:', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0818),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SelectableText(
                          _result!['code'] ?? '',
                          style: AppTextStyles.code.copyWith(fontSize: 11),
                        ),
                      ),
                      if (_result!['bugs']?.isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        Text('🐛 Bugs Found:',
                            style: AppTextStyles.h3.copyWith(
                                fontSize: 13, color: AppColors.red)),
                        const SizedBox(height: 4),
                        Text('• ${_result!['bugs']}',
                            style: AppTextStyles.body),
                      ],
                      if (_result!['improvements']?.isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 12),
                        Text('💡 Improvements:',
                            style: AppTextStyles.h3.copyWith(
                                fontSize: 13, color: AppColors.green)),
                        const SizedBox(height: 4),
                        Text('• ${_result!['improvements']}',
                            style: AppTextStyles.body),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

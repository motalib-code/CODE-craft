import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../notifiers/ai_mentor_notifier.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  void _send([String? text]) {
    final message = text ?? _msgCtrl.text.trim();
    if (message.isEmpty) return;
    _msgCtrl.clear();
    ref.read(aiMentorNotifierProvider.notifier).sendMessage(message);
    _scrollToBottom();
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

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiMentorNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom App Bar ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=AI&background=9333EA&color=fff'),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bg, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CodeCraft AI', style: AppTextStyles.h2.copyWith(fontSize: 18)),
                      Text('ONLINE • NEURAL ENGINE V4.2', 
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.green, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.settings, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),

            // ── Chat Body ────────────────────────────
            Expanded(
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(20),
                children: [
                  // System Status Message
                  FadeInUp(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSystemLine('connection_established', 'true'),
                          _buildSystemLine('greeting', '"Welcome back, Lead Dev."'),
                          _buildSystemLine('status', '"I\'ve analyzed your latest repository. Ready to refactor that async middleware?"'),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'async function initSystem() {\n  try {\n    const nexus = await CodeCraft.connect();\n    // Handshake in progress...\n    return nexus.ready;\n  } catch (err) {\n    console.error(`ERR: \${err}`);\n  }\n}',
                              style: AppTextStyles.code.copyWith(fontSize: 12, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('AI MENTOR • 09:41 AM', style: AppTextStyles.small.copyWith(fontSize: 8, color: AppColors.textHint)),
                  const SizedBox(height: 24),

                  // User Message
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FadeInRight(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: AppColors.gradPurpleBlue,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                            child: Text(
                              'Can you explain why the useEffect hook is causing an infinite loop in my dashboard component?',
                              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('YOU • 09:42 AM', style: AppTextStyles.small.copyWith(fontSize: 8, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // AI Response
                  FadeInUp(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The infinite loop typically occurs because you\'re updating a state variable inside useEffect that is also listed in its dependency array.',
                            style: AppTextStyles.body,
                          ),
                          const SizedBox(height: 16),
                          _buildCodeCompareCard(),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.green.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.tips_and_updates, color: AppColors.green, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'PRO TIP: Always use a functional update if you depend on previous state.',
                                    style: AppTextStyles.small.copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('AI MENTOR • 09:43 AM', style: AppTextStyles.small.copyWith(fontSize: 8, color: AppColors.textHint)),
                  const SizedBox(height: 32),

                  // "Neural Core Processing..." Status
                  Row(
                    children: [
                      _buildDot(0),
                      _buildDot(1),
                      _buildDot(2),
                      const SizedBox(width: 10),
                      Text('NEURAL CORE IS PROCESSING...', style: AppTextStyles.small.copyWith(letterSpacing: 1, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Suggestions
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSuggestionChip('Explain Redux vs Context'),
                        _buildSuggestionChip('Debug my React API call'),
                        _buildSuggestionChip('Best practices for hooks'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemLine(String key, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('> ', style: AppTextStyles.code.copyWith(color: AppColors.green, fontSize: 12)),
          Text('$key: ', style: AppTextStyles.code.copyWith(color: AppColors.green, fontSize: 12)),
          Text(val, style: AppTextStyles.code.copyWith(color: AppColors.blue, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCodeCompareCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('// ❌ The Loop Creator', style: AppTextStyles.code.copyWith(color: AppColors.red, fontSize: 11)),
          Text('useEffect(() => {\n  setData(val);\n}, [data]);', style: AppTextStyles.code.copyWith(fontSize: 11)),
          const SizedBox(height: 12),
          Text('// ✅ The Optimized Way', style: AppTextStyles.code.copyWith(color: AppColors.green, fontSize: 11)),
          Text('useEffect(() => {\n  fetchData();\n}, []);', style: AppTextStyles.code.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDot(int i) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(color: AppColors.purple, shape: BoxShape.circle),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

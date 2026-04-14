import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/points_badge.dart';
import '../notifiers/image_generator_notifier.dart';

class ImageGeneratorScreen extends ConsumerStatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  ConsumerState<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends ConsumerState<ImageGeneratorScreen> {
  final _promptCtrl = TextEditingController();
  String _selectedStyle = 'Cyberpunk';
  String _selectedRatio = '16:9';

  final _styles = ['Cyberpunk', 'Minimalist', '3D Render', 'Blueprint', 'Anime'];
  final _ratios = ['1:1', '16:9', '9:16', '4:3'];

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    if (_promptCtrl.text.trim().isEmpty) return;
    ref.read(imageGeneratorNotifierProvider.notifier).generateImage(_promptCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imageGeneratorNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.purple, size: 28),
                    const SizedBox(width: 8),
                    Text('Visual Studio', style: AppTextStyles.h2),
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

              // ── Header Section ───────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Project\nVisualizer', style: AppTextStyles.display.copyWith(fontSize: 40, height: 1.1)),
                    const SizedBox(height: 12),
                    Text(
                      'Turn your architectural blueprints and code logic into stunning, ready-to-use visual assets.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
              ),

              // ── Prompt Input ─────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ENTER PROMPT', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textHint)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _promptCtrl,
                        maxLines: 4,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'e.g., A futuristic neural network terminal in a dark room with teal neon highlights...',
                          fillColor: Colors.black26,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('STYLE', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textHint)),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _styles.map((s) => _buildSelectionChip(s, _selectedStyle == s, (v) => setState(() => _selectedStyle = v))).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('ASPECT RATIO', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textHint)),
                      const SizedBox(height: 12),
                      Row(
                        children: _ratios.map((r) => Expanded(child: _buildSelectionChip(r, _selectedRatio == r, (v) => setState(() => _selectedRatio = v)))).toList(),
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: 'Generate Visual',
                        loading: state.isLoading,
                        width: double.infinity,
                        onTap: _generate,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Results Area ─────────────────────────
              if (state.isLoading || state.generatedImageUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RESULT', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textHint)),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: _getRatioValue(_selectedRatio),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (state.isLoading)
                                Container(
                                  color: AppColors.bgSurface,
                                  child: const Center(child: CircularProgressIndicator(color: AppColors.purple)),
                                )
                              else if (state.generatedImageUrl != null)
                                Image.network(state.generatedImageUrl!, fit: BoxFit.cover),
                              
                              if (!state.isLoading)
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Row(
                                    children: [
                                      _buildRoundButton(Icons.download, () {}),
                                      const SizedBox(width: 8),
                                      _buildRoundButton(Icons.share, () {}),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),

              // ── Recent Gallery ───────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text('Recent Collections', style: AppTextStyles.h2),
                    const Spacer(),
                    Text('View All', style: AppTextStyles.small.copyWith(color: AppColors.purple)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  itemCount: 4,
                  itemBuilder: (context, i) {
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1635776062127-d379bfcba9f8?w=200&q=80&i=$i'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionChip(String label, bool isSelected, Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple.withOpacity(0.2) : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.purple : AppColors.border),
        ),
        child: Text(label, style: AppTextStyles.body.copyWith(fontSize: 13, color: isSelected ? Colors.white : AppColors.textHint)),
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  double _getRatioValue(String ratio) {
    switch (ratio) {
      case '16:9': return 16 / 9;
      case '9:16': return 9 / 16;
      case '4:3': return 4 / 3;
      default: return 1.0;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import 'package:animate_do/animate_do.dart';

class OfflineSyncScreen extends ConsumerStatefulWidget {
  const OfflineSyncScreen({super.key});

  @override
  ConsumerState<OfflineSyncScreen> createState() => _OfflineSyncScreenState();
}

class _OfflineSyncScreenState extends ConsumerState<OfflineSyncScreen> {
  bool liteMode = false;
  double downloadProgress = 0.0;
  bool isDownloading = false;

  void _startSync() {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.1;
    });
    
    // Simulate progression
    Future.delayed(const Duration(milliseconds: 800), () => setState(() => downloadProgress = 0.4));
    Future.delayed(const Duration(milliseconds: 1600), () => setState(() => downloadProgress = 0.7));
    Future.delayed(const Duration(milliseconds: 2400), () => setState(() {
      downloadProgress = 1.0;
      isDownloading = false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Offline & Data', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text('Data Management', style: AppTextStyles.h1),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lite Mode', style: AppTextStyles.h3),
                                const SizedBox(height: 4),
                                Text('Reduces animation & image quality to save bandwidth.', style: AppTextStyles.small),
                              ],
                            ),
                          ),
                          Switch(
                            value: liteMode,
                            activeColor: AppColors.purple,
                            onChanged: (val) => setState(() => liteMode = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Divider(color: AppColors.border),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.cloud_download, color: AppColors.blue, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Offline Sync', style: AppTextStyles.h3),
                                const SizedBox(height: 4),
                                Text('Download DSA topics, syllabuses, and recent mentor logs for offline access.', style: AppTextStyles.small),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (isDownloading) ...[
                        LinearProgressIndicator(
                          value: downloadProgress,
                          backgroundColor: AppColors.bgInput,
                          color: AppColors.blue,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Text('Syncing packages... ${(downloadProgress * 100).toInt()}%', style: AppTextStyles.small.copyWith(color: AppColors.blue)),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: 'Sync Data Now (142 MB)',
                            onTap: _startSync,
                            gradient: AppColors.gradBlueCyan,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text('Storage Used: 48MB / 1.2GB', style: AppTextStyles.small),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

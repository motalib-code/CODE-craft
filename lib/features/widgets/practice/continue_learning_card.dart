import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ContinueLearningCard extends StatelessWidget {
  final String title;
  final String category; // DSA, AI, ML
  final String videoId;
  final String thumbnail;
  final String channelName;
  final VoidCallback onTap;

  const ContinueLearningCard({
    super.key,
    required this.title,
    required this.category,
    required this.videoId,
    required this.thumbnail,
    required this.channelName,
    required this.onTap,
  });

  Color _getCategoryColor() {
    switch (category) {
      case 'DSA':
        return const Color(0xFF6B5CE7); // Purple
      case 'AI':
        return const Color(0xFFFF6B6B); // Red
      case 'ML':
        return const Color(0xFF4ECDC4); // Teal
      default:
        return AppColors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getCategoryColor().withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: thumbnail,
                      width: 140,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 140,
                        height: 100,
                        color: const Color(0xFF2D2070),
                        child: const Icon(Icons.play_circle,
                            color: Colors.white30, size: 32),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 140,
                        height: 100,
                        color: const Color(0xFF2D2070),
                        child:
                            const Icon(Icons.video_library, color: Colors.white30),
                      ),
                    ),
                    Positioned.fill(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white.withOpacity(0.8),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: AppTextStyles.small.copyWith(
                            color: _getCategoryColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Channel
                      Row(
                        children: [
                          const Icon(Icons.verified,
                              size: 10, color: AppColors.purple),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              channelName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.purple,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
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

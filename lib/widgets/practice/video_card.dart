import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/youtube_video.dart';

class VideoCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // Thumbnail with play overlay
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: video.thumbnail,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 80,
                        color: const Color(0xFF2D2070),
                        child: const Icon(Icons.play_circle,
                            color: Colors.white30, size: 28),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 80,
                        color: const Color(0xFF2D2070),
                        child: const Icon(Icons.video_library,
                            color: Colors.white30),
                      ),
                    ),
                    Positioned.fill(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white.withOpacity(0.8),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Title and channel
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.verified,
                              size: 12, color: AppColors.purple),
                          const SizedBox(width: 4),
                          Text(
                            video.channelName,
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.purple,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.open_in_new, color: Colors.white38, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

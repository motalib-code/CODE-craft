import 'package:flutter/material.dart';
import '../models/youtube_video.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video, this.onTap});

  final YouTubeVideo video;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(video.title),
      subtitle: Text(video.channelName),
      onTap: onTap,
    );
  }
}

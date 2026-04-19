import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../models/youtube_video.dart';

class YouTubeService {
  static final YouTubeService _instance = YouTubeService._internal();

  factory YouTubeService() {
    return _instance;
  }

  YouTubeService._internal();

  // Preferred channels to prioritize in results
  static const List<String> preferredChannels = [
    'NeetCode',
    'Abdul Bari',
    'Striver',
    'take U forward',
    'GeeksforGeeks',
    'Errichto',
    'Kevin Naughton Jr',
  ];

  Future<List<YouTubeVideo>> searchVideos(String query,
      {int maxResults = 8, String videoDuration = 'medium'}) async {
    try {
      final url = Uri.parse(ApiConfig.youtubeSearch).replace(
        queryParameters: {
          'part': 'snippet',
          'q': '$query explained tutorial',
          'type': 'video',
          'videoDuration': videoDuration,
          'relevanceLanguage': 'en',
          'maxResults': maxResults.toString(),
          'key': ApiConfig.youtubeApiKey,
        },
      );

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List? ?? [];
        final videos = items.map((item) => YouTubeVideo.fromJson(item)).toList();

        // Sort by preferred channels
        videos.sort((a, b) {
          bool aPreferred = preferredChannels.any((ch) =>
              a.channelName.toLowerCase().contains(ch.toLowerCase()));
          bool bPreferred = preferredChannels.any((ch) =>
              b.channelName.toLowerCase().contains(ch.toLowerCase()));

          if (aPreferred && !bPreferred) return -1;
          if (!aPreferred && bPreferred) return 1;
          return 0;
        });

        return videos;
      }
      return [];
    } catch (e) {
      print('YouTube search error: $e');
      return [];
    }
  }

  Future<List<YouTubeVideo>> searchConceptVideos(String concept) async {
    return searchVideos('$concept explained tutorial');
  }

  Future<List<YouTubeVideo>> searchSolutionVideos(String problemTitle) async {
    return searchVideos('$problemTitle solution');
  }

  String getWatchUrl(String videoId) => 'https://www.youtube.com/watch?v=$videoId';

  String getThumbnail(String videoId) =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
}

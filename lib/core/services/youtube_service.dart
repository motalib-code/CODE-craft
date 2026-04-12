import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';

class YoutubeService {
  static const _key = ApiKeys.youtubeApiKey;
  static const _base = 'https://www.googleapis.com/youtube/v3';

  static const topicPlaylists = {
    'Arrays': 'PLgUwDviBIf0rBT8io74a95xT-hDFZonNs',
    'Trees': 'PLgUwDviBIf0q8Hkd7bK2Bpryj2rVJoIzw',
    'Graphs': 'PLgUwDviBIf0oE3gA41TKO2H5bHpPd7fzn',
    'DP': 'PLgUwDviBIf0qUlt5H_kiKYaNSqJ81PMMY',
    'Sorting': 'PLdo5W4Nhv31bbKJzrsKfMpo_grxuLl8LU',
    'OOP': 'PLu0W_9lII9agS67pKMxsijFVF3bKaD9Kl',
    'Python': 'PLu0W_9lII9agVZLoBHX3SYflSBF33QSdB',
    'Java': 'PLsyeobzWxl7pe_IiTfNyr55kwJPWbgxB5',
    'Flutter': 'PLlsmxlJgn1HJpa28yHzkBmUY-Ty71ZUGc',
    'System Design': 'PLMCXHnjXnTnvo6alSjVkgxV-VH6EPyvoX',
  };

  Future<List<YoutubeVideo>> getTopicVideos(String topic) async {
    final playlistId = topicPlaylists[topic];
    if (playlistId == null) {
      return searchVideos('$topic programming tutorial');
    }

    try {
      final uri =
          Uri.parse('$_base/playlistItems').replace(queryParameters: {
        'part': 'snippet,contentDetails',
        'playlistId': playlistId,
        'maxResults': '15',
        'key': _key,
      });

      final response =
          await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return _fallbackVideos(topic);

      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      return items.map((item) {
        final snippet = item['snippet'];
        return YoutubeVideo(
          videoId: item['contentDetails']['videoId'] as String,
          title: snippet['title'] as String,
          channel: snippet['channelTitle'] as String,
          thumbnail:
              snippet['thumbnails']?['medium']?['url'] as String? ?? '',
        );
      }).toList();
    } catch (_) {
      return _fallbackVideos(topic);
    }
  }

  Future<List<YoutubeVideo>> searchVideos(String query) async {
    try {
      final uri = Uri.parse('$_base/search').replace(queryParameters: {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'maxResults': '10',
        'regionCode': 'IN',
        'key': _key,
      });

      final response =
          await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      return items
          .map((item) => YoutubeVideo(
                videoId: item['id']['videoId'] as String,
                title: item['snippet']['title'] as String,
                channel: item['snippet']['channelTitle'] as String,
                thumbnail: item['snippet']['thumbnails']?['medium']
                        ?['url'] as String? ??
                    '',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  List<YoutubeVideo> _fallbackVideos(String topic) {
    return [
      YoutubeVideo(
          videoId: 'dQw4w9WgXcQ',
          title: '$topic - Complete Tutorial',
          channel: 'CodeCraft',
          thumbnail: ''),
      YoutubeVideo(
          videoId: 'dQw4w9WgXcQ',
          title: '$topic - Advanced Concepts',
          channel: 'CodeCraft',
          thumbnail: ''),
    ];
  }
}

class YoutubeVideo {
  final String videoId, title, channel, thumbnail;

  YoutubeVideo({
    required this.videoId,
    required this.title,
    required this.channel,
    required this.thumbnail,
  });

  String get watchUrl => 'https://youtube.com/watch?v=$videoId';
  String get embedUrl => 'https://www.youtube.com/embed/$videoId';
}

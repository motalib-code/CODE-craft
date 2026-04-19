class YouTubeVideo {
  final String videoId;
  final String title;
  final String channelName;
  final String thumbnail;
  final String description;
  final DateTime publishedAt;

  String get watchUrl => 'https://www.youtube.com/watch?v=$videoId';

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.channelName,
    required this.thumbnail,
    required this.description,
    required this.publishedAt,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      videoId: json['id']['videoId'] ?? '',
      title: json['snippet']['title'] ?? '',
      channelName: json['snippet']['channelTitle'] ?? '',
      thumbnail: json['snippet']['thumbnails']['high']['url'] ?? '',
      description: json['snippet']['description'] ?? '',
      publishedAt: DateTime.tryParse(json['snippet']['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': {'videoId': videoId},
        'snippet': {
          'title': title,
          'channelTitle': channelName,
          'thumbnails': {
            'high': {'url': thumbnail}
          },
          'description': description,
          'publishedAt': publishedAt.toIso8601String(),
        },
      };
}

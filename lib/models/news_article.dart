class NewsArticle {
  final String title, description, url, source, publishedAt, content, author;
  final String? imageUrl;
  bool isBookmarked;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.publishedAt,
    required this.content,
    required this.author,
    this.imageUrl,
    this.isBookmarked = false,
  });

  String get timeAgo {
    try {
      final dt = DateTime.parse(publishedAt);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      return '${diff.inMinutes}m ago';
    } catch (e) {
      return '';
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsArticle> articles = [];
  bool isLoading = true;
  String selectedCategory = 'Tech';
  final List<String> categories = ['Tech', 'Jobs', 'AI/ML', 'Startups', 'Flutter', 'DSA'];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => isLoading = true);
    final results = await NewsService.fetchByCategory(selectedCategory);
    setState(() {
      articles = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech News 📰'),
        actions: [
          IconButton(
            onPressed: _loadNews,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return FilterChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  selectedColor: const Color(0xFF6B5CE7),
                  backgroundColor: const Color(0xFF2D2070),
                  onSelected: (_) {
                    setState(() => selectedCategory = category);
                    _loadNews();
                  },
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B5CE7)))
                : articles.isEmpty
                    ? const Center(child: Text('No articles found', style: TextStyle(color: Colors.white54)))
                    : RefreshIndicator(
                        onRefresh: _loadNews,
                        color: const Color(0xFF6B5CE7),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1550),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: CachedNetworkImage(
                                        imageUrl: article.imageUrl!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Container(
                                          height: 60,
                                          color: const Color(0xFF2D2070),
                                          child: const Center(child: Icon(Icons.article, color: Color(0xFF6B5CE7))),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF6B5CE7).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(article.source,
                                                  style: const TextStyle(color: Color(0xFF6B5CE7), fontSize: 11)),
                                            ),
                                            const Spacer(),
                                            Text(article.timeAgo,
                                                style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(article.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              height: 1.3,
                                            )),
                                        const SizedBox(height: 6),
                                        if (article.description.isNotEmpty)
                                          Text(article.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.3)),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                icon: const Icon(Icons.open_in_new, size: 16, color: Color(0xFF6B5CE7)),
                                                label: const Text('Read More', style: TextStyle(color: Color(0xFF6B5CE7))),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(color: const Color(0xFF6B5CE7).withOpacity(0.4)),
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                onPressed: () async {
                                                  final uri = Uri.parse(article.url);
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: Icon(
                                                article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                color: const Color(0xFF6B5CE7),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  article.isBookmarked = !article.isBookmarked;
                                                // Bookmark persisted later if needed
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

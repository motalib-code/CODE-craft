import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/news_article.dart';

class NewsService {
  // ── FETCH TECH NEWS ──
  static Future<List<NewsArticle>> fetchTechNews({
    String query = 'technology software developer',
    int pageSize = 20,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.newsBaseUrl}/everything'
        '?q=${Uri.encodeComponent(query)}'
        '&language=en'
        '&sortBy=publishedAt'
        '&pageSize=$pageSize'
        '&apiKey=${ApiConfig.newsApiKey}'
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          return (data['articles'] as List)
              .where((a) =>
                a['title'] != null &&
                a['title'] != '[Removed]' &&
                a['url'] != null)
              .map((a) => NewsArticle(
                    title: a['title'] ?? '',
                    description: a['description'] ?? '',
                    url: a['url'] ?? '',
                    imageUrl: a['urlToImage'],
                    source: a['source']?['name'] ?? 'Unknown',
                    publishedAt: a['publishedAt'] ?? '',
                    content: a['content'] ?? '',
                    author: a['author'] ?? '',
                  ))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── FETCH JOB/CAREER NEWS ──
  static Future<List<NewsArticle>> fetchCareerNews() async {
    return fetchTechNews(
      query: 'software developer jobs hiring tech careers 2025',
    );
  }

  // ── FETCH AI NEWS ──
  static Future<List<NewsArticle>> fetchAINews() async {
    return fetchTechNews(
      query: 'artificial intelligence machine learning OpenAI Google',
    );
  }

  // ── FETCH STARTUP NEWS ──
  static Future<List<NewsArticle>> fetchStartupNews() async {
    return fetchTechNews(
      query: 'startup funding tech company hiring 2025',
    );
  }

  // ── FETCH CATEGORY NEWS ──
  static Future<List<NewsArticle>> fetchByCategory(String category) async {
    final queries = {
      'Tech': 'software technology developer programming',
      'Jobs': 'software jobs hiring developer careers',
      'AI/ML': 'artificial intelligence machine learning ChatGPT',
      'Startups': 'startup funding venture capital tech',
      'Flutter': 'Flutter Dart mobile development Google',
      'DSA': 'coding interview leetcode algorithms competitive programming',
    };
    return fetchTechNews(
      query: queries[category] ?? category,
    );
  }

  // ── TOP HEADLINES (India tech) ──
  static Future<List<NewsArticle>> fetchTopHeadlines() async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.newsBaseUrl}/top-headlines'
        '?category=technology'
        '&language=en'
        '&pageSize=10'
        '&apiKey=${ApiConfig.newsApiKey}'
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          return (data['articles'] as List)
              .where((a) => a['title'] != null && a['title'] != '[Removed]')
              .map((a) => NewsArticle(
                    title: a['title'] ?? '',
                    description: a['description'] ?? '',
                    url: a['url'] ?? '',
                    imageUrl: a['urlToImage'],
                    source: a['source']?['name'] ?? 'Unknown',
                    publishedAt: a['publishedAt'] ?? '',
                    content: a['content'] ?? '',
                    author: a['author'] ?? '',
                  ))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

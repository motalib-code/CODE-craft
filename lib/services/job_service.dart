import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/job.dart';

class JobService {
  // ── ADZUNA JOBS (500/month free) ──
  static Future<List<Job>> fetchAdzunaJobs({
    String query = 'software developer',
    String country = 'in',
    int page = 1,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.adzunaBaseUrl}/$country/search/$page'
        '?app_id=${ApiConfig.adzunaAppId}'
        '&app_key=${ApiConfig.adzunaAppKey}'
        '&results_per_page=20'
        '&what=${Uri.encodeComponent(query)}'
        '&content-type=application/json'
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List? ?? []).map((j) => Job(
          id: j['id']?.toString() ?? '',
          title: j['title'] ?? '',
          company: j['company']?['display_name'] ?? 'Unknown',
          location: j['location']?['display_name'] ?? 'India',
          salary: j['salary_min'] != null
            ? '₹${(j['salary_min'] as num).toStringAsFixed(0)}'
            : 'Not specified',
          tags: [j['category']?['label'] ?? 'Tech'],
          url: j['redirect_url'] ?? '',
          logo: '',
          postedAt: j['created'] ?? '',
          isRemote: (j['title'] ?? '').toLowerCase().contains('remote'),
          source: 'Adzuna',
          description: j['description'] ?? '',
        )).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── REMOTEOK JOBS (Unlimited free) ──
  static Future<List<Job>> fetchRemoteOKJobs({String? tag}) async {
    try {
      final url = tag != null && tag.isNotEmpty
        ? '${ApiConfig.remoteOkUrl}?tag=${Uri.encodeComponent(tag)}'
        : ApiConfig.remoteOkUrl;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 CareerApp/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(response.body);
        return raw
          .skip(1)
          .where((j) => j is Map && j['id'] != null)
          .take(25)
          .map((j) => Job(
            id: j['id']?.toString() ?? '',
            title: j['position'] ?? 'Unknown Position',
            company: j['company'] ?? 'Unknown Company',
            location: 'Remote',
            salary: j['salary']?.toString() ?? '',
            tags: (j['tags'] is List)
              ? List<String>.from(j['tags'])
              : [],
            url: j['url'] ?? '',
            logo: j['company_logo'] ?? '',
            postedAt: j['date']?.toString() ?? '',
            isRemote: true,
            source: 'RemoteOK',
            description: j['description'] ?? '',
          ))
          .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── ARBEITNOW JOBS (Unlimited free) ──
  static Future<List<Job>> fetchArbeitnowJobs({
    String? tags,
    String? location,
  }) async {
    try {
      final params = <String, String>{};
      if (tags != null && tags.isNotEmpty) params['tags'] = tags;
      if (location != null && location.isNotEmpty) params['location'] = location;

      final uri = Uri.parse(ApiConfig.arbeitnowUrl)
        .replace(queryParameters: params.isNotEmpty ? params : null);

      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ((data['data'] ?? []) as List).take(25).map((j) => Job(
          id: j['slug']?.toString() ?? '',
          title: j['title'] ?? '',
          company: j['company_name'] ?? '',
          location: j['location'] ?? 'Remote',
          salary: '',
          tags: (j['tags'] is List) ? List<String>.from(j['tags']) : [],
          url: j['url'] ?? '',
          logo: j['company_logo'] ?? '',
          postedAt: j['created_at']?.toString() ?? '',
          isRemote: j['remote'] == true,
          source: 'Arbeitnow',
          description: j['description'] ?? '',
        )).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── FETCH ALL COMBINED ──
  static Future<List<Job>> fetchAllJobs({
    String? query,
    String? location,
  }) async {
    try {
      final results = await Future.wait([
        fetchRemoteOKJobs(tag: query).catchError((_) => <Job>[]),
        fetchArbeitnowJobs(tags: query, location: location).catchError((_) => <Job>[]),
        if (ApiConfig.adzunaAppId.isNotEmpty &&
            ApiConfig.adzunaAppId != 'YOUR_ADZUNA_APP_ID')
          fetchAdzunaJobs(query: query ?? 'developer').catchError((_) => <Job>[]),
      ]);

      final all = results.expand((list) => list).toList();
      final seen = <String>{};
      final unique = all.where((j) {
        final key = '${j.title}-${j.company}'.toLowerCase();
        return seen.add(key);
      }).toList();

      unique.sort((a, b) => b.postedAt.compareTo(a.postedAt));
      return unique;
    } catch (e) {
      return [];
    }
  }
}

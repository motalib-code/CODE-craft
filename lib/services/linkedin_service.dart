import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/linkedin_profile.dart';

class LinkedinService {
  LinkedinService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<LinkedInProfile> fetchProfileByUrl(String profileUrl) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.linkedinApi}?url=${Uri.encodeQueryComponent(profileUrl)}'),
      headers: {
        'X-RapidAPI-Key': ApiConfig.rapidApiKey,
        'X-RapidAPI-Host': 'linkedin-api8.p.rapidapi.com',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('LinkedIn API error (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    // Normalize possible shape differences from third-party endpoints.
    final normalized = <String, dynamic>{
      'fullName': body['fullName'] ?? body['name'] ?? '',
      'headline': body['headline'] ?? '',
      'summary': body['summary'] ?? body['about'] ?? '',
      'profilePicture': body['profilePicture'] ?? body['profilePic'] ?? '',
      'experiences': body['experiences'] ?? <dynamic>[],
      'educations': body['educations'] ?? body['education'] ?? <dynamic>[],
      'skills': body['skills'] ?? <dynamic>[],
      'certifications': body['certifications'] ?? <dynamic>[],
      'recommendationsCount': body['recommendationsCount'] ?? 0,
      'connectionsCount': body['connectionsCount'] ?? 0,
    };

    return LinkedInProfile.fromJson(normalized);
  }
}

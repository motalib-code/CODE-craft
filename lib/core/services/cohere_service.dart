import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';

class CohereService {
  static const _key = ApiKeys.cohereApiKey;
  static const _base = 'https://api.cohere.ai/v1/embed';

  final _client = http.Client();

  /// Generates embeddings for a list of texts
  Future<List<List<double>>> getEmbeddings(List<String> texts) async {
    try {
      final response = await _client
          .post(
            Uri.parse(_base),
            headers: {
              'Authorization': 'Bearer $_key',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'texts': texts,
              'model': 'embed-english-v3.0',
              'input_type': 'search_document',
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Cohere error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final embeddings = (data['embeddings'] as List)
          .map((e) => (e as List).cast<double>())
          .toList();

      return embeddings;
    } catch (e) {
      throw Exception('Cohere service error: $e');
    }
  }

  /// Calculates cosine similarity between two vectors
  double cosineSimilarity(List<double> v1, List<double> v2) {
    if (v1.length != v2.length) return 0.0;
    
    double dotProduct = 0;
    double norm1 = 0;
    double norm2 = 0;
    
    for (int i = 0; i < v1.length; i++) {
      dotProduct += v1[i] * v2[i];
      norm1 += v1[i] * v1[i];
      norm2 += v2[i] * v2[i];
    }
    
    if (norm1 == 0 || norm2 == 0) return 0.0;
    return dotProduct / (math.sqrt(norm1) * math.sqrt(norm2));
  }

  void dispose() {
    _client.close();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../error/exception.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;
  final String apiKey;

  ApiClient({
    required this.client,
    required this.baseUrl,
    required this.apiKey,
  });

  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, String>? query,
      }) async {
    try {
      final finalQuery = {
        ...?query,
        'apiKey': apiKey,
      };

      final uri = Uri.parse('$baseUrl$endpoint')
          .replace(queryParameters: finalQuery);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw NetworkException('Failed to connect to network');
    }
  }

}

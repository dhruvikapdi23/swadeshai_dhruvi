import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swadesai_dhruvi/core/constants/api_constants.dart';

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Map<String, String> _headers({String? userId}) {
    return {
      'Content-Type': 'application/json',
      ApiConstants.userIdHeader: ?userId,
    };
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
    String? userId,
  }) {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
    return _client.get(uri, headers: _headers(userId: userId));
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    String? userId,
  }) {
    final uri = Uri.parse('$_baseUrl$path');
    return _client.post(
      uri,
      headers: _headers(userId: userId),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path, {String? userId}) {
    final uri = Uri.parse('$_baseUrl$path');
    return _client.delete(uri, headers: _headers(userId: userId));
  }
}

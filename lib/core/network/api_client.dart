import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swadesai_dhruvi/core/constants/api_constants.dart';
import 'package:swadesai_dhruvi/core/services/session_service.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
    String? baseUrl,
    SessionService? session,
    Duration? timeout,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl,
        _session = session,
        _timeout = timeout ?? const Duration(seconds: 30);

  final http.Client _client;
  final String _baseUrl;
  final SessionService? _session;
  final Duration _timeout;

  String get baseUrl => _baseUrl;

  Map<String, String> _headers({String? userId}) {
    final resolvedUserId = userId ?? _session?.userId;
    return {
      'Content-Type': 'application/json',
      ApiConstants.userIdHeader: ?resolvedUserId,
    };
  }

  Future<http.Response> _withTimeout(Future<http.Response> future) {
    return future.timeout(
      _timeout,
      onTimeout: () {
        throw TimeoutException(
          'Request timed out after ${_timeout.inSeconds}s. '
          'Server: $_baseUrl — is it running?',
        );
      },
    );
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
    String? userId,
  }) {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
    return _withTimeout(_client.get(uri, headers: _headers(userId: userId)));
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    String? userId,
  }) {
    final uri = Uri.parse('$_baseUrl$path');
    return _withTimeout(
      _client.post(
        uri,
        headers: _headers(userId: userId),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Future<http.Response> delete(String path, {String? userId}) {
    final uri = Uri.parse('$_baseUrl$path');
    return _withTimeout(_client.delete(uri, headers: _headers(userId: userId)));
  }
}

String mapApiError(Object error, String baseUrl) {
  if (error is TimeoutException) {
    return 'Connection timed out.\n'
        '1. Start server: cd server && npm run dev\n'
        '2. API URL: $baseUrl\n'
        '3. Physical device? Use your Mac IP:\n'
        '   flutter run --dart-define=API_BASE_URL=http://YOUR_MAC_IP:3000';
  }
  if (error is SocketException) {
    return 'Cannot reach server at $baseUrl.\n'
        'Android emulator: http://10.0.2.2:3000\n'
        'iOS simulator: http://localhost:3000\n'
        'Physical device: use your computer\'s LAN IP.';
  }
  return error.toString().replaceFirst('Exception: ', '');
}

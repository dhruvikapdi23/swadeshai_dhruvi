import 'dart:convert';
import 'dart:developer';

import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/network/api_endpoints.dart';
import 'package:swadesai_dhruvi/features/auth/data/model/user_model.dart';

class UsersRemoteDataSource {
  UsersRemoteDataSource(this._client);

  final ApiClient _client;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    final response = await _client.post(
      ApiEndpoints.authRegister,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'deviceToken': ?deviceToken,
      },
    );
    log("response :${response.body}");

    if (response.statusCode == 404) {
      throw Exception(
        'Auth API not found at ${_client.baseUrl}. '
        'Run with: flutter run --dart-define=API_BASE_URL=https://YOUR-RENDER-URL',
      );
    }
    if (response.statusCode == 409) {
      throw Exception('A user with this email already exists');
    }
    if (response.statusCode != 201) {
      final body = _decodeBody(response.body);
      throw Exception(body?['error'] ?? body?['message'] ?? 'Registration failed');
    }
    return UserModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<UserModel> login({
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    final response = await _client.post(
      ApiEndpoints.authLogin,
      body: {
        'email': email,
        'password': password,
        'deviceToken': ?deviceToken,
      },
    );
    log("response :${response.body}");
    if (response.statusCode == 404) {
      throw Exception(
        'Auth API not found at ${_client.baseUrl}. '
        'Run with: flutter run --dart-define=API_BASE_URL=https://YOUR-RENDER-URL',
      );
    }
    if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    }
    if (response.statusCode != 200) {
      final body = _decodeBody(response.body);
      throw Exception(body?['error'] ?? body?['message'] ?? 'Login failed');
    }
    return UserModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Map<String, dynamic>? _decodeBody(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }
}

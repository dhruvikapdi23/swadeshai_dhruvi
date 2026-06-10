import 'dart:io';

abstract final class ApiConstants {
  /// Override at build time: `--dart-define=API_BASE_URL=http://10.0.2.2:3000`
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    // Android emulator maps host localhost to 10.0.2.2
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  static const String userIdHeader = 'X-User-Id';
}

import 'dart:io';

abstract final class ApiConstants {
  /// Override at build time, e.g. for a physical device on the same Wi‑Fi:
  /// `--dart-define=API_BASE_URL=http://192.168.1.8:3000`
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    // Android emulator: 10.0.2.2 is the host machine's localhost
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  static const String userIdHeader = 'X-User-Id';
}

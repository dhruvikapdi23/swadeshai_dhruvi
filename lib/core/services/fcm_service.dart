import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class FcmService {
  String? _token;
  static const _tokenTimeout = Duration(seconds: 5);

  String? get token => _token;

  Future<void> init() async {
    await _requestNotificationPermission();
    // Fetch token in background — don't block app startup.
    unawaited(_loadToken());
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _token = newToken;
    });
  }

  Future<void> _requestNotificationPermission() async {
    try {
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Permission denied or unavailable — registration still works without token.
    }
  }

  Future<void> _loadToken() async {
    try {
      _token = await FirebaseMessaging.instance
          .getToken()
          .timeout(_tokenTimeout, onTimeout: () => null);
    } catch (_) {
      _token = null;
    }
  }

  /// Returns cached token or tries once with a short timeout.
  /// Never blocks register/login for more than 5 seconds.
  Future<String?> getDeviceToken() async {
    if (_token != null) return _token;
    try {
      await _loadToken().timeout(_tokenTimeout);
    } catch (_) {
      _token = null;
    }
    return _token;
  }
}

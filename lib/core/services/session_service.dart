import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  String? userId;

  Future<void> saveUser({
    required String id,
    required String name,
    required String email,
  }) async {
    userId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
  }

  Future<Map<String, String>?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_userIdKey);
    final name = prefs.getString(_userNameKey);
    final email = prefs.getString(_userEmailKey);

    if (id == null || name == null || email == null) return null;

    userId = id;
    return {'id': id, 'name': name, 'email': email};
  }

  Future<void> clear() async {
    userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }
}

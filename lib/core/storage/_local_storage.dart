import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static late SharedPreferences _prefs;

  static const String _userKey = 'user';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static void init(SharedPreferences prefs) {
    _prefs = prefs;
  }

  // User profile
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _prefs.setString(_userKey, jsonEncode(userData));
  }

  static Map<String, dynamic>? fetchUser() {
    final userData = _prefs.getString(_userKey);
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  static Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // Tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  static String? fetchAccessToken() => _prefs.getString(_accessTokenKey);

  static String? fetchRefreshToken() => _prefs.getString(_refreshTokenKey);

  static Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  // Clear everything
  static Future<void> clearAll() async {
    await clearUser();
    await clearTokens();
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static late SharedPreferences _prefs;

  static const String _userKey = 'user';

  static void init(SharedPreferences prefs) {
    _prefs = prefs;
  }

  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _prefs.setString(_userKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> fetchUser() async {
    final userData = _prefs.getString(_userKey);
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  static Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // singleton pattern
  LocalStorage._privateConstructor();
  static final LocalStorage instance = LocalStorage._privateConstructor();

  // Key for storing user data in local storage
  static const String _userKey = 'user';

  // Save user data to local storage
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    // Get an instance of SharedPreferences and save the user data as a JSON string
    final preferences = await SharedPreferences.getInstance();
    // Convert the user data map to a JSON string and save it under the specified key
    await preferences.setString(_userKey, jsonEncode(userData));
  }

  // Fetch user data from local storage
  static Future<Map<String, dynamic>?> fetchUser()async{
    final preferences = await SharedPreferences.getInstance();
    final userData = preferences.getString(_userKey);

    if(userData == null) return  null;

    return jsonDecode(userData);
  }

  // clear user data from local storage
  static Future<void> clearUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userKey);
  }
}

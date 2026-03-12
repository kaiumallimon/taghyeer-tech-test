import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taghyeer_test/_app.dart';
import 'package:taghyeer_test/core/storage/_local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  LocalStorage.init(prefs);
  runApp(const MyApp());
}

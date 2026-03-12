import 'package:flutter/material.dart';
import 'package:taghyeer_test/core/constants/_app_theme.dart';
import 'package:taghyeer_test/features/auth/pages/_login_page.dart';
import 'package:taghyeer_test/features/splash/pages/_splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
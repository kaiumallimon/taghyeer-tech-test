import 'package:flutter/material.dart';
import 'package:taghyeer_test/features/splash/pages/_splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage()
    );
  }
}
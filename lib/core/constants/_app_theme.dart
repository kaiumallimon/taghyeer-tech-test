import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  // Colors
  static const _primary = CupertinoColors.activeBlue;
  static const _secondary = CupertinoColors.activeOrange;

  // Light background colors
  static const _bgLight = Color.fromARGB(255, 255, 255, 255);
  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _surfaceContainerLight = Color(0xFFEFEFF4);

  // Dark background colors
  static const _bgDark = Color(0xFF1C1C1E);
  static const _surfaceDark = Color(0xFF1C1C1E);
  static const _surfaceContainerDark = Color(0xFF2C2C2E);

  // Font
  static const _fontFamily = 'BricolageGrotesque';

  static TextTheme _buildTextTheme(Color onSurface) => TextTheme(
        displayLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: onSurface),
        displayMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: onSurface),
        displaySmall: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onSurface),
        headlineLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: onSurface),
        headlineMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: onSurface),
        headlineSmall: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurface),
        titleLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: onSurface),
        titleMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: onSurface),
        titleSmall: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: onSurface),
        bodyLarge: TextStyle(
            fontFamily: _fontFamily, fontSize: 17, color: onSurface),
        bodyMedium: TextStyle(
            fontFamily: _fontFamily, fontSize: 15, color: onSurface),
        bodySmall: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 13,
            color: onSurface.withAlpha(180)),
        labelLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: onSurface),
        labelMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: onSurface),
        labelSmall: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: onSurface.withAlpha(160)),
      );

  // Component themes
  static InputDecorationTheme _inputTheme(ColorScheme cs) =>
      InputDecorationTheme(
        filled: false,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: cs.onSurface.withAlpha(40), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        hintStyle:
            TextStyle(color: cs.onSurface.withAlpha(100), fontSize: 14),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.primary.withAlpha(120),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme cs) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static DividerThemeData _dividerTheme(ColorScheme cs) => DividerThemeData(
        color: cs.onSurface.withAlpha(40),
        thickness: 1,
        space: 1,
      );

  static AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      );

  // Light theme
  static ThemeData get light {
    const cs = ColorScheme.light(
      primary: _primary,
      onPrimary: CupertinoColors.white,
      secondary: _secondary,
      onSecondary: CupertinoColors.white,
      surface: _surfaceLight,
      onSurface: CupertinoColors.black,
      surfaceContainerHighest: _surfaceContainerLight,
      error: CupertinoColors.systemRed,
      onError: CupertinoColors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      scaffoldBackgroundColor: _bgLight,
      fontFamily: _fontFamily,
      textTheme: _buildTextTheme(CupertinoColors.black),
      inputDecorationTheme: _inputTheme(cs),
      elevatedButtonTheme: _elevatedButtonTheme(cs),
      textButtonTheme: _textButtonTheme(cs),
      dividerTheme: _dividerTheme(cs),
      appBarTheme: _appBarTheme(cs),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }

  // Dark theme
  static ThemeData get dark {
    const cs = ColorScheme.dark(
      primary: _primary,
      onPrimary: CupertinoColors.white,
      secondary: _secondary,
      onSecondary: CupertinoColors.white,
      surface: _surfaceDark,
      onSurface: CupertinoColors.white,
      surfaceContainerHighest: _surfaceContainerDark,
      error: CupertinoColors.systemRed,
      onError: CupertinoColors.white,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: _bgDark,
      fontFamily: _fontFamily,
      textTheme: _buildTextTheme(CupertinoColors.white),
      inputDecorationTheme: _inputTheme(cs),
      elevatedButtonTheme: _elevatedButtonTheme(cs),
      textButtonTheme: _textButtonTheme(cs),
      dividerTheme: _dividerTheme(cs),
      appBarTheme: _appBarTheme(cs),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}

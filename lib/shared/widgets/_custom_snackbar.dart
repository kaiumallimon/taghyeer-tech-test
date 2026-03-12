import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  CustomSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);

    final config = _SnackbarConfig.fromType(type, theme);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: config.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    config.icon,
                    color: config.iconColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: config.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: config.textColor.withAlpha(
                              title != null ? 200 : 255),
                          fontWeight: title != null
                              ? FontWeight.w400
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class _SnackbarConfig {
  const _SnackbarConfig({
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  factory _SnackbarConfig.fromType(SnackbarType type, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          backgroundColor:
              isDark ? const Color(0xFF1C2E1C) : const Color(0xFFEDF7ED),
          iconBackgroundColor: const Color(0xFF34C759).withAlpha(40),
          icon: Icons.check_rounded,
          iconColor: const Color(0xFF34C759),
          textColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        );
      case SnackbarType.error:
        return _SnackbarConfig(
          backgroundColor:
              isDark ? const Color(0xFF2E1C1C) : const Color(0xFFFDEDED),
          iconBackgroundColor: const Color(0xFFFF3B30).withAlpha(40),
          icon: Icons.error_outline_rounded,
          iconColor: const Color(0xFFFF3B30),
          textColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        );
      case SnackbarType.warning:
        return _SnackbarConfig(
          backgroundColor:
              isDark ? const Color(0xFF2E2618) : const Color(0xFFFFF8ED),
          iconBackgroundColor: const Color(0xFFFF9500).withAlpha(40),
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFFF9500),
          textColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        );
      case SnackbarType.info:
        return _SnackbarConfig(
          backgroundColor:
              isDark ? const Color(0xFF1A1E2E) : const Color(0xFFEDF3FD),
          iconBackgroundColor: const Color(0xFF007AFF).withAlpha(40),
          icon: Icons.info_outline_rounded,
          iconColor: const Color(0xFF007AFF),
          textColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        );
    }
  }
}

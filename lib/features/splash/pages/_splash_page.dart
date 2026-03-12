import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // logo
            _logoText(theme),
            // loading indicator
            _loadingIndicator(theme.colorScheme),
          ],
        ),
      ),
    );
  }

  // Widget for the logo text
  Center _logoText(ThemeData theme) {
    return Center(
            child: Text(
              AppConstants.splashText,
              style: theme.textTheme.headlineMedium,
            ),
          );
  }

  // Widget for the loading indicator
  Positioned _loadingIndicator(ColorScheme colorScheme) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: CupertinoActivityIndicator(color: colorScheme.primary),
    );
  }
}

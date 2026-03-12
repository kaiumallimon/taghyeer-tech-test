import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/posts/pages/_post_page.dart';
import 'package:taghyeer_test/features/dashboard/products/pages/_product_page.dart';
import 'package:taghyeer_test/features/dashboard/settings/pages/_settings_page.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  // current page state and list of pages
  int _currentIndex = 0;

  final List<Widget> _pages = [ProductPage(), PostPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: theme.colorScheme.surface,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  // bottom navigation bar to switch between pages
  NavigationBar _buildBottomNavBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(LucideIcons.package),
          label: 'Products',
        ),
        NavigationDestination(icon: Icon(LucideIcons.fileText), label: 'Posts'),
        NavigationDestination(
          icon: Icon(LucideIcons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

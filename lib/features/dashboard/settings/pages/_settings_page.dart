import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';
import 'package:taghyeer_test/features/auth/pages/_login_page.dart';
import 'package:taghyeer_test/features/dashboard/settings/widgets/_appearance_section.dart';
import 'package:taghyeer_test/features/dashboard/settings/widgets/_logout_tile.dart';
import 'package:taghyeer_test/features/dashboard/settings/widgets/_section_label.dart';
import 'package:taghyeer_test/features/dashboard/settings/widgets/_user_info_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 80,
          title: Text('Settings', style: theme.textTheme.headlineLarge),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // ── User info ────────────────────────────────────────────────
            SettingsUserInfoCard(),

            SizedBox(height: 24),

            // ── Appearance ───────────────────────────────────────────────
            SettingsSectionLabel(label: 'Appearance'),
            SizedBox(height: 10),
            SettingsAppearanceSection(),

            SizedBox(height: 32),

            // ── Account ──────────────────────────────────────────────────
            SettingsSectionLabel(label: 'Account'),
            SizedBox(height: 10),
            SettingsLogoutTile(),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

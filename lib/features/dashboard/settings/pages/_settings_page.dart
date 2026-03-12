import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';
import 'package:taghyeer_test/features/auth/pages/_login_page.dart';
import 'package:taghyeer_test/shared/bloc/_theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // ── User info ────────────────────────────────────────────────
            _UserInfoCard(),

            const SizedBox(height: 24),

            // ── Appearance ───────────────────────────────────────────────
            _SectionLabel(label: 'Appearance'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border.all(color: cs.outlineVariant.withAlpha(30)),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.sun, size: 18, color: cs.primary),
                      const SizedBox(width: 10),
                      Text('Theme', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 14),
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, mode) => SegmentedButton<ThemeMode>(
                      style: SegmentedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(color: cs.outlineVariant.withAlpha(30)),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(LucideIcons.monitorSmartphone, size: 15),
                          label: Text('System'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(LucideIcons.sun, size: 15),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(LucideIcons.moon, size: 15),
                          label: Text('Dark'),
                        ),
                      ],
                      selected: {mode},
                      onSelectionChanged: (val) =>
                          context.read<ThemeCubit>().setTheme(val.first),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Logout ───────────────────────────────────────────────────
            _SectionLabel(label: 'Account'),
            const SizedBox(height: 10),
            _LogoutTile(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── User info card ───────────────────────────────────────────────────────────

class _UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final userData = context.select<AuthCubit, Map<String, dynamic>>(
      (cubit) => cubit.state is AuthLoggedIn
          ? (cubit.state as AuthLoggedIn).userData
          : {},
    );

    final name = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
        .trim();
    final username = userData['username'] as String? ?? '';
    final email = userData['email'] as String? ?? '';
    final imageUrl = userData['image'] as String?;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: cs.outlineVariant.withAlpha(30)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile image
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primaryContainer,
              border: Border.all(color: cs.primary.withAlpha(60), width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      LucideIcons.user,
                      size: 40,
                      color: cs.onPrimaryContainer,
                    ),
                  )
                : Icon(
                    LucideIcons.user,
                    size: 40,
                    color: cs.onPrimaryContainer,
                  ),
          ),
          const SizedBox(height: 14),
          if (name.isNotEmpty)
            Text(
              name,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          if (username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@$username',
              style: tt.bodyMedium?.copyWith(color: cs.primary),
              textAlign: TextAlign.center,
            ),
          ],
          if (email.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.mail,
                    size: 13,
                    color: cs.onSurface.withAlpha(140),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    email,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurface.withAlpha(160),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Logout tile ───────────────────────────────────────────────────────────────

class _LogoutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(width: 1, color: cs.outline.withAlpha(30)),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.errorContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(LucideIcons.logOut, size: 18, color: cs.onError),
        ),
        title: Text('Log Out', style: tt.titleSmall?.copyWith(color: cs.error)),
        trailing: Icon(
          LucideIcons.chevronRight,
          size: 18,
          color: cs.onSurface.withAlpha(100),
        ),
        onTap: () => _confirmLogout(context),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Out', style: tt.titleLarge),
        content: Text(
          'Are you sure you want to log out?',
          style: tt.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: tt.labelSmall?.copyWith(
          color: cs.onSurface.withAlpha(130),
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

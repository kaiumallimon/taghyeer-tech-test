import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';

class SettingsUserInfoCard extends StatelessWidget {
  const SettingsUserInfoCard({super.key});

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

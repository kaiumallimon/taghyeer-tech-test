import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/shared/bloc/_theme_cubit.dart';

class SettingsAppearanceSection extends StatelessWidget {
  const SettingsAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
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
    );
  }
}

import 'package:flutter/material.dart';

class PostStatItem extends StatelessWidget {
  const PostStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(value,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
          ),
        ),
      ],
    );
  }
}

class PostStatDivider extends StatelessWidget {
  const PostStatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

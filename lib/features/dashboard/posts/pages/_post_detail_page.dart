import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/posts/models/_post_model.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tags ────────────────────────────────────────────────────────
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: post.tags
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#$t',
                          style: tt.labelSmall
                              ?.copyWith(color: cs.onPrimaryContainer),
                        ),
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 16),

            // ── Title ────────────────────────────────────────────────────────
            Text(post.title, style: tt.headlineSmall),

            const SizedBox(height: 16),

            // ── Stats row ───────────────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: LucideIcons.eye,
                    label: 'Views',
                    value: '${post.views}',
                    color: cs.primary,
                  ),
                  _Divider(),
                  _StatItem(
                    icon: LucideIcons.thumbsUp,
                    label: 'Likes',
                    value: '${post.reactions.likes}',
                    color: Colors.green.shade600,
                  ),
                  _Divider(),
                  _StatItem(
                    icon: LucideIcons.thumbsDown,
                    label: 'Dislikes',
                    value: '${post.reactions.dislikes}',
                    color: cs.error,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // ── Body ────────────────────────────────────────────────────────
            Text('Content', style: tt.titleLarge),
            const SizedBox(height: 10),
            Text(post.body, style: tt.bodyMedium?.copyWith(height: 1.7)),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // ── Author ──────────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(LucideIcons.user,
                        size: 20, color: cs.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author', style: tt.labelSmall),
                    Text('User #${post.userId}', style: tt.titleSmall),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
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
        Text(label,
            style: tt.labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(140))),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

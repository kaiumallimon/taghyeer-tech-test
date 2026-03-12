import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/posts/models/_post_model.dart';
import 'package:taghyeer_test/features/dashboard/posts/pages/_post_detail_page.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
      ),
      child: Container(
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
            Text(
              post.title,
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              post.body,
              style: tt.bodySmall?.copyWith(color: cs.onSurface.withAlpha(160)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: post.tags
                    .take(3)
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
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
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(LucideIcons.eye,
                    size: 14, color: cs.onSurface.withAlpha(140)),
                const SizedBox(width: 4),
                Text('${post.views}',
                    style: tt.labelSmall
                        ?.copyWith(color: cs.onSurface.withAlpha(140))),
                const SizedBox(width: 12),
                Icon(LucideIcons.thumbsUp,
                    size: 14, color: cs.onSurface.withAlpha(140)),
                const SizedBox(width: 4),
                Text('${post.reactions.likes}',
                    style: tt.labelSmall
                        ?.copyWith(color: cs.onSurface.withAlpha(140))),
                const SizedBox(width: 12),
                Icon(LucideIcons.thumbsDown,
                    size: 14, color: cs.onSurface.withAlpha(140)),
                const SizedBox(width: 4),
                Text('${post.reactions.dislikes}',
                    style: tt.labelSmall
                        ?.copyWith(color: cs.onSurface.withAlpha(140))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

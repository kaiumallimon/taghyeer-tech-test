import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taghyeer_test/features/dashboard/posts/bloc/_post_cubit.dart';
import 'package:taghyeer_test/features/dashboard/posts/models/_post_model.dart';
import 'package:taghyeer_test/features/dashboard/posts/pages/_post_detail_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final PagingController<int, Post> _pagingController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PostCubit>();

    _pagingController = PagingController<int, Post>(
      getNextPageKey: (state) {
        if (state.pages == null) return 0;
        if (state.lastPageIsEmpty ||
            state.pages!.last.length < PostCubit.pageSize) return null;
        return state.keys!.last + state.pages!.last.length;
      },
      fetchPage: cubit.fetchPage,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 80,
        title: Text('Posts', style: theme.textTheme.headlineLarge),
      ),
      body: PagingListener<int, Post>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          if (state.pages == null && state.isLoading) {
            return _buildShimmerList(context);
          }
          if (state.pages == null && state.error != null) {
            return _buildFirstPageError(context);
          }

          return RefreshIndicator(
            onRefresh: () async => _pagingController.refresh(),
            child: PagedListView<int, Post>(
              state: state,
              fetchNextPage: () => WidgetsBinding.instance
                  .addPostFrameCallback((_) => fetchNextPage()),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: (context, post, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PostCard(post: post),
                ),

                newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),

                newPageErrorIndicatorBuilder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: _pagingController.fetchNextPage,
                      icon: const Icon(LucideIcons.refreshCw, size: 16),
                      label: const Text('Retry'),
                    ),
                  ),
                ),

                noItemsFoundIndicatorBuilder: (_) => const Center(
                  child: Text('No posts found.'),
                ),

                noMoreItemsIndicatorBuilder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "You've seen all posts",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0E0E0);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstPageError(BuildContext context) {
    final isNoInternet =
        _pagingController.value.error is PostNoInternetException;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNoInternet ? LucideIcons.wifiOff : LucideIcons.xCircle,
              size: 56,
              color: isNoInternet
                  ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              isNoInternet
                  ? 'No Internet Connection'
                  : 'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isNoInternet
                  ? 'Please check your connection and try again.'
                  : 'An unexpected error occurred. Please try again.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _pagingController.refresh,
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

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
              style:
                  tt.bodySmall?.copyWith(color: cs.onSurface.withAlpha(160)),
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

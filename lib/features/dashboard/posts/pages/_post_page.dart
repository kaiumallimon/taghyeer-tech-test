import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/posts/bloc/_post_cubit.dart';
import 'package:taghyeer_test/features/dashboard/posts/models/_post_model.dart';
import 'package:taghyeer_test/features/dashboard/posts/widgets/_post_card.dart';
import 'package:taghyeer_test/features/dashboard/posts/widgets/_posts_error_view.dart';
import 'package:taghyeer_test/features/dashboard/posts/widgets/_posts_shimmer_list.dart';

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
            return const PostsShimmerList();
          }
          if (state.pages == null && state.error != null) {
            return PostsErrorView(
              error: state.error,
              onRetry: _pagingController.refresh,
            );
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
                  child: PostCard(post: post),
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
}

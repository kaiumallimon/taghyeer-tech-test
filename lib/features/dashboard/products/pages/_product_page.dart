import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taghyeer_test/features/dashboard/products/bloc/_product_cubit.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_product_card.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final PagingController<int, Product> _pagingController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductCubit>();

    _pagingController = PagingController<int, Product>(
      getNextPageKey: (state) {
        if (state.pages == null) return 0;
        if (state.lastPageIsEmpty ||
            state.pages!.last.length < ProductCubit.pageSize)
          return null;
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
        title: Text('Products', style: theme.textTheme.headlineLarge),
      ),
      body: PagingListener<int, Product>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          if (state.pages == null && state.isLoading) {
            return _buildShimmerGrid(context);
          }
          if (state.pages == null && state.error != null) {
            return _buildFirstPageError(context);
          }

          return RefreshIndicator(
            onRefresh: () async => _pagingController.refresh(),
            child: PagedGridView<int, Product>(
              state: state,
              // avoid notifyListeners() during build.
              fetchNextPage: () => WidgetsBinding.instance.addPostFrameCallback(
                (_) => fetchNextPage(),
              ),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              builderDelegate: PagedChildBuilderDelegate<Product>(
                itemBuilder: (context, product, index) =>
                    ProductCard(product: product),

                newPageProgressIndicatorBuilder: (_) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
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

                noItemsFoundIndicatorBuilder: (_) =>
                    const Center(child: Text('No products found.')),

                noMoreItemsIndicatorBuilder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "You've seen all products",
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

  Widget _buildShimmerGrid(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0E0E0);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
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
        _pagingController.value.error is ProductNoInternetException;

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
              isNoInternet ? 'No Internet Connection' : 'Something went wrong',
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

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/products/bloc/_product_cubit.dart';

class ProductErrorView extends StatelessWidget {
  const ProductErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isNoInternet = error is ProductNoInternetException;

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
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProductStockBadge extends StatelessWidget {
  const ProductStockBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final inStock = status.toLowerCase().contains('in stock');
    final color = inStock ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        status,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color.shade700),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';

class ProductDetailsGrid extends StatelessWidget {
  const ProductDetailsGrid({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('SKU', product.sku, LucideIcons.barChart),
      ('Weight', '${product.weight} g', LucideIcons.scale),
      ('Stock', '${product.stock} units', LucideIcons.boxes),
      (
        'Dimensions',
        '${product.dimensions.width.toStringAsFixed(1)} × '
            '${product.dimensions.height.toStringAsFixed(1)} × '
            '${product.dimensions.depth.toStringAsFixed(1)} cm',
        LucideIcons.ruler
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final (label, value, icon) = items[index];
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: tt.labelSmall),
                    Text(
                      value,
                      style: tt.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

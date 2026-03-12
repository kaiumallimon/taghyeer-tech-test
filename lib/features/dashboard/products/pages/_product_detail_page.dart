import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_details_grid.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_image_carousel.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_info_tile.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_product_chip.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_review_card.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_star_rating.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_stock_badge.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image carousel
          SliverToBoxAdapter(child: ProductImageCarousel(images: images)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & brand chips
                  Wrap(
                    spacing: 8,
                    children: [
                      ProductChip(
                        label: product.category,
                        icon: LucideIcons.tag,
                      ),
                      if (product.brand != null)
                        ProductChip(
                          label: product.brand!,
                          icon: LucideIcons.building2,
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(product.title, style: tt.displaySmall),

                  const SizedBox(height: 10),

                  // Rating & Stock
                  Row(
                    children: [
                      ProductStarRating(rating: product.rating),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating.toStringAsFixed(1)} · ${product.reviews.length} reviews',
                        style: tt.bodySmall,
                      ),
                      const Spacer(),
                      ProductStockBadge(status: product.availabilityStatus),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: tt.headlineLarge?.copyWith(
                          color: cs.primary,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (product.discountPercentage > 0) ...[
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: tt.titleMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: cs.onSurface.withAlpha(120),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(1)}%',
                            style: tt.labelSmall?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  Text('Description', style: tt.titleLarge),
                  const SizedBox(height: 8),
                  Text(product.description, style: tt.bodyMedium),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Details grid ─
                  Text('Details', style: tt.titleLarge),
                  const SizedBox(height: 12),
                  ProductDetailsGrid(product: product),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Tags
                  Text('Tags', style: tt.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.tags
                        .map(
                          (t) => ProductChip(label: t, icon: LucideIcons.hash),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Shipping info
                  Text('Policies', style: tt.titleLarge),
                  const SizedBox(height: 12),
                  ProductInfoTile(
                    icon: LucideIcons.truck,
                    label: 'Shipping',
                    value: product.shippingInformation,
                  ),
                  const SizedBox(height: 8),
                  ProductInfoTile(
                    icon: LucideIcons.shieldCheck,
                    label: 'Warranty',
                    value: product.warrantyInformation,
                  ),
                  const SizedBox(height: 8),
                  ProductInfoTile(
                    icon: LucideIcons.rotateCcw,
                    label: 'Returns',
                    value: product.returnPolicy,
                  ),
                  const SizedBox(height: 8),
                  ProductInfoTile(
                    icon: LucideIcons.packageCheck,
                    label: 'Min. Order',
                    value: '${product.minimumOrderQuantity} units',
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Reviews
                  Text('Reviews', style: tt.titleLarge),
                  const SizedBox(height: 12),
                  ...product.reviews.map((r) => ProductReviewCard(review: r)),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

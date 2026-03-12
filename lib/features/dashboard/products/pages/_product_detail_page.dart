import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);
    final images = product.images.isNotEmpty ? product.images : [product.thumbnail];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Image carousel ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImageIndex = i),
                    itemBuilder: (context, index) => Image.network(
                      images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: cs.surfaceContainerHighest,
                        child: Icon(LucideIcons.image,
                            size: 56, color: cs.onSurface.withAlpha(80)),
                      ),
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 12,
                  child: Material(
                    color: cs.surface.withAlpha(220),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(LucideIcons.arrowLeft, size: 22),
                      ),
                    ),
                  ),
                ),
                // Dot indicators
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentImageIndex == i ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentImageIndex == i
                                ? cs.primary
                                : cs.surface.withAlpha(200),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category & brand chips ─────────────────────────────
                  Wrap(
                    spacing: 8,
                    children: [
                      _Chip(label: product.category, icon: LucideIcons.tag),
                      if (product.brand != null)
                        _Chip(
                            label: product.brand!,
                            icon: LucideIcons.building2),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Title ──────────────────────────────────────────────
                  Text(product.title, style: tt.displaySmall),

                  const SizedBox(height: 10),

                  // ── Rating & Stock ─────────────────────────────────────
                  Row(
                    children: [
                      _StarRating(rating: product.rating),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating.toStringAsFixed(1)} · ${product.reviews.length} reviews',
                        style: tt.bodySmall,
                      ),
                      const Spacer(),
                      _StockBadge(status: product.availabilityStatus),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Price ──────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: tt.headlineLarge
                            ?.copyWith(color: cs.primary, fontSize: 28),
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
                              horizontal: 8, vertical: 3),
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

                  // ── Description ────────────────────────────────────────
                  Text('Description', style: tt.titleLarge),
                  const SizedBox(height: 8),
                  Text(product.description, style: tt.bodyMedium),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Details grid ───────────────────────────────────────
                  Text('Details', style: tt.titleLarge),
                  const SizedBox(height: 12),
                  _DetailsGrid(product: product),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Tags ───────────────────────────────────────────────
                  Text('Tags', style: tt.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.tags
                        .map((t) => _Chip(label: t, icon: LucideIcons.hash))
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Shipping info ──────────────────────────────────────
                  Text('Policies', style: tt.titleLarge),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: LucideIcons.truck,
                    label: 'Shipping',
                    value: product.shippingInformation,
                  ),
                  const SizedBox(height: 8),
                  _InfoTile(
                    icon: LucideIcons.shieldCheck,
                    label: 'Warranty',
                    value: product.warrantyInformation,
                  ),
                  const SizedBox(height: 8),
                  _InfoTile(
                    icon: LucideIcons.rotateCcw,
                    label: 'Returns',
                    value: product.returnPolicy,
                  ),
                  const SizedBox(height: 8),
                  _InfoTile(
                    icon: LucideIcons.packageCheck,
                    label: 'Min. Order',
                    value: '${product.minimumOrderQuantity} units',
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Reviews ────────────────────────────────────────────
                  Text('Reviews', style: tt.titleLarge),
                  const SizedBox(height: 12),
                  ...product.reviews
                      .map((r) => _ReviewCard(review: r))
                      .toList(),

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

// ── Star Rating ───────────────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(LucideIcons.star,
              size: 14, color: Colors.amber.shade600);
        } else if (i < rating) {
          return Icon(LucideIcons.star,
              size: 14, color: Colors.amber.shade300);
        }
        return Icon(LucideIcons.star,
            size: 14, color: Colors.grey.withAlpha(100));
      }),
    );
  }
}

// ── Stock Badge ───────────────────────────────────────────────────────────────

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.status});
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

// ── Details Grid ──────────────────────────────────────────────────────────────

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.product});
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

// ── Info Tile ────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: cs.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: tt.labelSmall),
              Text(value, style: tt.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Review Card ───────────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: cs.primary.withAlpha(30),
                child: Text(
                  review.reviewerName[0].toUpperCase(),
                  style: tt.labelMedium?.copyWith(color: cs.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName, style: tt.labelMedium),
                    Text(
                      '${review.date.day}/${review.date.month}/${review.date.year}',
                      style: tt.labelSmall,
                    ),
                  ],
                ),
              ),
              _StarRating(rating: review.rating.toDouble()),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment, style: tt.bodyMedium),
        ],
      ),
    );
  }
}

// ── Chip ─────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.onSurface.withAlpha(160)),
          const SizedBox(width: 5),
          Text(label, style: tt.labelSmall),
        ],
      ),
    );
  }
}

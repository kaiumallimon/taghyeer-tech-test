import 'package:flutter/material.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';
import 'package:taghyeer_test/features/dashboard/products/widgets/_star_rating.dart';

class ProductReviewCard extends StatelessWidget {
  const ProductReviewCard({super.key, required this.review});
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
              ProductStarRating(rating: review.rating.toDouble()),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment, style: tt.bodyMedium),
        ],
      ),
    );
  }
}

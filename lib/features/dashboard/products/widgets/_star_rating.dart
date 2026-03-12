import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProductStarRating extends StatelessWidget {
  const ProductStarRating({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(LucideIcons.star, size: 14, color: Colors.amber.shade600);
        } else if (i < rating) {
          return Icon(LucideIcons.star, size: 14, color: Colors.amber.shade300);
        }
        return Icon(LucideIcons.star, size: 14, color: Colors.grey.withAlpha(100));
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:green_cart/models/product.dart';
import 'package:green_cart/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // adapt columns to screen width
    int crossAxisCount = 2;
    double aspectRatio = 0.58;

    if (screenWidth > 900) {
      crossAxisCount = 4;
      aspectRatio = 0.60;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
      aspectRatio = 0.60;
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/product-detail',
                  arguments: product.id,
                );
              },
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
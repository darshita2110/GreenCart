import 'package:flutter/material.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: AppColors.mediumGrey,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                  if (product.isOrganic)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Organic',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Color(0xFFFCD34D),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (product.stock > 0)
                    Text(
                      'In Stock',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.successGreen,
                      ),
                    )
                  else
                    Text(
                      'Out of Stock',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.errorRed,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
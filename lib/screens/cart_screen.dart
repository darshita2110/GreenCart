import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/models/cart_item.dart';
import 'package:green_cart/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        title: Text('My Cart', style: AppTextStyles.headingSmall),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
              onPressed: () => _showClearCartDialog(context, ref),
            ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartList(context, ref, cartItems),
      bottomNavigationBar: cartItems.isNotEmpty
          ? _buildBottomBar(context, ref, cartTotal, cartItems.length)
          : null,
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Browse our fresh produce and add items',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Start Shopping', style: AppTextStyles.buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(
      BuildContext context, WidgetRef ref, List<CartItem> cartItems) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cartItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return _buildCartItemCard(context, ref, item);
      },
    );
  }

  Widget _buildCartItemCard(
      BuildContext context, WidgetRef ref, CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 72,
              height: 72,
              color: AppColors.lightGrey,
              child: item.product.imageUrl.isNotEmpty
                  ? Image.network(
                      item.product.imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.eco,
                        color: AppColors.primaryGreen,
                        size: 32,
                      ),
                    )
                  : const Icon(
                      Icons.eco,
                      color: AppColors.primaryGreen,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)} / ${item.product.unit}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Quantity controls
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: () {
                        if (item.quantity > 1) {
                          ref.read(cartProvider.notifier).updateQuantity(
                                item.product.id,
                                item.quantity - 1,
                              );
                        } else {
                          ref
                              .read(cartProvider.notifier)
                              .removeFromCart(item.product.id);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              item.product.id,
                              item.quantity + 1,
                            );
                      },
                    ),
                    const Spacer(),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, WidgetRef ref, double total, int itemCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ($itemCount items)',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _showCheckoutDialog(context, ref, total);
                },
                child: Text('Proceed to Checkout',
                    style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart', style: AppTextStyles.headingSmall),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.primaryGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style:
                  AppTextStyles.labelMedium.copyWith(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(
      BuildContext context, WidgetRef ref, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Placed!', style: AppTextStyles.headingSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: AppColors.successGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your order of \$${total.toStringAsFixed(2)} has been placed successfully!',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
              // Only pop again if we're on a pushed route (not in bottom nav)
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            },
            child: Text(
              'Continue Shopping',
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}

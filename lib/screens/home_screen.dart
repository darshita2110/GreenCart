import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/config/constants/app_constants.dart';
import 'package:green_cart/providers/auth_provider.dart';
import 'package:green_cart/providers/product_provider.dart';
import 'package:green_cart/widgets/product_search_bar.dart';
import 'package:green_cart/widgets/product_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        toolbarHeight: 50,
        title: currentUserAsync.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GreenCart',
                  style: AppTextStyles.labelLarge.copyWith(fontSize: 16)),
              Text('Hello, ${user?.displayName ?? "User"}',
                  style: AppTextStyles.captionText),
            ],
          ),
          loading: () =>
              Text('GreenCart', style: AppTextStyles.labelLarge.copyWith(fontSize: 16)),
          error: (_, __) =>
              Text('GreenCart', style: AppTextStyles.labelLarge.copyWith(fontSize: 16)),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: ProductSearchBar(
                  onChanged: (query) {
                    ref.read(searchQueryProvider.notifier).state = query;
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildCategoryFilter()),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            if (searchQuery.isEmpty)
              _buildProductsGrid()
            else
              _buildSearchResultsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildCategoryChip(
            label: 'All',
            isSelected: ref.watch(selectedCategoryProvider) == null,
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = null;
            },
          ),
          ...AppConstants.productCategories.map((category) {
            final isSelected =
                ref.watch(selectedCategoryProvider) == category;
            return _buildCategoryChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = category;
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryGreen : AppColors.borderColor,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.captionText.copyWith(
              color: isSelected ? AppColors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    final productsAsync = ref.watch(productsByCategoryProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined,
                      size: 48, color: AppColors.mediumGrey),
                  const SizedBox(height: 12),
                  Text('No products found', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          );
        }
        return ProductGrid(products: products);
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child:
              CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
              const SizedBox(height: 12),
              Text('Failed to load products',
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsGrid() {
    final searchResultsAsync = ref.watch(searchResultsProvider);

    return searchResultsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: AppColors.mediumGrey),
                  const SizedBox(height: 12),
                  Text('No results found', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          );
        }
        return ProductGrid(products: products);
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child:
              CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(
          child: Text('Search failed', style: AppTextStyles.bodyMedium),
        ),
      ),
    );
  }
}
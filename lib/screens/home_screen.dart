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
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(currentUserAsync),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ProductSearchBar(
                  onChanged: (query) {
                    ref.read(searchQueryProvider.notifier).state = query;
                  },
                ),
              ),
            ),

            // Category Filter
            SliverToBoxAdapter(
              child: _buildCategoryFilter(),
            ),

            // Products Grid
            if (searchQuery.isEmpty)
              _buildProductsGrid()
            else
              _buildSearchResultsGrid(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AsyncValue currentUserAsync) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GreenCart',
            style: AppTextStyles.headingSmall,
          ),
          currentUserAsync.when(
            data: (user) => Text(
              'Hello, ${user?.displayName ?? "User"}',
              style: AppTextStyles.bodySmall,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.textPrimary),
          onPressed: _handleLogout,
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildCategoryChip(
              label: 'All',
              isSelected: ref.watch(selectedCategoryProvider) == null,
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = null;
              },
            ),
            const SizedBox(width: 12),
            ...AppConstants.productCategories.map((category) {
              final isSelected = ref.watch(selectedCategoryProvider) == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildCategoryChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state = category;
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
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
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 64,
                    color: AppColors.mediumGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return ProductGrid(products: products);
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.errorRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load products',
                style: AppTextStyles.bodyMedium,
              ),
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
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppColors.mediumGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return ProductGrid(products: products);
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(
          child: Text(
            'Search failed',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTextStyles.headingSmall,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(authServiceProvider).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(
              'Logout',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.errorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
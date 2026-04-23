import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/models/product.dart';
import 'package:green_cart/services/product_service.dart';

final productServiceProvider = Provider((ref) => ProductService());

final allProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productServiceProvider).getAllProducts();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(productServiceProvider).searchProducts(query);
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final productsByCategoryProvider = FutureProvider<List<Product>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  if (category == null) return ref.watch(allProductsProvider).value ?? [];
  return ref.watch(productServiceProvider).getProductsByCategory(category);
});

final selectedProductIdProvider = StateProvider<String?>((ref) => null);

final selectedProductProvider = FutureProvider<Product?>((ref) {
  final productId = ref.watch(selectedProductIdProvider);
  if (productId == null) return null;
  return ref.watch(productServiceProvider).getProductById(productId);
});
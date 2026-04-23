import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:green_cart/models/product.dart';

class ProductService {
  Future<List<Product>> getAllProducts() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/products.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> productsJson = jsonData['products'];

      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final products = await getAllProducts();
      final lowerQuery = query.toLowerCase();

      return products.where((product) {
        return product.name.toLowerCase().contains(lowerQuery) ||
            product.category.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final products = await getAllProducts();
      return products.firstWhere(
            (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final products = await getAllProducts();
      return products.where((product) => product.category == category).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
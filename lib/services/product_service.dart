import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_cart/models/product.dart';

class ProductService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getAllProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => Product.fromFirebase(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final results = snapshot.docs
          .where((doc) {
            final name = doc['name'].toString().toLowerCase();
            final category = doc['category'].toString().toLowerCase();
            return name.contains(query.toLowerCase()) ||
                category.contains(query.toLowerCase());
          })
          .map((doc) => Product.fromFirebase(doc.data(), doc.id))
          .toList();
      return results;
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (!doc.exists) throw Exception('Product not found');
      return Product.fromFirebase(doc.data() ?? {}, doc.id);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => Product.fromFirebase(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
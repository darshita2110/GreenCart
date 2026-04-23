class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final bool isOrganic;
  final String unit;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.isOrganic,
    required this.unit,
    required this.stock,
  });

  factory Product.fromFirebase(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      isOrganic: data['isOrganic'] ?? false,
      unit: data['unit'] ?? 'kg',
      stock: data['stock'] ?? 0,
    );
  }
}
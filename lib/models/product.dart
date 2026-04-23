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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      isOrganic: json['isOrganic'] ?? false,
      unit: json['unit'] ?? 'kg',
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'isOrganic': isOrganic,
      'unit': unit,
      'stock': stock,
    };
  }
}
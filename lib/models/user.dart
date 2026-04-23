class User {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  factory User.fromFirebase(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
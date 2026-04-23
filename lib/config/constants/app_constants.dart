class AppConstants {
  // App Info
  static const String appName = 'GreenCart';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDuration = Duration(seconds: 3);

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Product Categories
  static const List<String> productCategories = [
    'Fruits',
    'Vegetables',
    'Leafy Greens',
    'Roots',
    'Exotic',
  ];

  // Error Messages
  static const String networkError = 'No internet connection';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unexpected error occurred';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordMismatch = 'Passwords do not match';
  static const String weakPassword = 'Password is too weak';
}
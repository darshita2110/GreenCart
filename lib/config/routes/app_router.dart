import 'package:flutter/material.dart';
import 'package:green_cart/screens/splash_screen.dart';
import 'package:green_cart/screens/onboarding_screen.dart';
import 'package:green_cart/screens/login_screen.dart';
import 'package:green_cart/screens/signup_screen.dart';
import 'package:green_cart/screens/forgot_password_screen.dart';
import 'package:green_cart/screens/main_navigation_screen.dart';
import 'package:green_cart/screens/product_detail_screen.dart';
import 'package:green_cart/screens/cart_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/home':
        return MaterialPageRoute(
            builder: (_) => const MainNavigationScreen());
      case '/product-detail':
        final productId = settings.arguments as String?;
        if (productId == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Invalid product ID')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
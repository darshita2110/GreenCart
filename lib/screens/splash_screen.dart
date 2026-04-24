import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _waitThenNavigate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _waitThenNavigate() {
    // show splash for 2 seconds then check if user is already logged in
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _hasNavigated) return;
      _checkAuthState();
    });

    // safety net in case auth takes too long
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted || _hasNavigated) return;
      _goTo('/login');
    });
  }

  void _checkAuthState() {
    final authState = ref.read(authStateProvider);
    authState.when(
      data: (user) {
        _goTo(user != null ? '/home' : '/login');
      },
      loading: () {
        // still loading, wait for it
        ref.listenManual(authStateProvider, (prev, next) {
          next.when(
            data: (user) => _goTo(user != null ? '/home' : '/login'),
            loading: () {},
            error: (_, __) => _goTo('/login'),
          );
        });
      },
      error: (_, __) => _goTo('/login'),
    );
  }

  void _goTo(String route) {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.shopping_basket,
                    size: 60,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'GreenCart',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fresh Produce, Delivered Fresh',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryGreenLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
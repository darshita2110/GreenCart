import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // ✅ FIXED: Added missing import for TapGestureRecognizer
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/models/validators.dart';
import 'package:green_cart/providers/auth_provider.dart';
import 'package:green_cart/widgets/custom_text_field.dart';
import 'package:green_cart/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;

  // ✅ FIXED: Declare recognizer as field so it can be disposed properly
  late TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _signUpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).pushNamed('/signup');
      };
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpRecognizer.dispose(); // ✅ FIXED: Properly dispose recognizer
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(loginProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        error: (error, stack) {
          _showErrorSnackbar(_parseAuthError(error.toString()));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Login', style: AppTextStyles.headingSmall),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back', style: AppTextStyles.headingMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue shopping for fresh produce',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.primaryGreen),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: 'Login',
                    onPressed: _handleLogin,
                    isLoading: loginState.isLoading,
                    isEnabled: !loginState.isLoading,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.borderColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('or', style: AppTextStyles.bodySmall),
                      ),
                      const Expanded(
                          child: Divider(color: AppColors.borderColor)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: _signUpRecognizer, // ✅ FIXED: Use field recognizer
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ NEW: Parse Firebase auth errors into user-friendly messages
  String _parseAuthError(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email.';
    } else if (error.contains('wrong-password') ||
        error.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    return 'Login failed. Please try again.';
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
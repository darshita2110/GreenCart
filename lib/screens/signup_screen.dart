import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // ✅ FIXED: Added missing import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/models/validators.dart';
import 'package:green_cart/providers/auth_provider.dart';
import 'package:green_cart/widgets/custom_text_field.dart';
import 'package:green_cart/widgets/custom_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late GlobalKey<FormState> _formKey;
  bool _agreedToTerms = false;

  // ✅ FIXED: Declare recognizer as field so it can be properly disposed
  late TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();

    // ✅ FIXED: Listen to password changes to update strength indicator
    _passwordController.addListener(() => setState(() {}));

    _loginRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).pushReplacementNamed('/login');
      };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _loginRecognizer.dispose(); // ✅ FIXED: Properly dispose recognizer
    super.dispose();
  }

  void _handleSignup() {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _showErrorSnackbar('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    ref.read(signupProvider.notifier).signup(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);

    ref.listen(signupProvider, (previous, next) {
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
        title: Text('Create Account', style: AppTextStyles.headingSmall),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Join GreenCart', style: AppTextStyles.headingMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account to start shopping',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    validator: Validators.validateName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 20),
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
                    hint: 'Create a strong password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: Validators.validatePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordStrengthIndicator(),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) =>
                            setState(() => _agreedToTerms = value ?? false),
                        activeColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: AppTextStyles.bodySmall,
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: AppTextStyles.bodySmall,
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: 'Create Account',
                    onPressed: _handleSignup,
                    isLoading: signupState.isLoading,
                    isEnabled: !signupState.isLoading,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: AppTextStyles.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: _loginRecognizer, // ✅ FIXED: Use field recognizer
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

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = Validators.getPasswordStrength(password);
    // Clamp to valid index range 0-4
    final clampedStrength = strength.clamp(0, 4);
    final strengthLabels = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];
    final strengthColors = [
      AppColors.errorRed,
      const Color(0xFFFCA5A5),
      const Color(0xFFFCD34D),
      const Color(0xFF84CC16),
      AppColors.successGreen,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Strength: ${strengthLabels[clampedStrength]}',
          style: AppTextStyles.bodySmall
              .copyWith(color: strengthColors[clampedStrength]),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (clampedStrength + 1) / 5,
            minHeight: 6,
            backgroundColor: AppColors.borderColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              strengthColors[clampedStrength],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ NEW: Parse Firebase errors into human-readable messages
  String _parseAuthError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'An account with this email already exists.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger one.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    return 'Sign up failed. Please try again.';
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
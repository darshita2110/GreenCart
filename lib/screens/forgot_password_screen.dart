import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/models/validators.dart';
import 'package:green_cart/providers/auth_provider.dart';
import 'package:green_cart/widgets/custom_text_field.dart';
import 'package:green_cart/widgets/custom_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(forgotPasswordProvider.notifier).sendResetEmail(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);

    ref.listen(forgotPasswordProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (mounted) setState(() => _emailSent = true);
        },
        error: (error, stack) {
          _showErrorSnackbar(_parseError(error.toString()));
        },
      );
    });

    if (_emailSent) return _buildSuccessScreen(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Reset Password', style: AppTextStyles.headingSmall),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Your Password',
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Enter your email address and we'll send you a link to reset your password.",
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreenLight,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.mail_outline,
                        size: 50,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'Enter your registered email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: 'Send Reset Link',
                    onPressed: _handleForgotPassword,
                    isLoading: forgotPasswordState.isLoading,
                    isEnabled: !forgotPasswordState.isLoading,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back to Login',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.primaryGreen),
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

  Widget _buildSuccessScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title:
        Text('Check Your Email', style: AppTextStyles.headingSmall),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: AppColors.successGreen,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Check Your Email',
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We\'ve sent a password reset link to ${_emailController.text}. Please check your inbox and follow the instructions.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomButton(
                label: 'Back to Login',
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/login'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Try Different Email',
                variant: ButtonVariant.secondary,
                onPressed: () {
                  setState(() => _emailSent = false);
                  _emailController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _parseError(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email address.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    return 'Failed to send reset email. Please try again.';
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
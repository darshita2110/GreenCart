import 'package:flutter/material.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double width;
  final double height;
  final ButtonVariant variant;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width = double.infinity,
    this.height = 56,
    this.variant = ButtonVariant.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          )
              : Text(label, style: AppTextStyles.buttonText),
        );

      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen),
            ),
          )
              : Text(
            label,
            style: AppTextStyles.buttonText.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
        );

      case ButtonVariant.text:
        return TextButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: Text(label, style: AppTextStyles.labelLarge),
        );
    }
  }
}
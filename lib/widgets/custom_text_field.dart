import 'package:flutter/material.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool isPassword;
  final int maxLines;
  final int minLines;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _showPassword;

  @override
  void initState() {
    super.initState();
    _showPassword = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && !_showPassword,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.isPassword ? 1 : widget.minLines,
          readOnly: widget.readOnly,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixText: widget.prefixText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                    child: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.mediumGrey,
                    ),
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
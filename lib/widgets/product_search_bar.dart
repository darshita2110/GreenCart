import 'package:flutter/material.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';

class ProductSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClearSearch;

  const ProductSearchBar({
    Key? key,
    required this.onChanged,
    this.onClearSearch,
  }) : super(key: key);

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _isSearching = _controller.text.isNotEmpty);
    widget.onChanged(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClearSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: _controller,
        style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search fruits, vegetables...',
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.mediumGrey, fontSize: 13,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.mediumGrey, size: 20),
          suffixIcon: _isSearching
              ? GestureDetector(
                  onTap: _clearSearch,
                  child: const Icon(Icons.close, color: AppColors.mediumGrey, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: true,
        ),
      ),
    );
  }
}
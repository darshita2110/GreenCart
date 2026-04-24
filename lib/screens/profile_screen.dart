import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/config/theme/app_colors.dart';
import 'package:green_cart/config/theme/app_text_styles.dart';
import 'package:green_cart/providers/auth_provider.dart';
import 'package:green_cart/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              currentUserAsync.when(
                data: (user) => _profileHeader(
                    user?.displayName ?? 'User', user?.email ?? ''),
                loading: () => _profileHeader('Loading...', ''),
                error: (_, __) => _profileHeader('User', ''),
              ),
              const SizedBox(height: 32),
              _menuItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => _comingSoon(context),
              ),
              _menuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View your order history',
                onTap: () => _comingSoon(context),
              ),
              _menuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                subtitle: 'Manage your delivery addresses',
                onTap: () => _comingSoon(context),
              ),
              _menuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => _comingSoon(context),
              ),
              _menuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your orders',
                onTap: () => _comingSoon(context),
              ),
              _menuItem(
                icon: Icons.info_outline,
                title: 'About GreenCart',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'GreenCart',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2026 GreenCart',
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Fresh produce shopping app built with Flutter, Firebase, and Riverpod.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Logout',
                variant: ButtonVariant.secondary,
                onPressed: () => _handleLogout(context, ref),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  Widget _profileHeader(String name, String email) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryGreen, Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: AppTextStyles.headingLarge.copyWith(
                color: AppColors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(name, style: AppTextStyles.headingSmall),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(email, style: AppTextStyles.bodyMedium),
        ],
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelLarge),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.mediumGrey),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: AppTextStyles.headingSmall),
        content: Text('Are you sure?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.primaryGreen)),
          ),
          TextButton(
            onPressed: () {
              ref.read(authServiceProvider).logout();
              Navigator.pop(ctx);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text('Logout',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }
}

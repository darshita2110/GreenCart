import 'package:flutter/material.dart';
import 'package:green_cart/config/routes/app_router.dart';
import 'package:green_cart/config/theme/app_theme.dart';

class GreenCartApp extends StatelessWidget {
  const GreenCartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenCart',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/shop/shop_page.dart';

class OneFiApp extends StatelessWidget {
  const OneFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1Fi Marketplace',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const ShopPage(),
    );
  }
}

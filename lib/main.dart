import 'package:e_commerce_app/screens/home_screen.dart';
import 'package:e_commerce_app/screens/product_details_screen.dart';
import 'package:e_commerce_app/screens/search_screen.dart';
import 'package:e_commerce_app/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: ECommerceApp()));
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        'product-details-screen': (context) => ProductDetailsScreen(),
        'wishlist-screen': (context) => WishlistScreen(),
        'search-screen': (context) => SearchScreen(),
      },
    );
  }
}

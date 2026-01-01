import 'package:e_commerce_app/states/cart/cart_provider.dart';
import 'package:e_commerce_app/states/product/product_provider.dart';
import 'package:e_commerce_app/states/wishlist/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Mini E-Commerce App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'search-screen');
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'wishlist-screen');
            },
            icon: Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
      body: products.isLoading
          ? GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width / 180)
                    .floor()
                    .clamp(2, 6),
                childAspectRatio: MediaQuery.of(context).size.width < 350
                    ? 0.55
                    : 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => Card(
                elevation: 0,
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SizedBox.expand(),
              ),
            )
          : products.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(products.errorMessage!),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.read(productProvider.notifier).loadProducts();
                    },
                    child: Text(
                      "Retry",
                      style: TextStyle(color: Colors.redAccent.shade700),
                    ),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth / 180).floor().clamp(
                  2,
                  6,
                );
                double aspectRatio = constraints.maxWidth < 350 ? 0.55 : 0.65;
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: products.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = products.products[index];
                    final isWishlisted = ref.watch(
                      wishlistProvider.select(
                        (s) => s.items.any((i) => i.id == item.id),
                      ),
                    );
                    return InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed('product-details-screen', arguments: item);
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        item.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        isWishlisted
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isWishlisted
                                            ? Colors.red
                                            : Colors.black54,
                                      ),
                                      onPressed: () => ref
                                          .read(wishlistProvider.notifier)
                                          .toggleWishlist(item),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item.price}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 34,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .addToCart(item);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "${item.title} added",
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Add to cart",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

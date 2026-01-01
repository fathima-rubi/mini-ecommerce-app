import 'package:e_commerce_app/states/cart/cart_provider.dart';
import 'package:e_commerce_app/states/product/product_provider.dart';
import 'package:e_commerce_app/states/wishlist/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final filteredProducts = productState.products.where((element) {
      return element.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for any item',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                ? const Center(child: Text("No products found"))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = (constraints.maxWidth / 180)
                          .floor()
                          .clamp(2, 6);
                      double aspectRatio = constraints.maxWidth < 350
                          ? 0.55
                          : 0.65;
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: aspectRatio,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredProducts[index];
                          final isWishlisted = ref.watch(
                            wishlistProvider.select(
                              (s) => s.items.any((i) => i.id == item.id),
                            ),
                          );
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                'product-details-screen',
                                arguments: item,
                              );
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
                                            borderRadius:
                                                const BorderRadius.vertical(
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
                                    padding: const EdgeInsets.fromLTRB(
                                      8,
                                      4,
                                      8,
                                      8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                  behavior:
                                                      SnackBarBehavior.floating,
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
          ),
        ],
      ),
    );
  }
}

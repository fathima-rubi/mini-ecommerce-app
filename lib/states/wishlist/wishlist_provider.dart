import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/states/wishlist/wishlist_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>(
  (ref) {
    return WishlistNotifier();
  },
);

class WishlistNotifier extends StateNotifier<WishlistState> {
  WishlistNotifier() : super(WishlistState(items: []));

  void toggleWishlist(ProductModel product) {
    final exists = state.items.any((item) => item.id == product.id);

    if (exists) {
      state = state.copyWith(
        items: state.items.where((item) => item.id != product.id).toList(),
      );
    } else {
      state = state.copyWith(items: [...state.items, product]);
    }
  }

  bool isWishlisted(ProductModel product) {
    return state.items.any((item) => item.id == product.id);
  }
}

import 'package:e_commerce_app/models/cart_model.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/states/cart/cart_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  double get totalPrice {
    return state.items.fold(
      0,
      (previousValue, element) =>
          previousValue + element.product.price * element.quantity,
    );
  }

  void addToCart(ProductModel product) {
    final index = state.items.indexWhere(
      (element) => element.product.id == product.id,
    );

    if (index == -1) {
      state = state.copyWith(
        items: [
          ...state.items,
          CartModel(product: product, quantity: 1),
        ],
      );
    } else {
      final updatedItem = state.items[index].copyWith(
        quantity: state.items[index].quantity + 1,
      );
      final updatedItems = [...state.items];
      updatedItems[index] = updatedItem;

      state = state.copyWith(items: updatedItems);
    }
  }

  void decreaseQuantity(ProductModel product) {
    final index = state.items.indexWhere(
      (element) => element.product.id == product.id,
    );

    if (index == -1) return;

    final item = state.items[index];

    if (item.quantity == 1) {
      removeFromCart(product);
    } else {
      final updatedItem = item.copyWith(quantity: item.quantity - 1);
      final updatedItems = [...state.items];
      updatedItems[index] = updatedItem;
      state = state.copyWith(items: updatedItems);
    }
  }

  void removeFromCart(ProductModel product) {
    state = state.copyWith(
      items: state.items
          .where((element) => element.product.id != product.id)
          .toList(),
    );
  }

  void clearCart() {
    state = CartState(items: []);
  }
}

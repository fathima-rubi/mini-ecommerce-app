import 'package:e_commerce_app/models/cart_model.dart';

class CartState {
  final List<CartModel> items;

  CartState({required this.items});

  CartState copyWith({List<CartModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}

import 'package:e_commerce_app/models/product_model.dart';

class CartModel {
  final ProductModel product;
  final int quantity;

  CartModel({required this.product, required this.quantity});

  CartModel copyWith({ProductModel? product, int? quantity}) {
    return CartModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

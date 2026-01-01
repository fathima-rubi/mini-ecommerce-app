import 'package:e_commerce_app/models/product_model.dart';

class WishlistState {
  final List<ProductModel> items;

  WishlistState({required this.items});

  WishlistState copyWith({List<ProductModel>? items}) {
    return WishlistState(items: items ?? this.items);
  }
}

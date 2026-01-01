import 'package:e_commerce_app/models/product_model.dart';

class ProductState {
  final bool isLoading;
  final List<ProductModel> products;
  final String? errorMessage;

  ProductState({
    required this.isLoading,
    required this.products,
    this.errorMessage,
  });

  factory ProductState.initial() {
    return ProductState(products: [], isLoading: false, errorMessage: null);
  }
  ProductState copyWith({
    bool? isLoading,
    List<ProductModel>? products,
    String? errorMessage,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      errorMessage: errorMessage,
    );
  }
}

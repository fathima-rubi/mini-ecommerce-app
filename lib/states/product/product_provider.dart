import 'package:e_commerce_app/services/product_service.dart';
import 'package:e_commerce_app/states/product/product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final productServiceProvider = Provider<ProductService>(
  (ref) => ProductService(),
);

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(ref.read(productServiceProvider)),
);

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductService productService;
  ProductNotifier(this.productService) : super(ProductState.initial());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final products = await productService.fetchProducts();
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

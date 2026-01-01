import 'dart:convert';

import 'package:e_commerce_app/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<ProductModel>> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

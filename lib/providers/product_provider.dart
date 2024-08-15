import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Products> _products = [];
  bool _loading = false;
  final ProductService _productService = ProductService();

  List<Products> get products => _products;
  bool get loading => _loading;

  Future<void> loadProducts() async {
    _loading = true;
    notifyListeners();

    _products = await _productService.fetchProducts();
    print(_products);

    _loading = false;
    notifyListeners();
  }
}

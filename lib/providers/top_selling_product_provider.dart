import 'package:e_commerce_project/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_project/data/product_list.dart';

final List<Product> _productsList = getProducts();
final topSellingProvider = Provider<List<Product>>((ref) {
  return _productsList.where((prod) => prod.salesNumber > 50).toList();
});

import 'package:e_commerce_project/data/product_list.dart';
import 'package:e_commerce_project/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<Product> _productsList = getProducts();

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchProductListProvider = Provider<List<Product>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  if (searchQuery.trim().isEmpty) {
    return [];
  }
  final filteredProductList =
      _productsList
          .where((product) => product.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
  return filteredProductList;
});

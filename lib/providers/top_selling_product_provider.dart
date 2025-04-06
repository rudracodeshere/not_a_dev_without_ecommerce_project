import 'package:e_commerce_project/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_project/data/product_list.dart';

final List<Product> _productsList = getProducts();
final topSellingProvider = Provider<List<Product>>((ref) {
  return _productsList.where((prod) => prod.salesNumber > 50).toList();
});

final newlyCreatedProvider = Provider<List<Product>>((ref) {
  final DateTime now = DateTime.now();
  final DateTime twoMonthsBefore = now.subtract(Duration(days: 60));
  return _productsList
      .where(
        (prod) =>
            prod.createdDate.isAfter(twoMonthsBefore) &&
            prod.createdDate.isBefore(now),
      )
      .toList();
});

class CategoryProductNotifier extends StateNotifier<List<Product>> {
  CategoryProductNotifier() : super([]);

  void setProductsByCategory(String category) {
    state = _productsList.where((prod) => prod.categoryId == category).toList();
  }
}

final categoryProductProvider =
    StateNotifierProvider<CategoryProductNotifier, List<Product>>((ref) {
      return CategoryProductNotifier();
    });

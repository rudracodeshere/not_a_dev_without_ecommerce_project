import 'package:e_commerce_project/models/add_to_cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<AddToCardModel>>((
  ref,
) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<AddToCardModel>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  final box = Hive.box<AddToCardModel>('cartBox');

  void _loadCart() {
    final items = box.values.toList();
    state = items;
    for (var item in state) {
      print(item.title);
    }
  }

  void addToCart(AddToCardModel item) {
    box.add(item);
    state = [...state, item];
      for (var item in state) {
      print(item.title);
    }
  }

  void removeFromCart(int index) {
    box.deleteAt(index);
    state = [...box.values];
  }

  void clearCart() {
    box.clear();
    state = [];
  }
}

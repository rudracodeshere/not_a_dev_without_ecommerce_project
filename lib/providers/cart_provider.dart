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
    final existingIndex = state.indexWhere((i) => 
      i.productId == item.productId && 
      i.size == item.size && 
      i.color == item.color);
    
    if (existingIndex != -1) {
      updateItemQuantity(existingIndex, state[existingIndex].quantity + item.quantity);
    } else {
      box.add(item);
      state = [...state, item];
    }
    
    for (var item in state) {
      print(item.title);
    }
  }

  void removeFromCart(int index) {
    box.deleteAt(index);
    state = [...box.values];
  }

  void updateItemQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(index);
      return;
    }
    
    final item = state[index];
    
    final updatedItem = AddToCardModel(
      productId: item.productId,
      title: item.title,
      categoryId: item.categoryId,
      color: item.color,
      createdDate: item.createdDate,
      price: item.price,
      size: item.size,
      quantity: newQuantity,
    );
    
    box.putAt(index, updatedItem);
    
    final newState = List<AddToCardModel>.from(state);
    newState[index] = updatedItem;
    state = newState;
  }

  void clearCart() {
    box.clear();
    state = [];
  }
}

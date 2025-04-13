import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/favorite_product.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteProduct>>(
  (ref) => FavoritesNotifier(),
);

final isProductFavoriteProvider = Provider.family<bool, String>(
  (ref, productId) {
    final favorites = ref.watch(favoritesProvider);
    return favorites.any((product) => product.productId == productId);
  },
);

class FavoritesNotifier extends StateNotifier<List<FavoriteProduct>> {
  FavoritesNotifier() : super([]) {
    _initHive();
  }

  static const String _boxName = 'favorites';
  Box<FavoriteProduct>? _favoritesBox;

  Future<void> _initHive() async {
    try {
      _favoritesBox = await Hive.openBox<FavoriteProduct>(_boxName);
      
      final favoritesList = _favoritesBox!.values.toList();
      state = favoritesList;
    } catch (e) {
      debugPrint('Error initializing favorites: $e');
    }
  }

  Future<void> addToFavorites(FavoriteProduct product) async {
    try {
      if (!isProductInFavorites(product.productId)) {
        await _favoritesBox?.add(product);
        
        state = [...state, product];
      }
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    try {
      final index = state.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        final product = state[index];
        
        final key = product.key;
        
        await _favoritesBox?.delete(key);
        
        state = state.where((item) => item.productId != productId).toList();
      }
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  Future<void> toggleFavorite({
    required String productId,
    required String title,
    required String categoryId,
    required double price,
    double? discountedPrice,
    String? imageUrl,
  }) async {
    if (isProductInFavorites(productId)) {
      await removeFromFavorites(productId);
    } else {
      final product = FavoriteProduct.fromProduct(
        productId: productId,
        title: title,
        categoryId: categoryId,
        price: price,
        discountedPrice: discountedPrice,
        imageUrl: imageUrl,
      );
      await addToFavorites(product);
    }
  }

  bool isProductInFavorites(String productId) {
    return state.any((product) => product.productId == productId);
  }

  Future<void> clearFavorites() async {
    try {
      await _favoritesBox?.clear();
      state = [];
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }
}
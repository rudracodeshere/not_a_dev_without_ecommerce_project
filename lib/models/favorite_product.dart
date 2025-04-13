import 'package:hive/hive.dart';

part 'favorite_product.g.dart';

@HiveType(typeId: 2)
class FavoriteProduct extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String categoryId;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double? discountedPrice;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final DateTime addedDate;

  FavoriteProduct({
    required this.productId,
    required this.title,
    required this.categoryId,
    required this.price,
    this.discountedPrice,
    this.imageUrl,
    required this.addedDate,
  });

  // Create a favorite product from the Product model
  factory FavoriteProduct.fromProduct({
    required String productId,
    required String title,
    required String categoryId,
    required double price,
    double? discountedPrice,
    String? imageUrl,
  }) {
    return FavoriteProduct(
      productId: productId,
      title: title,
      categoryId: categoryId,
      price: price,
      discountedPrice: discountedPrice,
      imageUrl: imageUrl,
      addedDate: DateTime.now(),
    );
  }
}
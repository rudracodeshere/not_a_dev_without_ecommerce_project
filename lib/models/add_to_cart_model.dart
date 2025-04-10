import 'package:hive/hive.dart';
part 'add_to_cart_model.g.dart';

@HiveType(typeId: 0)
class AddToCardModel extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String color;

  @HiveField(4)
  final DateTime createdDate;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final String size;

  @HiveField(7)
  final int quantity;

  AddToCardModel({
    required this.productId,
    required this.title,
    required this.categoryId,
    required this.color,
    required this.createdDate,
    required this.price,
    required this.size,
    required this.quantity,
  });
}

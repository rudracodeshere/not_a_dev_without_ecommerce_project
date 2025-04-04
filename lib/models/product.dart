import 'package:e_commerce_project/models/product_color.dart';

class Product{
  final String productId;
  final String title;
  final String categoryId;
  final List<ProductColor> colors;
  final DateTime createdDate;
  final double price;
  final double? discountedPrice;
  final int gender;
  final List<String> images;
  final List<String> sizes;
  final int salesNumber;

  Product({
    required this.productId,
    required this.title,
    required this.categoryId,
    required this.colors,
    required this.createdDate,
    required this.price,
    this.discountedPrice,
    required this.gender,
    required this.images,
    required this.sizes,
    this.salesNumber = 0,
  });
 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      title: json['title'],
      categoryId: json['categoryId'],
      colors: (json['colors'] as List)
          .map((colorJson) => ProductColor.fromJson(colorJson))
          .toList(),
      createdDate: DateTime.parse(json['createdDate']),
      price: json['price'].toDouble(),
      discountedPrice: json['discountedPrice']?.toDouble(),
      gender: json['gender'],
      images: List<String>.from(json['images']),
      sizes: List<String>.from(json['sizes']),
      salesNumber: json['salesNumber'] ?? 0,
    );
  }
}
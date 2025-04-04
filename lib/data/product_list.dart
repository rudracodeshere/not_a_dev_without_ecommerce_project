import 'package:e_commerce_project/models/product.dart';

final List<Map<String, dynamic>> sampleProductsData = [
  // 👜 Bags
  {
    'productId': 'p1001',
    'title': 'Leather Shoulder Bag',
    'categoryId': 'Bags',
    'colors': [
      {'title': 'Brown', 'hexcode': '#8B4513'},
      {'title': 'Black', 'hexcode': '#000000'}
    ],
    'createdDate': '2025-03-10T10:30:00.000Z',
    'price': 79.99,
    'discountedPrice': 64.99,
    'gender': 2,
    'images': [
      'assets/images/leather_bag_1.jpg',
      'assets/images/leather_bag_2.jpg'
    ],
    'sizes': ['One Size'],
    'salesNumber': 95
  },
  {
    'productId': 'p1002',
    'title': 'Casual Backpack',
    'categoryId': 'Bags',
    'colors': [
      {'title': 'Blue', 'hexcode': '#1E90FF'},
      {'title': 'Gray', 'hexcode': '#808080'}
    ],
    'createdDate': '2025-02-20T14:15:00.000Z',
    'price': 49.99,
    'discountedPrice': null,
    'gender': 2,
    'images': [
      'assets/images/backpack_1.jpg',
      'assets/images/backpack_2.jpg'
    ],
    'sizes': ['One Size'],
    'salesNumber': 55
  },

  // 🩳 Shorts
  {
    'productId': 'p1003',
    'title': 'Men’s Cotton Shorts',
    'categoryId': 'Shorts',
    'colors': [
      {'title': 'Khaki', 'hexcode': '#C3B091'},
      {'title': 'Navy', 'hexcode': '#000080'}
    ],
    'createdDate': '2025-03-01T09:45:00.000Z',
    'price': 34.99,
    'discountedPrice': 29.99,
    'gender': 0,
    'images': [
      'assets/images/mens_shorts_1.jpg',
      'assets/images/mens_shorts_2.jpg'
    ],
    'sizes': ['S', 'M', 'L', 'XL'],
    'salesNumber': 120
  },
  {
    'productId': 'p1004',
    'title': 'Women’s Running Shorts',
    'categoryId': 'Shorts',
    'colors': [
      {'title': 'Pink', 'hexcode': '#FFC0CB'},
      {'title': 'Black', 'hexcode': '#000000'}
    ],
    'createdDate': '2025-01-10T11:20:00.000Z',
    'price': 29.99,
    'discountedPrice': 24.99,
    'gender': 1,
    'images': [
      'assets/images/womens_shorts_1.jpg',
      'assets/images/womens_shorts_2.jpg'
    ],
    'sizes': ['XS', 'S', 'M', 'L'],
    'salesNumber': 70
  },

  // 👟 Shoes
  {
    'productId': 'p1005',
    'title': 'Running Sneakers',
    'categoryId': 'Shoes',
    'colors': [
      {'title': 'White', 'hexcode': '#FFFFFF'},
      {'title': 'Blue', 'hexcode': '#1E90FF'}
    ],
    'createdDate': '2025-03-25T15:30:00.000Z',
    'price': 99.99,
    'discountedPrice': 79.99,
    'gender': 0,
    'images': [
      'assets/images/running_sneakers_1.jpg',
      'assets/images/running_sneakers_2.jpg'
    ],
    'sizes': ['40', '41', '42', '43', '44'],
    'salesNumber': 150
  },
  {
    'productId': 'p1006',
    'title': 'Casual Slip-On Shoes',
    'categoryId': 'Shoes',
    'colors': [
      {'title': 'Gray', 'hexcode': '#808080'},
      {'title': 'Black', 'hexcode': '#000000'}
    ],
    'createdDate': '2025-03-18T12:00:00.000Z',
    'price': 59.99,
    'discountedPrice': 49.99,
    'gender': 2,
    'images': [
      'assets/images/slipon_shoes_1.jpg',
      'assets/images/slipon_shoes_2.jpg'
    ],
    'sizes': ['39', '40', '41', '42'],
    'salesNumber': 95
  },

  // 🧥 Hoodies
  {
    'productId': 'p1007',
    'title': 'Men’s Zip-Up Hoodie',
    'categoryId': 'Hoodies',
    'colors': [
      {'title': 'Black', 'hexcode': '#000000'},
      {'title': 'Gray', 'hexcode': '#808080'}
    ],
    'createdDate': '2025-02-05T08:45:00.000Z',
    'price': 79.99,
    'discountedPrice': 69.99,
    'gender': 0,
    'images': [
      'assets/images/zipup_hoodie_1.jpg',
      'assets/images/zipup_hoodie_2.jpg'
    ],
    'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
    'salesNumber': 130
  },
  {
    'productId': 'p1008',
    'title': 'Women’s Oversized Hoodie',
    'categoryId': 'Hoodies',
    'colors': [
      {'title': 'Pink', 'hexcode': '#FFC0CB'},
      {'title': 'Beige', 'hexcode': '#F5F5DC'}
    ],
    'createdDate': '2025-04-01T14:20:00.000Z',
    'price': 69.99,
    'discountedPrice': 59.99,
    'gender': 1,
    'images': [
      'assets/images/oversized_hoodie_1.jpg',
      'assets/images/oversized_hoodie_2.jpg'
    ],
    'sizes': ['XS', 'S', 'M', 'L'],
    'salesNumber': 85
  },

  // 🎧 Accessories
  {
    'productId': 'p1009',
    'title': 'Smart Watch',
    'categoryId': 'Accessories',
    'colors': [
      {'title': 'Black', 'hexcode': '#000000'},
      {'title': 'Silver', 'hexcode': '#C0C0C0'}
    ],
    'createdDate': '2025-02-28T16:10:00.000Z',
    'price': 129.99,
    'discountedPrice': null,
    'gender': 2,
    'images': [
      'assets/images/smart_watch_1.jpg',
      'assets/images/smart_watch_2.jpg'
    ],
    'sizes': ['One Size'],
    'salesNumber': 200
  },
  {
    'productId': 'p1010',
    'title': 'Wireless Earbuds',
    'categoryId': 'Accessories',
    'colors': [
      {'title': 'White', 'hexcode': '#FFFFFF'},
      {'title': 'Black', 'hexcode': '#000000'}
    ],
    'createdDate': '2025-01-30T13:00:00.000Z',
    'price': 99.99,
    'discountedPrice': 79.99,
    'gender': 2,
    'images': [
      'assets/images/wireless_earbuds_1.jpg',
      'assets/images/wireless_earbuds_2.jpg'
    ],
    'sizes': ['One Size'],
    'salesNumber': 180
  }
];

List<Product> getProducts() {
  return sampleProductsData.map((json) => Product.fromJson(json)).toList();
}

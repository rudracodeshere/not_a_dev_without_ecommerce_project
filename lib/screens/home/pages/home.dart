import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/models/product.dart';
import 'package:e_commerce_project/providers/category_provider.dart';
import 'package:e_commerce_project/providers/top_selling_product_provider.dart';
import 'package:e_commerce_project/screens/home/pages/widgets/home_header.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:e_commerce_project/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  User? user;
  bool _isLoading = true;
  List<Product> _topProds = [];
  List<dynamic> _categories = [];

  void _loadAllData() async {
    final userId = auth.FirebaseAuth.instance.currentUser!.uid;

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (userDoc.exists) {
        user = User.fromJson(userDoc.data()!);
      }

      final categoryData = await ref.read(categoryProvider.future);
      _categories = categoryData;

      _topProds = ref.read(topSellingProvider);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  HomeHeader(user: user),
                  _searchBar(),
                  _categoryRow(),
                  _topSellers(),
                ],
              ),
    );
  }

  Widget _topSellers() {
    return Container(
      height: 210,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Sellers',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _topProds.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => _productCard(_topProds[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: EdgeInsets.all(8),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static Image for now
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2FBags.jpg?alt=media',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Prices
                Row(
                  children: [
                    if (product.discountedPrice != null) ...[
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '\$${product.discountedPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ] else
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black),
          hintText: 'search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _categoryRow() {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Text(
                  'See All',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      category.image != null
                          ? Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${category.title}.jpg?alt=media',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.category),
                          ),
                      const SizedBox(height: 8),
                      Text(
                        category.title ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

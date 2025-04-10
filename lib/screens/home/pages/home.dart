import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/models/product.dart';
import 'package:e_commerce_project/providers/category_provider.dart';
import 'package:e_commerce_project/providers/top_selling_product_provider.dart';
import 'package:e_commerce_project/screens/home/pages/categories_screen.dart';
import 'package:e_commerce_project/screens/home/pages/product_grid.dart';
import 'package:e_commerce_project/screens/home/pages/product_page.dart';
import 'package:e_commerce_project/screens/home/pages/search_page.dart';
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
  List<Product> newProds = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
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

      _categories = await ref.read(categoryProvider.future);
      _topProds = ref.read(topSellingProvider).reversed.toList();
      newProds = ref.read(newlyCreatedProvider);
    } catch (e) {
      debugPrint("Error loading data: $e");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary.withOpacity(0.1),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(user: user),
                      _searchBar(context),
                      _categoryRow(context),
                      _topSellers(context),
                      _newProducts(context),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        readOnly: true,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => SearchPage()));
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurface),
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
        ),
      ),
    );
  }

  Widget _categoryRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPortrait = MediaQuery.of(context).size.width < 600;
    return SizedBox(
      height: isPortrait ? 150 : 200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CategoriesScreen()),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      category.image != null
                          ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductGridScreen(
                                          title: category.title,
                                        ),
                                  ),
                                );
                              },
                              child: Ink(
                                width: isPortrait ? 60 : 100,
                                height: isPortrait ? 60 : 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${category.title}.jpg?alt=media',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                          : CircleAvatar(
                            radius: 30,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              Icons.category,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                      const SizedBox(height: 8),
                      Text(
                        category.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
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

  Widget _topSellers(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 280,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Sellers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _topProds.length,
              scrollDirection: Axis.horizontal,
              itemBuilder:
                  (context, index) => _productCard(context, _topProds[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newProducts(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: ListView.builder(
              itemCount: newProds.length,
              scrollDirection: Axis.horizontal,
              itemBuilder:
                  (context, index) => _productCard(context, newProds[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context, Product product) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductPage(product: product),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: const EdgeInsets.all(8),
        width: 160,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${product.categoryId}.jpg?alt=media',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (product.discountedPrice != null) ...[
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '\$${product.discountedPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ] else
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

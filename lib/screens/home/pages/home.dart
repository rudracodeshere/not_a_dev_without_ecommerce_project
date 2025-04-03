import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/providers/category_provider.dart';
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
  late final user;
  bool headerLoader = false;
  void _loadUserData() async {
    final userId = auth.FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((
      value,
    ) {
      final userData = value.data();
      user = User.fromJson(userData!);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      body: Column(children: [HomeHeader(), _searchBar(), _categoryRow()]),
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
    final categoryAsyncValue = ref.watch(categoryProvider);
    return categoryAsyncValue.when(
      data:
          (categories) => SizedBox(
            height: 200,
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
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
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
          ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/screens/home/pages/product_grid.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  Future<List<String>> _getCategories() async {
    final snapshots =
        await FirebaseFirestore.instance.collection('categories').get();

    return List<String>.from(
      snapshots.docs.map((doc) => doc.data()['title'] as String).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Categories', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: _getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found.'));
            }
        
            final catTitles = snapshot.data!;
        
            return ListView.builder(
              itemCount: catTitles.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${catTitles[index]}.jpg?alt=media',
                          ),
                        ),
                        title: Text(
                          catTitles[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProductGridScreen(title: catTitles[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }
}

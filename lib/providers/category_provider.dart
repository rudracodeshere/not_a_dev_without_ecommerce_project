import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
});

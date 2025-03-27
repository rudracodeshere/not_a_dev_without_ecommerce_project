import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/screens/home/pages/widgets/home_header.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:e_commerce_project/models/user.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      body: Column(
        children: [
          HomeHeader(),
        ],
      ),
      );
  }
}
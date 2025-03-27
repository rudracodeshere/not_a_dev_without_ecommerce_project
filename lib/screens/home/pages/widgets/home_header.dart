import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../../../../models/user.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader({super.key});
  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool _loading = true;
  User? user;
  void _loadUserData() async {
    final userId = auth.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).get().then(
      (value) {
        final userData = value.data();
        user = User.fromJson(userData!);
        setState(() {
          _loading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("User profile tapped!");
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          user!.gender == 1 ? 'Male' : 'Female',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        print("Shopping bag tapped!");
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

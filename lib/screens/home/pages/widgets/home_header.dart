import 'package:flutter/material.dart';
import '../../../../models/user.dart';

class HomeHeader extends StatelessWidget {
  final User? user;

  const HomeHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
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
                    user != null ? (user!.gender == 1 ? 'Male' : 'Female') : 'Guest',
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
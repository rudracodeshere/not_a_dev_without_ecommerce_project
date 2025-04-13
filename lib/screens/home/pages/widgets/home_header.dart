import 'package:e_commerce_project/providers/cart_provider.dart';
import 'package:e_commerce_project/providers/favorites_provider.dart';
import 'package:e_commerce_project/screens/cart_screen.dart';
import 'package:e_commerce_project/screens/favorites_screen.dart';
import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/user.dart';

class HomeHeader extends ConsumerWidget {
  final User? user;

  const HomeHeader({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final favorites = ref.watch(favoritesProvider);
    
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
            Row(
              children: [
                // Favorites icon
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: FavoritesIconWithBadge(
                    count: favorites.length,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Cart icon
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: CartIconWithBadge(
                    count: cartItems.length,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
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

class FavoritesIconWithBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const FavoritesIconWithBadge({
    required this.count,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.favorite_outline,
              color: Colors.black,
            ),
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  count > 9 ? '9+' : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
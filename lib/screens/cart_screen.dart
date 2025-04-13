import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/models/add_to_cart_model.dart';
import 'package:e_commerce_project/providers/cart_provider.dart';
import 'package:e_commerce_project/screens/successful_checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isPlacingOrder = false;

  void _placeOrder(cartItems) async {
    final userid = FirebaseAuth.instance.currentUser?.uid;

    setState(() {
      _isPlacingOrder = true;
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(userid!)
        .collection('orders')
        .add({
          'items':
              cartItems
                  .map(
                    (item) => {
                      'productId': item.productId,
                      'title': item.title,
                      'categoryId': item.categoryId,
                      'color': item.color,
                      'createdDate': item.createdDate,
                      'price': item.price,
                      'size': item.size,
                      'quantity': item.quantity,
                    },
                  )
                  .toList(),
          'totalPrice': cartItems.fold(
            0.0,
            (sum, item) => sum + (item.price * item.quantity),
          ),
          'orderDate': DateTime.now(),
        })
        .then((_) {
          ref.read(cartProvider.notifier).clearCart();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SuccessfulCheckout()),
            (route) => false,
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to place order: $error'),
              duration: const Duration(seconds: 2),
            ),
          );
        });
    setState(() {
      _isPlacingOrder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearCartDialog(context, ref),
              tooltip: 'Clear cart',
            ),
        ],
      ),
      body:
          cartItems.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartList(context, cartItems, ref),
      bottomNavigationBar:
          cartItems.isEmpty
              ? null
              : _buildCheckoutBar(
                context,
                totalPrice,
                _isPlacingOrder,
                cartItems,
              ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Add items to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(
    BuildContext context,
    List<AddToCardModel> items,
    WidgetRef ref,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemCard(item: item, index: index, ref: ref);
      },
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    double totalPrice,
    bool placeOrder,
    cartItems,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed:
                  placeOrder
                      ? null
                      : () {
                        _placeOrder(cartItems);
                      },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('CHECKOUT'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text('Are you sure you want to remove all items?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('CANCEL'),
              ),
              FilledButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  Navigator.of(ctx).pop();
                },
                child: const Text('CLEAR'),
              ),
            ],
          ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final AddToCardModel item;
  final int index;
  final WidgetRef ref;

  const CartItemCard({
    required this.item,
    required this.index,
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.productId + item.size + item.color),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: Colors.red.shade700),
      ),
      onDismissed: (_) {
        ref.read(cartProvider.notifier).removeFromCart(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} removed from cart'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Remove Item'),
                content: Text(
                  'Are you sure you want to remove ${item.title} from your cart?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('CANCEL'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('REMOVE'),
                  ),
                ],
              ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: _parseColor(item.color),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${item.categoryId}.jpg?alt=media',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Size: ${item.size}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _parseColor(item.color),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getColorName(item.color),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                        QuantityControls(
                          quantity: item.quantity,
                          index: index,
                          ref: ref,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      // If it's already a hex code with # prefix
      if (colorString.startsWith('#')) {
        String hexString = colorString.substring(1);
        // Handle both 6-digit and 3-digit hex formats
        if (hexString.length == 6) {
          return Color(int.parse('0xFF$hexString'));
        } else if (hexString.length == 3) {
          // Convert 3-digit to 6-digit format (e.g., #F00 -> #FF0000)
          String expandedHex = '';
          for (int i = 0; i < 3; i++) {
            expandedHex += hexString[i] + hexString[i];
          }
          return Color(int.parse('0xFF$expandedHex'));
        }
      }

      // Handle predefined color names
      switch (colorString.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'purple':
          return Colors.purple;
        case 'pink':
          return Colors.pink;
        case 'brown':
          return Colors.brown;
        case 'black':
          return Colors.black;
        case 'white':
          return Colors.white;
        case 'grey':
        case 'gray':
          return Colors.grey;
      }
    } catch (e) {
      debugPrint('Invalid color string: $colorString, error: $e');
    }

    // Return a default color if parsing fails
    return Colors.grey;
  }

  String _getColorName(String colorString) {
    // First, check if colorString itself is already a color name rather than a hex code
    if (!colorString.startsWith('#')) {
      return colorString; // If it's already a name like "Red", just return it
    }

    // Map of common hex codes to color names
    final colorMap = {
      '#ff0000': 'Red',
      '#00ff00': 'Green',
      '#0000ff': 'Blue',
      '#ffff00': 'Yellow',
      '#ff00ff': 'Magenta',
      '#00ffff': 'Cyan',
      '#000000': 'Black',
      '#ffffff': 'White',
      '#808080': 'Gray',
      '#ffa500': 'Orange',
      '#800080': 'Purple',
      '#008000': 'Dark Green',
      '#800000': 'Maroon',
      '#000080': 'Navy',
      '#ffc0cb': 'Pink',
      '#a52a2a': 'Brown',
    };

    // Try to find the exact match
    final normalizedColor = colorString.toLowerCase();
    if (colorMap.containsKey(normalizedColor)) {
      return colorMap[normalizedColor]!;
    }

    // If no exact match, return a formatted version of the hex code
    return 'Color #${colorString.substring(1).toUpperCase()}';
  }
}

class QuantityControls extends StatelessWidget {
  final int quantity;
  final int index;
  final WidgetRef ref;

  const QuantityControls({
    required this.quantity,
    required this.index,
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconButton(
          icon: Icons.remove,
          onPressed:
              () => ref
                  .read(cartProvider.notifier)
                  .updateItemQuantity(index, quantity - 1),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$quantity',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        _IconButton(
          icon: Icons.add,
          onPressed:
              () => ref
                  .read(cartProvider.notifier)
                  .updateItemQuantity(index, quantity + 1),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

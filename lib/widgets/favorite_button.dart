import 'package:e_commerce_project/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteButton extends ConsumerWidget {
  final String productId;
  final String title;
  final String categoryId;
  final double price;
  final double? discountedPrice;
  final String? imageUrl;
  final double? size;
  final Color? iconColor;
  final bool showLabel;
  final bool isProductPage;

  const FavoriteButton({
    required this.productId,
    required this.title,
    required this.categoryId,
    required this.price,
    this.discountedPrice,
    this.imageUrl,
    this.size,
    this.iconColor,
    this.showLabel = false,
    this.isProductPage = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isProductFavoriteProvider(productId));

    if (isProductPage) {
      // Modern animated favorite button for product page
      return GestureDetector(
        onTap: () => _toggleFavorite(context, ref, isFavorite),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFavorite 
                ? Colors.red.withOpacity(0.9) 
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isFavorite 
                    ? Colors.red.withOpacity(0.4) 
                    : Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.white : Colors.grey.shade800,
                size: 26,
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: 0),
                secondChild: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      isFavorite ? 'Saved' : 'Save',
                      style: TextStyle(
                        color: isFavorite ? Colors.white : Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                crossFadeState: showLabel 
                    ? CrossFadeState.showSecond 
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      );
    }

    // Standard favorite button for product cards
    return InkWell(
      onTap: () => _toggleFavorite(context, ref, isFavorite),
      borderRadius: BorderRadius.circular(20),
      child: showLabel
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isFavorite ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavorite ? Colors.red : iconColor ?? Colors.grey,
                  ),
                  if (showLabel) const SizedBox(width: 4),
                  if (showLabel)
                    Text(
                      isFavorite ? 'Remove' : 'Favorite',
                      style: TextStyle(
                        fontSize: 12,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFavorite ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: size ?? 24,
                color: isFavorite ? Colors.red : iconColor ?? Colors.grey,
              ),
            ),
    );
  }

  void _toggleFavorite(BuildContext context, WidgetRef ref, bool isFavorite) {
    ref.read(favoritesProvider.notifier).toggleFavorite(
          productId: productId,
          title: title,
          categoryId: categoryId,
          price: price,
          discountedPrice: discountedPrice,
          imageUrl: imageUrl ?? 
            'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F$categoryId.jpg?alt=media',
        );

    // Show a snackbar confirmation
    final message = isFavorite
        ? '$title removed from favorites'
        : '$title added to favorites';
        
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: isFavorite
            ? SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(
                        productId: productId,
                        title: title,
                        categoryId: categoryId,
                        price: price,
                        discountedPrice: discountedPrice,
                        imageUrl: imageUrl,
                      );
                },
              )
            : null,
      ),
    );
  }
}
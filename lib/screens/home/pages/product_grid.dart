import 'package:e_commerce_project/models/product.dart';
import 'package:e_commerce_project/providers/top_selling_product_provider.dart';
import 'package:e_commerce_project/screens/home/pages/product_page.dart';
import 'package:e_commerce_project/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductGridScreen extends ConsumerStatefulWidget {
  final String title;
  const ProductGridScreen({super.key, required this.title});

  @override
  ConsumerState<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends ConsumerState<ProductGridScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(categoryProductProvider.notifier)
          .setProductsByCategory(widget.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(categoryProductProvider);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(

      appBar: AppBar(title: Text('${widget.title} (${products.length})')),
      body:
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isPortrait ?2:3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: isPortrait?0.68:1,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _productCard(context, product);
                  },
                ),
              ),
    );
  }

  Widget _productCard(BuildContext context, Product product) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      onTap:  () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductPage(product: product),
            ),
          ),
      child: Ink(
        padding: const EdgeInsets.all(8),
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
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${product.categoryId}.jpg?alt=media',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: FavoriteButton(
                    productId: product.productId,
                    title: product.title,
                    categoryId: product.categoryId,
                    // Remove the color parameter as it's not defined in FavoriteButton
                    price: product.price,
                    discountedPrice: product.discountedPrice,
                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/ecommerce-project-e9ff5.firebasestorage.app/o/images%2F${product.categoryId}.jpg?alt=media',
                    size: 20,
                    iconColor: Colors.white,
                  ),
                ),
              ],
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

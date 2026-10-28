import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/product_image.dart';
import '../../cart/views/cart_screen.dart';
import '../../product_details/views/product_details_screen.dart';
import '../viewmodels/favorites_cubit.dart';
import '../viewmodels/favorites_state.dart';

/// Shows the products the user marked as favorite. The list comes from the
/// shared [FavoritesCubit], so it updates by itself when a favorite is added
/// or removed anywhere in the app.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const _bg = Color(0xFFF5EEE8);
  static const _dark = Color(0xFF5C453D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _dark,
        title: const Text(
          'Favorites',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            final favorites = state.items;

            if (favorites.isEmpty) return _buildEmpty(context);

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (_, i) {
                final product = favorites[i];

                return _FavoriteCard(
                  // Keyed by product id so removing one card never makes
                  // another card reuse its state.
                  key: ValueKey(product.id),
                  product: product,
                  onTap: () => ProductDetailsScreen.open(context, product),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            'No favorites yet',
            style: TextStyle(fontSize: 16, color: _dark),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap the heart on a product to save it here.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _dark,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _FavoriteCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ProductImage(product.image),
                    ),
                  ),
                  // Filled heart: tapping removes it from favorites without
                  // opening the details.
                  Positioned(
                    top: 4,
                    right: 4,
                    child: FavoriteButton(product: product),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              CartScreen.money(product.price),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

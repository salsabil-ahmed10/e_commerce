import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../../../core/routes/app_routes.dart';
import '../../cart/viewmodels/cart_cubit.dart';
import '../../cart/viewmodels/cart_state.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/product_image.dart';
import '../../cart/views/cart_screen.dart';
import '../../product_details/views/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Product> products;

  /// Switches the main shell to the Cart tab.
  final VoidCallback onOpenCart;

  const HomeScreen({
    super.key,
    required this.products,
    required this.onOpenCart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _bg = Color(0xFFF5EEE8);
  static const _dark = Color(0xFF5C453D);
  static const _brown = Color(0xFF8B5E52);

  void _addToCart(Product product) {
    context.read<CartCubit>().addToCart(product);


    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _openCart() => widget.onOpenCart();

  void _openFavorites() => Navigator.pushNamed(context, AppRoutes.favorites);

  void _openOffers() => Navigator.pushNamed(context, AppRoutes.offers);

void _openDetails(Product product) {
  debugPrint('Product name: ${product.name}');
  debugPrint('API Product ID: ${product.apiProductId}');

  ProductDetailsScreen.open(context, product);
}
  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: _bg,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 12),

              _buildSearch(),

              const SizedBox(height: 16),

              _buildBanner(),

              const SizedBox(height: 20),

              _buildSectionTitle(),

              const SizedBox(height: 12),

              _buildGrid(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Header
  // =========================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'rhode',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            color: Color.fromARGB(255, 77, 58, 51),
          ),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _openFavorites,
              icon: const Icon(
                Icons.favorite_border,
                size: 28,
                color: _dark,
              ),
            ),
            IconButton(
              onPressed: _openOffers,
              icon: const Icon(
                Icons.local_offer_outlined,
                size: 28,
                color: _dark,
              ),
            ),

        // Cart icon + number
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final count = state.itemCount;

            return IconButton(
              onPressed: _openCart,
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                backgroundColor: _brown,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                  color: _dark,
                ),
              ),
            );
          },
        ),
          ],
        ),
      ],
    );
  }

  // =========================
  // Search
  // =========================

  Widget _buildSearch() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),

        filled: true,
        fillColor: const Color(0xFFE6DAD2),

        contentPadding: const EdgeInsets.symmetric(vertical: 0),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // =========================
  // Banner
  // =========================

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),

      child: AspectRatio(
        // Banner عريض
        aspectRatio: 16 / 9,

        child: Image.asset(
          'assets/images/rhode_landscape_v3.png',

          width: double.infinity,

          // الصورة هتملى العرض بشكل طبيعي
          fit: BoxFit.cover,

          alignment: Alignment.center,

          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: ProductImage.tint,
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFFB9A79D),
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  // Section Title

  Widget _buildSectionTitle() {
    return const Text(
      'Our Favorites',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _dark),
    );
  }

  // Products Grid

  Widget _buildGrid() {
    // Only the local rhode products are shown on Home.
    final all = widget.products;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: all.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final product = all[index];

        return _ProductCard(
          product: product,
          onTap: () => _openDetails(product),
          onAdd: () => _addToCart(product),
        );
      },
    );
  }
}

// Product Card
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

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
          // Product Image + favorite heart
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProductImage(product.image),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: FavoriteButton(product: product),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Product Name
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 2),

          // Price
          Text(
            CartScreen.money(product.price),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 5),

          // Add To Cart
          SizedBox(
            width: double.infinity,
            height: 30,

            child: ElevatedButton(
              onPressed: onAdd,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5E52),
                foregroundColor: Colors.white,

                elevation: 0,

                padding: EdgeInsets.zero,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

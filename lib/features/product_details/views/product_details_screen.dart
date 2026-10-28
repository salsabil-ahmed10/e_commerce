import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/product_image.dart';
import '../../cart/viewmodels/cart_cubit.dart';
import '../../cart/views/cart_screen.dart';
import '../data/product_details_repository.dart';
import '../models/product_details.dart';
import '../viewmodels/product_details_cubit.dart';
import '../viewmodels/product_details_state.dart';

/// Entry point: creates the Cubit, loads the data, and hands it to the view.
///
/// It receives the [Product] the user tapped, so it always shows that same
/// product: API-backed products are loaded from DummyJSON by their own
/// `apiProductId`; local products are shown from their own data and never
/// call the API.
class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  /// Opens the details of [product]. Used by Home and Favorites.
  static void open(BuildContext context, Product product) {
    Navigator.pushNamed(context, AppRoutes.productDetails, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ProductDetailsCubit(ProductDetailsRepository());
        final apiId = product.apiProductId;

        if (apiId != null) {
          cubit.loadProduct(apiId);
        } else {
          cubit.showLocal(product);
        }
        return cubit;
      },
      child: _ProductDetailsView(product: product),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final Product product;

  const _ProductDetailsView({required this.product});

  static const _bg = Color(0xFFF5EEE8);
  static const _dark = Color(0xFF5C453D);
  static const _brown = Color(0xFF8B5E52);

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
          'Product Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          // Uses the tapped product, so the heart works even while the
          // details are loading or if loading fails.
          FavoriteButton(product: product, onImage: false),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            switch (state.status) {
              case ProductDetailsStatus.initial:
              case ProductDetailsStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(color: _brown),
                );

              case ProductDetailsStatus.failure:
                return _buildError(context, state.errorMessage);

              case ProductDetailsStatus.success:
                return _buildContent(context, state);
            }
          },
        ),
      ),
    );
  }

  // =========================
  // Error
  // =========================

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: _dark),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final apiId = product.apiProductId;
                if (apiId != null) {
                  context.read<ProductDetailsCubit>().loadProduct(apiId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _dark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Success
  // =========================

  Widget _buildContent(BuildContext context, ProductDetailsState state) {
    final details = state.product!;

    // Thumbnail first (the image Home/Favorites show), then the other
    // images. Local products simply have a single image.
    final images = details.gallery;
    final selected = images.isEmpty
        ? 0
        : state.selectedImageIndex.clamp(0, images.length - 1).toInt();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainImage(images.isEmpty ? '' : images[selected]),

                // Thumbnails only make sense when there is more than one image.
                if (images.length > 1) ...[
                  const SizedBox(height: 12),
                  _buildThumbnails(context, images, selected),
                ],

                const SizedBox(height: 16),
                _buildInfo(details),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        _buildAddToCart(context, details),
      ],
    );
  }

  Widget _buildMainImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: AspectRatio(
        aspectRatio: 1,
        child: SizedBox(
          width: double.infinity,
          // The key makes Flutter treat each URL as a new widget,
          // so the image reloads when another thumbnail is selected.
          child: ProductImage(url, key: ValueKey(url)),
        ),
      ),
    );
  }

  Widget _buildThumbnails(
    BuildContext context,
    List<String> images,
    int selected,
  ) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isSelected = i == selected;

          return GestureDetector(
            onTap: () => context.read<ProductDetailsCubit>().selectImage(i),
            child: Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _brown : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: ProductImage(images[i], width: 56, height: 56),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(ProductDetails product) {
    final subtitle = [
      if (product.brand != null) product.brand!,
      if (product.category != null) product.category!,
    ].join(' • ');
    final rating = product.rating;
    final stock = product.stock;
    final discount = product.discountPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _dark,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: _brown),
          ),
        ],

        // Rating + stock (only products that have them, i.e. API products)
        if (rating != null || stock != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              if (rating != null) ...[
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              if (stock != null)
                Text(
                  stock > 0 ? '$stock in stock' : 'Out of stock',
                  style: const TextStyle(fontSize: 13, color: _dark),
                ),
            ],
          ),
        ],
        const SizedBox(height: 12),

        // Price + discount badge
        Row(
          children: [
            Text(
              CartScreen.money(product.price),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
            if (discount != null && discount > 0) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _brown,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${discount.toStringAsFixed(0)}% OFF',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (product.description.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _dark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product.description,
            style: const TextStyle(fontSize: 14, height: 1.4, color: _dark),
          ),
        ],
      ],
    );
  }

  // =========================
  // Add to cart
  // =========================

  Widget _buildAddToCart(BuildContext context, ProductDetails product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            // The cart works with the core `Product` model, so convert.
            // `toProduct()` keeps the same id as Home ('api_<n>' for API
            // products, '1'..'6' for local ones), so the same item is never
            // split into two cart lines.
            context.read<CartCubit>().addToCart(product.toProduct());

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('${product.title} added to cart'),
                  duration: const Duration(seconds: 1),
                ),
              );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _dark,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/widgets/product_image.dart';
import '../../cart/views/cart_screen.dart';
import '../../home/data/products.dart';

/// UI only: static offer banners and a list of discounted products.
/// The discounts here are sample values, not real business logic.
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _bg = Color(0xFFF5EEE8);
  static const _dark = Color(0xFF5C453D);
  static const _brown = Color(0xFF8B5E52);

  // (title, subtitle) pairs for the banners.
  static const _banners = [
    ('Super Sale', 'Up to 30% off selected products'),
    ('Free Shipping', 'On all orders over \$50'),
  ];

  @override
  Widget build(BuildContext context) {
    // Sample data: the first three local products with a fake 20% discount.
    final offers = products.take(3).toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _dark,
        title: const Text(
          'Offers',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            for (final b in _banners) ...[
              _buildBanner(b.$1, b.$2),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            const Text(
              'Special Deals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _dark,
              ),
            ),
            const SizedBox(height: 12),
            for (final p in offers) ...[
              _buildDealRow(p.image, p.name, p.price),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDealRow(String image, String name, double price) {
    final discounted = price * 0.8;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ProductImage(image, width: 80, height: 80),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      CartScreen.money(discounted),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      CartScreen.money(price),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _brown,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '20% OFF',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

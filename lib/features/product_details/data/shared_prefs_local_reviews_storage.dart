import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_review.dart';
import 'local_reviews_storage.dart';

/// Saves the user's reviews of local products with `shared_preferences`.
/// One entry per product: `local_product_reviews_<productId>` -> [...].
///
/// The prefix differs from the API cache (`product_reviews_<apiId>`), so the
/// two kinds of reviews can never overwrite each other.
class SharedPrefsLocalReviewsStorage implements LocalReviewsStorage {
  static const _prefix = 'local_product_reviews_';

  @override
  Future<List<ProductReview>> read(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$productId');
    if (raw == null) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .map(ProductReview.tryFromJson)
          .whereType<ProductReview>()
          .toList();
    } catch (_) {
      // A corrupted entry is treated as "no reviews".
      return const [];
    }
  }

  @override
  Future<void> write(String productId, List<ProductReview> reviews) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix$productId',
      jsonEncode(reviews.map((r) => r.toJson()).toList()),
    );
  }
}

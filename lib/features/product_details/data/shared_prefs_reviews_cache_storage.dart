import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_review.dart';
import 'reviews_cache_storage.dart';

/// Saves reviews on the device with `shared_preferences`, the same package
/// the favorites already use. One entry per product:
/// `product_reviews_<apiProductId>` -> {"savedAt": iso, "reviews": [...]}.
class SharedPrefsReviewsCacheStorage implements ReviewsCacheStorage {
  static const _prefix = 'product_reviews_';

  @override
  Future<CachedReviews?> read(int apiProductId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$apiProductId');
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;

      final savedAt = DateTime.tryParse('${decoded['savedAt']}');
      final list = decoded['reviews'];
      if (savedAt == null || list is! List) return null;

      return CachedReviews(
        savedAt: savedAt,
        reviews:
            list.map(ProductReview.tryFromJson).whereType<ProductReview>().toList(),
      );
    } catch (_) {
      // A corrupted entry is treated as "nothing cached".
      return null;
    }
  }

  @override
  Future<void> write(int apiProductId, List<ProductReview> reviews) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix$apiProductId',
      jsonEncode({
        'savedAt': DateTime.now().toIso8601String(),
        'reviews': reviews.map((r) => r.toJson()).toList(),
      }),
    );
  }
}

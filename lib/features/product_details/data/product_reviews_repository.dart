import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_review.dart';
import 'reviews_cache_storage.dart';

/// Loads the reviews of an API product.
///
/// DummyJSON has no separate reviews endpoint: the reviews are the `reviews`
/// list inside the product response (GET https://dummyjson.com/products/{id}),
/// the same endpoint [ProductDetailsRepository] uses.
class ProductReviewsRepository {
  final ReviewsCacheStorage cache;
  final http.Client? _client;
  


ProductReviewsRepository(this.cache, {this._client});

  /// What was saved last time, or null. Never throws.
  Future<CachedReviews?> readCache(int id) async {
    try {
      return await cache.read(id);
    } catch (_) {
      return null;
    }
  }

  /// Fetches the reviews from the API and saves them in the cache.
  /// Throws `Exception('<message>')` on failure, like the other repositories.
  Future<List<ProductReview>> fetchReviews(int id) async {
    final uri = Uri.parse('https://dummyjson.com/products/$id');
    final response = await (_client?.get(uri) ?? http.get(uri))
        .timeout(const Duration(seconds: 15));

    Object? data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    if (response.statusCode != 200 || data is! Map) {
      final message = data is Map ? data['message'] : null;
      throw Exception(message ?? 'Failed to load reviews');
    }

    // A product without a `reviews` list is treated as having no reviews.
    final raw = data['reviews'];
    final reviews = raw is List
        ? raw.map(ProductReview.tryFromJson).whereType<ProductReview>().toList()
        : <ProductReview>[];

    // A failing cache write must not hide reviews that loaded fine.
    try {
      await cache.write(id, reviews);
    } catch (_) {}

    return reviews;
  }
}

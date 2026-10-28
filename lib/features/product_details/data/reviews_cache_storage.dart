import '../models/product_review.dart';

/// Reviews of one product as they were saved, and when.
class CachedReviews {
  final List<ProductReview> reviews;
  final DateTime savedAt;

  const CachedReviews({required this.reviews, required this.savedAt});
}

/// Where reviews are kept between visits to a product (and app launches).
abstract class ReviewsCacheStorage {
  Future<CachedReviews?> read(int apiProductId);
  Future<void> write(int apiProductId, List<ProductReview> reviews);
}

/// Keeps reviews only while the app is running (useful for tests).
class InMemoryReviewsCacheStorage implements ReviewsCacheStorage {
  final Map<int, CachedReviews> _saved = {};

  @override
  Future<CachedReviews?> read(int apiProductId) async => _saved[apiProductId];

  @override
  Future<void> write(int apiProductId, List<ProductReview> reviews) async {
    _saved[apiProductId] =
        CachedReviews(reviews: List.of(reviews), savedAt: DateTime.now());
  }
}

import '../models/product_review.dart';

/// Where reviews written by the user for LOCAL products are kept.
///
/// Keyed by the local `Product.id` ('1'..'6'), never by a DummyJSON id, so a
/// local product can never show reviews that belong to an API product.
abstract class LocalReviewsStorage {
  Future<List<ProductReview>> read(String productId);
  Future<void> write(String productId, List<ProductReview> reviews);
}

/// Keeps reviews only while the app is running (useful for tests).
class InMemoryLocalReviewsStorage implements LocalReviewsStorage {
  final Map<String, List<ProductReview>> _saved = {};

  @override
  Future<List<ProductReview>> read(String productId) async =>
      List.of(_saved[productId] ?? const <ProductReview>[]);

  @override
  Future<void> write(String productId, List<ProductReview> reviews) async {
    _saved[productId] = List.of(reviews);
  }
}

import '../models/product_review.dart';

enum ProductReviewsStatus {
  initial,
  loading,
  success,
  empty,
  failure,
}

class ProductReviewsState {
  final ProductReviewsStatus status;
  final List<ProductReview> reviews;

  /// True when [reviews] come from the saved copy, not from this visit's
  /// request (yet, or because the request failed).
  final bool isFromCache;

  /// True while a request runs in the background behind cached [reviews].
  final bool isRefreshing;

  /// When the cached [reviews] were saved (only set when [isFromCache]).
  final DateTime? cachedAt;

  /// Failure message. With [ProductReviewsStatus.failure] there is nothing to
  /// show; with cached reviews it explains why they could not be refreshed.
  final String? errorMessage;

  const ProductReviewsState({
    this.status = ProductReviewsStatus.initial,
    this.reviews = const [],
    this.isFromCache = false,
    this.isRefreshing = false,
    this.cachedAt,
    this.errorMessage,
  });
}

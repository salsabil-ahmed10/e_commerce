import '../models/product_review.dart';

/// Sample reviews shown for the local rhode products from the first visit,
/// keyed by the local `Product.id`. Replace them with your real reviews.
///
/// Reviews the user writes are stored separately and shown above these.
final Map<String, List<ProductReview>> localSeedReviews = {
  '1': [
    ProductReview(rating: 5, comment: 'Leaves my skin soft and glowing all day.', reviewerName: 'Sara', date: DateTime(2026, 9, 12)),
    ProductReview(rating: 4, comment: 'Lovely texture, absorbs fast.', reviewerName: 'Mona', date: DateTime(2026, 9, 20)),
  ],
  '2': [
    ProductReview(rating: 5, comment: 'Gives my lips a perfect shape and finish.', reviewerName: 'Nour', date: DateTime(2026, 9, 8)),
    ProductReview(rating: 4, comment: 'Very comfortable, not sticky.', reviewerName: 'Heba', date: DateTime(2026, 9, 25)),
  ],
  '3': [
    ProductReview(rating: 5, comment: 'Such a natural flush, and so easy to carry.', reviewerName: 'Salma', date: DateTime(2026, 9, 15)),
    ProductReview(rating: 4, comment: 'Blends beautifully.', reviewerName: 'Yasmin', date: DateTime(2026, 10, 2)),
  ],
  '4': [
    ProductReview(rating: 5, comment: 'My skin looks glazed and hydrated.', reviewerName: 'Dina', date: DateTime(2026, 9, 5)),
    ProductReview(rating: 5, comment: 'Worth it, I use it every morning.', reviewerName: 'Rana', date: DateTime(2026, 10, 1)),
  ],
  '5': [
    ProductReview(rating: 4, comment: 'Cute and keeps my lip product safe.', reviewerName: 'Farida', date: DateTime(2026, 9, 18)),
    ProductReview(rating: 5, comment: 'Looks great in my bag.', reviewerName: 'Laila', date: DateTime(2026, 10, 6)),
  ],
  '6': [
    ProductReview(rating: 4, comment: 'Refreshes tired eyes in the morning.', reviewerName: 'Mariam', date: DateTime(2026, 9, 10)),
    ProductReview(rating: 5, comment: 'Gentle and cooling.', reviewerName: 'Aya', date: DateTime(2026, 9, 28)),
  ],
};

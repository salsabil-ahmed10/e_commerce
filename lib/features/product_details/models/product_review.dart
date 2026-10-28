/// One customer review of a product.
///
/// Built from an entry of the `reviews` list in
/// GET https://dummyjson.com/products/{id}. The reviewer's e-mail that the
/// API also sends is deliberately not kept: the screen never shows it.
class ProductReview {
  /// 1..5
  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime? date;

  const ProductReview({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        'reviewerName': reviewerName,
        'date': date?.toIso8601String(),
      };

  /// Returns null instead of throwing when the data is malformed, so one bad
  /// entry (in the response or in the saved cache) is skipped, not fatal.
  static ProductReview? tryFromJson(Object? json) {
    if (json is! Map) return null;

    final rating = json['rating'];
    if (rating is! num) return null;

    final comment = json['comment'];
    final name = json['reviewerName'];
    final date = json['date'];

    return ProductReview(
      rating: rating.round().clamp(1, 5).toInt(),
      comment: comment is String ? comment : '',
      reviewerName: name is String && name.isNotEmpty ? name : 'Anonymous',
      date: date is String ? DateTime.tryParse(date) : null,
    );
  }
}

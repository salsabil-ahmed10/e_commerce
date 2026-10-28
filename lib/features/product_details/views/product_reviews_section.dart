import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../models/product_review.dart';
import '../viewmodels/product_reviews_cubit.dart';
import '../viewmodels/product_reviews_state.dart';

/// "Reviews" block of the Product Details screen.
/// Needs a [ProductReviewsCubit] above it.
///
///  * API products show the DummyJSON reviews (retry reloads from the API).
///  * Local products show the reviews the user wrote for that product, an
///    empty state when there are none, and a "Write a review" button.
class ProductReviewsSection extends StatelessWidget {
  final Product product;

  const ProductReviewsSection({super.key, required this.product});

  bool get _isLocal => !product.isApiProduct;
  static const _dark = Color(0xFF5C453D);
static const _brown = Color(0xFF8B5E52);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReviewsCubit, ProductReviewsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(state),
            const SizedBox(height: 10),
            if (_isLocal) ...[
              _writeReviewButton(context),
              const SizedBox(height: 10),
            ],
            ..._body(context, state),
          ],
        );
      },
    );
  }

  Widget _header(ProductReviewsState state) {
    final count = state.reviews.length;

    return Row(
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 8),
          Text(
            '($count)',
            style: const TextStyle(fontSize: 13, color: _brown),
          ),
        ],
        const Spacer(),
        if (state.isRefreshing)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: _brown),
          ),
      ],
    );
  }

  Widget _writeReviewButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () => _writeReview(context),
        icon: const Icon(Icons.rate_review_outlined, size: 18),
        label: const Text('Write a review'),
        style: OutlinedButton.styleFrom(
          foregroundColor: _brown,
          side: const BorderSide(color: _brown),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _writeReview(BuildContext context) async {
    final cubit = context.read<ProductReviewsCubit>();

    final review = await showModalBottomSheet<ProductReview>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5EEE8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ReviewForm(),
    );

    if (review != null) {
      await cubit.addLocalReview(product.id, review);
    }
  }

  List<Widget> _body(BuildContext context, ProductReviewsState state) {
    switch (state.status) {
      case ProductReviewsStatus.initial:
      case ProductReviewsStatus.loading:
        return const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(color: _brown)),
          ),
        ];

      case ProductReviewsStatus.failure:
        return [
          const Icon(Icons.error_outline, size: 32, color: Colors.grey),
          const SizedBox(height: 6),
          Text(
            state.errorMessage ?? 'Could not load reviews',
            style: const TextStyle(fontSize: 14, color: _dark),
          ),
          TextButton(
            onPressed: () => _reload(context),
            style: TextButton.styleFrom(foregroundColor: _brown),
            child: const Text('Try Again'),
          ),
        ];

      case ProductReviewsStatus.empty:
        return [
          ..._notice(context, state),
          Text(
            _isLocal
                ? 'No reviews yet. Be the first to review this product.'
                : 'No reviews yet.',
            style: const TextStyle(fontSize: 14, color: _dark),
          ),
        ];

      case ProductReviewsStatus.success:
        return [
          ..._notice(context, state),
          for (final review in state.reviews) _ReviewTile(review: review),
        ];
    }
  }

  /// Shown above saved reviews: that they are saved ones, and (if the refresh
  /// failed) why they may be out of date.
  List<Widget> _notice(BuildContext context, ProductReviewsState state) {
    if (!state.isFromCache) return const [];

    final failed = state.errorMessage != null;
    final text = failed
        ? 'Showing saved reviews. Could not refresh: ${state.errorMessage}'
        : 'Showing saved reviews.';

    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 12, color: _brown),
              ),
            ),
            if (failed)
              TextButton(
                onPressed: () => _reload(context),
                style: TextButton.styleFrom(foregroundColor: _brown),
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    ];
  }

  void _reload(BuildContext context) {
    // Only API reviews can fail to load or be refreshed.
    final apiId = product.apiProductId;
    if (apiId == null) return;
    context.read<ProductReviewsCubit>().load(apiId, forceRefresh: true);
  }
}

/// Bottom sheet where the user rates and comments on a local product.
/// Pops with a [ProductReview], or null when cancelled.
class _ReviewForm extends StatefulWidget {
  const _ReviewForm();

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  static const _dark = Color(0xFF5C453D);

  final _name = TextEditingController();
  final _comment = TextEditingController();
  int _rating = 0;
  bool _showRatingError = false;

  @override
  void dispose() {
    _name.dispose();
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      setState(() => _showRatingError = true);
      return;
    }

    final name = _name.text.trim();
    Navigator.pop(
      context,
      ProductReview(
        rating: _rating,
        comment: _comment.text.trim(),
        reviewerName: name.isEmpty ? 'Anonymous' : name,
        date: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Keeps the form above the keyboard.
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Write a review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _dark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => setState(() {
                      _rating = i;
                      _showRatingError = false;
                    }),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      i <= _rating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: Colors.amber,
                    ),
                  ),
              ],
            ),
            if (_showRatingError)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Please choose a rating.',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Your name (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _comment,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Your review (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Submit review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;

  const _ReviewTile({required this.review});

  static const _dark = Color(0xFF5C453D);
  static const _brown = Color(0xFF8B5E52);

  @override
  Widget build(BuildContext context) {
    final date = review.date;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
              ),
              if (date != null)
                Text(
                  _formatDate(date),
                  style: const TextStyle(fontSize: 11, color: _brown),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.amber,
                ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: const TextStyle(fontSize: 14, height: 1.4, color: _dark),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    final local = d.toLocal();
    final mm = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    return '${local.year}-$mm-$dd';
  }
}

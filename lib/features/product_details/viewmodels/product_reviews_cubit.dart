import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/local_product_reviews.dart';
import '../data/local_reviews_storage.dart';
import '../data/product_reviews_repository.dart';
import '../models/product_review.dart';
import 'product_reviews_state.dart';

/// Reviews of one product.
///
/// API products ([load]): reviews come from DummyJSON, with a saved copy on
/// the device. Local products ([loadLocal] / [addLocalReview]): reviews are
/// the ones the user wrote, kept per local product id. The two never mix.
///
/// For API products:
///  * Saved copy younger than [cacheTtl]  -> shown, no request.
///  * Saved copy older                    -> shown at once, refreshed behind it.
///  * No saved copy                       -> loading, then the API result.
///  * Request fails                       -> saved copy stays (with a notice),
///                                           or an error if there is none.
class ProductReviewsCubit extends Cubit<ProductReviewsState> {
  static const cacheTtl = Duration(minutes: 10);

  final ProductReviewsRepository repository;

  /// Storage for local products' reviews. Not used by API products.
  final LocalReviewsStorage localStorage;

  ProductReviewsCubit(
    this.repository, {
    LocalReviewsStorage? localStorage,
  })  : localStorage = localStorage ?? InMemoryLocalReviewsStorage(),
        super(const ProductReviewsState());

  /// Reviews the user wrote for the current LOCAL product (saved).
  List<ProductReview> _userReviews = const [];

  /// Loads the reviews of a LOCAL product: the user's own reviews first, then
  /// the sample reviews from [localSeedReviews]. Never calls the API.
  Future<void> loadLocal(String productId) async {
    emit(const ProductReviewsState(status: ProductReviewsStatus.loading));

    try {
      _userReviews = await localStorage.read(productId);
    } catch (_) {
      _userReviews = const [];
    }
    if (isClosed) return;

    emit(_forReviews(_localAll(productId)));
  }

  /// Adds a review (newest first) to a LOCAL product and saves it.
  /// Only the user's reviews are saved, not the sample ones.
  Future<void> addLocalReview(String productId, ProductReview review) async {
    _userReviews = [review, ..._userReviews];
    emit(_forReviews(_localAll(productId)));

    try {
      await localStorage.write(productId, _userReviews);
    } catch (_) {
      // Failing to save must never break the UI; the review stays visible
      // for this session.
    }
  }

  List<ProductReview> _localAll(String productId) =>
      [..._userReviews, ...?localSeedReviews[productId]];

  Future<void> load(int apiProductId, {bool forceRefresh = false}) async {
    final cached = await repository.readCache(apiProductId);
    if (isClosed) return;

    if (cached != null) {
      final isFresh = DateTime.now().difference(cached.savedAt) < cacheTtl;
      final needsRequest = forceRefresh || !isFresh;

      emit(_forReviews(
        cached.reviews,
        isFromCache: true,
        isRefreshing: needsRequest,
        cachedAt: cached.savedAt,
      ));
      if (!needsRequest) return;
    } else {
      emit(const ProductReviewsState(status: ProductReviewsStatus.loading));
    }

    try {
      final reviews = await repository.fetchReviews(apiProductId);
      if (isClosed) return;
      emit(_forReviews(reviews));
    } catch (e) {
      if (isClosed) return;

      final text = e.toString();
      final message = text.startsWith('Exception: ')
          ? text.replaceFirst('Exception: ', '')
          : 'Could not load reviews. Check your internet connection.';

      if (cached != null) {
        emit(_forReviews(
          cached.reviews,
          isFromCache: true,
          cachedAt: cached.savedAt,
          errorMessage: message,
        ));
      } else {
        emit(ProductReviewsState(
          status: ProductReviewsStatus.failure,
          errorMessage: message,
        ));
      }
    }
  }

  ProductReviewsState _forReviews(
    List<ProductReview> reviews, {
    bool isFromCache = false,
    bool isRefreshing = false,
    DateTime? cachedAt,
    String? errorMessage,
  }) {
    return ProductReviewsState(
      status: reviews.isEmpty
          ? ProductReviewsStatus.empty
          : ProductReviewsStatus.success,
      reviews: reviews,
      isFromCache: isFromCache,
      isRefreshing: isRefreshing,
      cachedAt: cachedAt,
      errorMessage: errorMessage,
    );
  }
}

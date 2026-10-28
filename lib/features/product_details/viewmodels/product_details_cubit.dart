import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../data/product_details_repository.dart';
import '../models/product_details.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepository repository;

  ProductDetailsCubit(this.repository) : super(const ProductDetailsState());

  Future<void> loadProduct(int id) async {
    emit(const ProductDetailsState(status: ProductDetailsStatus.loading));

    try {
      final product = await repository.getProductDetails(id);

      // The user may have left the screen while we were waiting.
      if (isClosed) return;

      emit(
        ProductDetailsState(
          status: ProductDetailsStatus.success,
          product: product,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      // Our repository throws Exception('<server message>').
      // Anything else (no internet, bad JSON...) gets a friendly message.
      final text = e.toString();
      final message = text.startsWith('Exception: ')
          ? text.replaceFirst('Exception: ', '')
          : 'Could not load the product. Check your internet connection.';

      emit(
        ProductDetailsState(
          status: ProductDetailsStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }

  /// Local products have no API data: show exactly what Home shows.
  /// (Never call the API for them, ids like '1' would match an unrelated
  /// DummyJSON product.)
  void showLocal(Product product) {
    emit(
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: ProductDetails.fromProduct(product),
      ),
    );
  }

  /// Tapping a thumbnail changes which image is the main one.
  void selectImage(int index) {
    final count = state.product?.gallery.length ?? 0;
    if (index < 0 || index >= count) return;

    emit(state.copyWith(selectedImageIndex: index));
  }
}

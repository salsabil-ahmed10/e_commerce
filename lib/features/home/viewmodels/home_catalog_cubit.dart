import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../../product_details/data/product_details_repository.dart';
import '../data/products.dart';
import 'home_catalog_state.dart';

/// Loads the API-backed Home products through the existing
/// [ProductDetailsRepository], and maps them with `toProduct()`, the same
/// mapping the details screen uses. That is what keeps the Home card and
/// the details screen showing the same item and the same image.
class HomeCatalogCubit extends Cubit<HomeCatalogState> {
  final ProductDetailsRepository repository;

  HomeCatalogCubit(this.repository) : super(const HomeCatalogState());

  Future<void> load() async {
    emit(
      HomeCatalogState(
        status: HomeCatalogStatus.loading,
        apiProducts: state.apiProducts,
      ),
    );

    // Each id is loaded independently so one failure doesn't hide the rest.
    final results = await Future.wait(
      apiHomeProductIds.map((id) async {
        try {
          return (await repository.getProductDetails(id)).toProduct();
        } catch (_) {
          return null;
        }
      }),
    );

    if (isClosed) return;

    final loaded = results.whereType<Product>().toList();

    emit(
      HomeCatalogState(
        status: loaded.length == apiHomeProductIds.length
            ? HomeCatalogStatus.success
            : HomeCatalogStatus.failure,
        apiProducts: loaded,
      ),
    );
  }
}

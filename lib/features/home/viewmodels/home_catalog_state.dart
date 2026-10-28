import '../../../core/models/product.dart';

enum HomeCatalogStatus { initial, loading, success, failure }

/// API-backed products shown on Home after the local ones.
class HomeCatalogState {
  final HomeCatalogStatus status;
  final List<Product> apiProducts;

  const HomeCatalogState({
    this.status = HomeCatalogStatus.initial,
    this.apiProducts = const [],
  });
}

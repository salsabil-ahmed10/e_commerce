import '../../../core/models/product.dart';

class FavoritesState {
  /// Favorite products, in the order they were added. Never has two
  /// products with the same id.
  final List<Product> items;

  const FavoritesState({this.items = const []});

  bool isFavorite(String productId) =>
      items.any((product) => product.id == productId);
}

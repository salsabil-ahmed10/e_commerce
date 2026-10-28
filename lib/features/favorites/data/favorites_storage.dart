import '../../../core/models/product.dart';

/// Where favorites are saved between app launches.
abstract class FavoritesStorage {
  Future<List<Product>> load();
  Future<void> save(List<Product> products);
}

/// Keeps favorites only while the app is running (useful for tests, or if
/// persistence is not wanted).
class InMemoryFavoritesStorage implements FavoritesStorage {
  List<Product> _saved = const [];

  @override
  Future<List<Product>> load() async => _saved;

  @override
  Future<void> save(List<Product> products) async {
    _saved = List<Product>.of(products);
  }
}

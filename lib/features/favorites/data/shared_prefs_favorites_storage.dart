import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/product.dart';
import 'favorites_storage.dart';

/// Saves favorites on the device with `shared_preferences`.
///
/// This is the only file that needs that package. If you don't want it, use
/// `InMemoryFavoritesStorage` in main.dart instead.
class SharedPrefsFavoritesStorage implements FavoritesStorage {
  static const _key = 'favorite_products';

  @override
  Future<List<Product>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      // Skip entries that are malformed rather than failing the whole list.
      return decoded.map(Product.tryFromJson).whereType<Product>().toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> save(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(products.map((p) => p.toJson()).toList()),
    );
  }
}

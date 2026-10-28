import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product.dart';
import '../data/favorites_storage.dart';
import 'favorites_state.dart';

/// Single source of truth for favorites. It is provided once at the app
/// root, so every heart icon and the Favorites list read the same state.
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesStorage storage;

  /// Current local catalog. Saved local favorites are re-read from it on
  /// load so they always use the app's current name, price and image, and
  /// local products that no longer exist are dropped.
  final List<Product> localCatalog;

  FavoritesCubit(this.storage, {this.localCatalog = const []})
      : super(const FavoritesState());

  /// Restores saved favorites. Safe to call once at startup.
  Future<void> load() async {
    try {
      final saved = await storage.load();
      if (isClosed) return;

      final refreshed = <Product>[];
      for (final product in saved) {
        // Home shows only the local rhode products now, so API products
        // saved from earlier versions (perfumes, furniture...) are dropped.
        if (product.isApiProduct) continue;
        for (final local in localCatalog) {
          if (local.id == product.id) {
            refreshed.add(local);
            break;
          }
        }
      }

      // Keep anything the user favorited while loading was still running.
      emit(FavoritesState(items: _withoutDuplicates([...refreshed, ...state.items])));
    } catch (_) {
      // Unreadable storage: start with whatever is in memory.
    }
  }

  bool isFavorite(String productId) => state.isFavorite(productId);

  /// Adds the product if it is not a favorite yet, removes it otherwise.
  void toggle(Product product) {
    if (state.isFavorite(product.id)) {
      remove(product.id);
    } else {
      add(product);
    }
  }

  void add(Product product) {
    if (state.isFavorite(product.id)) return; // no duplicates

    _update([...state.items, product]);
  }

  void remove(String productId) {
    if (!state.isFavorite(productId)) return;

    _update(state.items.where((p) => p.id != productId).toList());
  }

  void _update(List<Product> items) {
    emit(FavoritesState(items: List.unmodifiable(items)));
    _persist(items);
  }

  Future<void> _persist(List<Product> items) async {
    try {
      await storage.save(items);
    } catch (_) {
      // Failing to save must never break the UI; the in-memory list is
      // still correct for this session.
    }
  }

  List<Product> _withoutDuplicates(List<Product> products) {
    final seen = <String>{};
    return products.where((p) => seen.add(p.id)).toList();
  }
}

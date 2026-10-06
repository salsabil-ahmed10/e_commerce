import 'package:flutter/material.dart';
import '../model/cart_item.dart';
import '../model/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// العدد الحقيقي = مجموع كميات كل المنتجات (مش عدد الأصناف)
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      _items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  int quantityOf(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    return index == -1 ? 0 : _items[index].quantity;
  }

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: 1));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// نسخة واحدة مشتركة بين كل الشاشات (الهوم والكارت)
/// من غير ما تحتاجي package اسمه provider.
final CartProvider cartProvider = CartProvider();

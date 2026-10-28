import '../models/cart_item.dart';

class CartState {
  final List<CartItem> items;

  const CartState({
    this.items = const [],
  });

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      items.fold(
        0.0,
        (sum, item) => sum + item.product.price * item.quantity,
      );

  int quantityOf(String productId) {
    final index = items.indexWhere(
      (item) => item.product.id == productId,
    );

    return index == -1 ? 0 : items[index].quantity;
  }
}
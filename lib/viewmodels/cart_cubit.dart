import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index == -1) {
      items.add(
        CartItem(
          product: product,
          quantity: 1,
        ),
      );
    } else {
      items[index].quantity++;
    }

    emit(CartState(items: items));
  }

  void increaseQuantity(String productId) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index != -1) {
      items[index].quantity++;
      emit(CartState(items: items));
    }
  }

  void decreaseQuantity(String productId) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }

      emit(CartState(items: items));
    }
  }

  void removeFromCart(String productId) {
    final items = List<CartItem>.from(state.items);

    items.removeWhere(
      (item) => item.product.id == productId,
    );

    emit(CartState(items: items));
  }

  void clear() {
    emit(const CartState());
  }
}
import 'package:flutter/material.dart';
import 'package:purrfect/models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItems {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.0;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrlList,
    int quantity,
    int productQuantity,
    double price,
    String vendorId,
    String productSize,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCart) => CartAttr(
              productName: existingCart.productName,
              productId: existingCart.productId,
              imageUrlList: existingCart.imageUrlList,
              quantity: existingCart.quantity + 1,
              productQuantity: existingCart.productQuantity,
              price: existingCart.price,
              vendorId: existingCart.vendorId,
              productSize: existingCart.productSize));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              productName: productName,
              productId: productId,
              imageUrlList: imageUrlList,
              quantity: quantity,
              productQuantity: productQuantity,
              price: price,
              vendorId: vendorId,
              productSize: productSize));
      notifyListeners();
    }
  }

  void increment(CartAttr cartAttr) {
    cartAttr.increase();

    notifyListeners();
  }

  void decrement(CartAttr cartAttr) {
    cartAttr.decrease();

    notifyListeners();
  }

  removeItem(productId) {
    _cartItems.remove(productId);

    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();

    notifyListeners();
  }
}

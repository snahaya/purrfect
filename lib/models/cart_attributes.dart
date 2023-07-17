import 'package:flutter/material.dart';

class CartAttr with ChangeNotifier {
  final String productName;

  final String productId;

  final List imageUrlList;

  int quantity;

  int productQuantity;

  final double price;

  final String vendorId;

  final String productSize;

  CartAttr(
      {required this.productName,
      required this.productId,
      required this.imageUrlList,
      required this.quantity,
      required this.productQuantity,
      required this.price,
      required this.vendorId,
      required this.productSize});

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}

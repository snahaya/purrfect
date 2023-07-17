import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrfect/views/buyers/inner_screens/checkout_screen.dart';

import '../../../provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        title: Text(
          'Cart Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 4,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _cartProvider.removeAllItem();
              },
              icon: Icon(CupertinoIcons.delete))
        ],
      ),
      body: _cartProvider.getCartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cartProvider.getCartItems.length,
                itemBuilder: (context, index) {
                  final cartData =
                      _cartProvider.getCartItems.values.toList()[index];
                  return SingleChildScrollView(
                    child: Card(
                      child: SizedBox(
                        height: 180,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(cartData.imageUrlList[0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartData.productName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow.shade900,
                                      letterSpacing: 4,
                                    ),
                                  ),
                                  Text(
                                    "Rs" +
                                        " " +
                                        cartData.price.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow.shade900,
                                      letterSpacing: 4,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: null,
                                    child: Text(
                                      cartData.productSize,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 115,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow.shade900),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: cartData.quantity == 1
                                                  ? null
                                                  : () {
                                                      _cartProvider
                                                          .decrement(cartData);
                                                    },
                                              icon: Icon(
                                                CupertinoIcons.minus,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            Text(
                                              cartData.quantity.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: cartData
                                                          .productQuantity ==
                                                      cartData.quantity
                                                  ? null
                                                  : () {
                                                      _cartProvider
                                                          .increment(cartData);
                                                    },
                                              icon: Icon(
                                                CupertinoIcons.plus,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _cartProvider
                                              .removeItem(cartData.productId);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.cart_badge_minus,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Shopping cart is empty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade900,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Continue Shopping',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: _cartProvider.totalPrice == 0.00
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CheckoutScreen();
                  }));
                },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _cartProvider.totalPrice == 0.00
                  ? Colors.grey
                  : Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rs" +
                        _cartProvider.totalPrice.toStringAsFixed(2) +
                        "  " +
                        'CHECKOUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

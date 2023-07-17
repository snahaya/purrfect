import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:purrfect/provider/cart_provider.dart';
import 'package:purrfect/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:purrfect/views/buyers/inner_screens/ordered_screen.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.yellow.shade900,
                elevation: 0,
                title: Text(
                  'Check Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 4,
                  ),
                ),
              ),
              body: Padding(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
              ),
              bottomSheet: data['address'] == ''
                  ? TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfileScreen(
                            userData: data,
                          );
                        })).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text('Enter Shipping Address',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Colors.yellow.shade900,
                            )),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          EasyLoading.show(status: 'Placing Order');
                          _cartProvider.getCartItems.forEach((key, item) {
                            final orderId = Uuid().v4();
                            _firestore.collection('orders').doc(orderId).set({
                              'orderId': orderId,
                              'vendorId': item.vendorId,
                              'email': data['email'],
                              'phone': data['phoneNumber'],
                              'address': data['address'],
                              'buyerId': data['buyerId'],
                              'fullName': data['fullName'],
                              'buyerPhoto': data['profileImage'],
                              'productName': item.productName,
                              'productPrice': item.price,
                              'productId': item.productId,
                              'productImage': item.imageUrlList,
                              'quantity': item.productQuantity,
                              'productSize': item.productSize,
                              'orderDate': DateTime.now(),
                              'accepted': false,
                              'cancelled': false,
                            }).whenComplete(() {
                              setState(() {
                                _cartProvider.getCartItems.clear();
                              });
                              EasyLoading.dismiss();

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return OrderScreen();
                              }));
                            });
                          });
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'PLACE ORDER',
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

          return Center(
            child: CircularProgressIndicator(color: Colors.yellow.shade900),
          );
        });
  }
}

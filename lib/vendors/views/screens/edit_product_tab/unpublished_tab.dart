import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../VendorProductDetail/vendor_product_detail_screen.dart';

class UnpublishedTab extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore
        .instance
        .collection('products')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('approved', isEqualTo: false)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorProductStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Column(
            children: [
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    final _vendorProductData = snapshot.data!.docs[index];
                    return Slidable(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VendorProductDetailScreen(
                                productData: _vendorProductData,
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  child: Image.network(
                                      _vendorProductData['imageUrlList'][0]),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      _vendorProductData['productName'],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow.shade900),
                                    ),
                                    Text(
                                      'Rs' +
                                          '  ' +
                                          _vendorProductData['productPrice']
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow.shade900),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(_vendorProductData['productId'])
                                    .delete();
                              },
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) async {
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(_vendorProductData['productId'])
                                    .update({
                                  'approved': true,
                                });
                              },
                              backgroundColor: Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.add,
                              label: 'Publish',
                            ),
                          ],
                        ));
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

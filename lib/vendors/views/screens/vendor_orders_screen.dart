import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class VendorOrderScreen extends StatelessWidget {
  String formattedDate(DateTime date) {
    final outputDateFormatter = DateFormat('dd/MM/yyyy');
    final outputDate = outputDateFormatter.format(date);
    return outputDate;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.yellow.shade900,
          title: Text(
            'My Orders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _ordersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.yellow.shade900),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Slidable(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: document['accepted'] == true
                              ? Icon(Icons.delivery_dining)
                              : Icon(Icons.access_time),
                        ),
                        title: document['accepted'] == true
                            ? Text(
                                'Accepted',
                                style: TextStyle(color: Colors.yellow.shade900),
                              )
                            : Text(
                                'Not Accepted',
                                style: TextStyle(color: Colors.red),
                              ),
                        trailing: Text('Amount' +
                            "  " +
                            document['productPrice'].toStringAsFixed(2)),
                        subtitle:
                            Text(formattedDate(document['orderDate'].toDate())),
                      ),
                      ExpansionTile(
                        title: Text(
                          'Order Details',
                          style: TextStyle(
                            color: Colors.yellow.shade900,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text('View Order Details'),
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              child: Image.network(
                                document['productImage'][0],
                              ),
                            ),
                            title: Text(document['productName']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Quantity'),
                                    Text(document['quantity'].toString()),
                                  ],
                                ),
                                ListTile(
                                  title: Text(
                                    'Buyer Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(document['fullName']),
                                      Text(document['email']),
                                      Text(document['address']),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: document['cancelled'] == true
                                      ? Text(
                                          'Order Cancelled',
                                          style: TextStyle(
                                              color: Colors.yellow.shade900),
                                        )
                                      : Text(
                                          'Order active',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: (context) async {
                          await _firestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update({
                            'accepted': false,
                          });
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Reject',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await _firestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update({
                            'accepted': true,
                          });
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Accept',
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}

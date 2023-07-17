import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:intl/intl.dart';

class BuyerOrderScreen extends StatelessWidget {
  String formattedDate(DateTime date) {
    final outputDateFormatter = DateFormat('dd/MM/yyyy');
    final outputDate = outputDateFormatter.format(date);
    return outputDate;
  }

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    EasyLoading.show(status: 'Updating Details');
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'cancelled': true,
    }).whenComplete(() {
      EasyLoading.dismiss();

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              final orderId = document.id;

              return Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Quantity'),
                                Text(document['quantity'].toString()),
                              ],
                            ),
                            ListTile(
                              title: document['cancelled'] == false
                                  ? InkWell(
                                      onTap: () {
                                        _cancelOrder(context, orderId);
                                      },
                                      child: Text(
                                        'Cancel Order',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.yellow.shade900),
                                      ),
                                    )
                                  : Text('Order Cancelled'),
                              subtitle: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}























// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// import 'package:intl/intl.dart';

// class BuyerOrderScreen extends StatelessWidget {
//   String formattedDate(DateTime date) {
//     final outputDateFormatter = DateFormat('dd/MM/yyyy');
//     final outputDate = outputDateFormatter.format(date);
//     return outputDate;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
//         .collection('orders')
//         .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .snapshots();
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.yellow.shade900,
//           title: Text(
//             'My Orders',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 4,
//             ),
//           ),
//         ),
//         body: StreamBuilder<QuerySnapshot>(
//           stream: _ordersStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(color: Colors.yellow.shade900),
//               );
//             }

//             return ListView(
//               children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                 return Column(
//                   children: [
//                     ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.white,
//                         radius: 14,
//                         child: document['accepted'] == true
//                             ? Icon(Icons.delivery_dining)
//                             : Icon(Icons.access_time),
//                       ),
//                       title: document['accepted'] == true
//                           ? Text(
//                               'Accepted',
//                               style: TextStyle(color: Colors.yellow.shade900),
//                             )
//                           : Text(
//                               'Not Accepted',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                       trailing: Text('Amount' +
//                           "  " +
//                           document['productPrice'].toStringAsFixed(2)),
//                       subtitle:
//                           Text(formattedDate(document['orderDate'].toDate())),
//                     ),
//                     ExpansionTile(
//                       title: Text(
//                         'Order Details',
//                         style: TextStyle(
//                           color: Colors.yellow.shade900,
//                           fontSize: 15,
//                         ),
//                       ),
//                       subtitle: Text('View Order Details'),
//                       children: [
//                         ListTile(
//                           leading: CircleAvatar(
//                             child: Image.network(
//                               document['productImage'][0],
//                             ),
//                           ),
//                           title: Text(document['productName']),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text('Quantity'),
//                                   Text(document['quantity'].toString()),
//                                 ],
//                               ),
//                               ListTile(
//                                 title: InkWell(
//                                   child: Text(
//                                     'Cancel Order',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.yellow.shade900),
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 );
//               }).toList(),
//             );
//           },
//         ));
//   }
// }

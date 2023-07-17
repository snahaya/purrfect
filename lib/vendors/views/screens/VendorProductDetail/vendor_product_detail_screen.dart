import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:purrfect/utils/show_snackBar.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  VendorProductDetailScreen({super.key, required this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();

  final TextEditingController _productPriceController = TextEditingController();

  final TextEditingController _productDescriptionController =
      TextEditingController();

  final TextEditingController _productQuantityController =
      TextEditingController();

  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _productPriceController.text =
          widget.productData['productPrice'].toString();
      _productDescriptionController.text = widget.productData['description'];
      _productQuantityController.text =
          widget.productData['quantity'].toString();
    });
    super.initState();
  }

  double? price;
  int? qty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.yellow.shade900,
                      backgroundImage: NetworkImage(
                        widget.productData['imageUrlList'][0],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.photo),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Full Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        price = double.parse(value);
                      });
                    },
                    controller: _productPriceController,
                    decoration: InputDecoration(
                      labelText: 'Enter Price',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _productDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Enter Description',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        qty = int.parse(value);
                      });
                    },
                    controller: _productQuantityController,
                    decoration: InputDecoration(
                      labelText: 'Enter Quantity',
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'Updating Details');
            if (price != null && qty != null) {
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.productData['productId'])
                  .update({
                'productName': _productNameController.text,
                'quantity': qty,
                'productPrice': price,
                'description': _productDescriptionController.text,
              }).whenComplete(() {
              EasyLoading.dismiss();

              Navigator.pop(context);
            });
            } else {
              showSnack(context, 'Update Quantity and Price');
            }
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'UPDATE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}







































// import 'package:flutter/material.dart';

// class VendorProductDetailScreen extends StatefulWidget {
//   final dynamic productData;

//   const VendorProductDetailScreen({super.key, required this.productData});

//   @override
//   State<VendorProductDetailScreen> createState() =>
//       _VendorProductDetailScreenState();
// }

// class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {

//   final TextEditingController _productNameController = TextEditingController();

//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _phoneController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow.shade900,
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         elevation: 0,
//         title: Text(
//           'Update Product',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             letterSpacing: 4,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter Product Name',
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter Product Price',
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter Product Description',
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter Product Quantity',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

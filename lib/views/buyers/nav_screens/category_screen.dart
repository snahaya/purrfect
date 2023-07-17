import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:purrfect/views/buyers/inner_screens/all_products_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade900,
          title: Text(
            'CATEGORIES',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 4),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(14.0),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow.shade900,
                ),
              );
            }

            return Container(
              height: 200,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final categoryData = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: Image.network(categoryData['image']),
                      title: Text(
                        categoryData['categoryName'],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AllProductScreen( categoryData: categoryData);
                        }));
                      },
                    ),
                  );
                },
              ),
            );
          },
        ));
  }
}

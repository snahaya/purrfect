import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class VendorLogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width - 200,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: InkWell(
            child: TextButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

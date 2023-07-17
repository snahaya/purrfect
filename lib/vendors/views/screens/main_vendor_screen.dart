import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purrfect/vendors/views/screens/edit_product_screen.dart';
import 'package:purrfect/vendors/views/screens/upload_screen.dart';
import 'package:purrfect/vendors/views/screens/vendor_logout_screen.dart';
import 'package:purrfect/vendors/views/screens/vendor_orders_screen.dart';


class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    UploadScreen(),
    EditProductScreen(),
    VendorOrderScreen(),
    VendorLogoutScreen(),
  
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.yellow.shade900,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'UPLOAD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'EDIT',
          ),
          BottomNavigationBarItem(
            icon:  Icon(CupertinoIcons.shopping_cart),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'LOG OUT',
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}

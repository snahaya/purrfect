import 'dart:typed_data';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/vendor_register_controller.dart';

class VendorRegistrationScreen extends StatefulWidget {
  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VendorController _vendorController = VendorController();

  late String storeName;
  late String phoneNumber;
  late String email;
  late String taxNumber;

  late String countryValue;
  late String stateValue;
  late String cityValue;

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List im = await _vendorController.piclStoreImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _vendorController.piclStoreImage(ImageSource.camera);

    setState(() {
      _image = im;
    });
  }

  String? _taxRegistered;

  List<String> _taxOptions = ['Yes', 'No'];

  _saveVendorDetail() async {
    EasyLoading.show(status: 'Please Wait');
    if (_formkey.currentState!.validate()) {
      await _vendorController
          .registerVendor(storeName, email, phoneNumber, countryValue,
              stateValue, cityValue, _taxRegistered!, taxNumber, _image)
          .whenComplete(() {
        EasyLoading.dismiss();

        setState(() {
          _formkey.currentState!.reset();

          _image = null;
        });
      });
    } else {
      print('Bad');

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 200,
          flexibleSpace: LayoutBuilder(builder: (context, constraints) {
            return FlexibleSpaceBar(
              background: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.yellow.shade900,
                    Colors.yellowAccent
                  ])),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: _image != null
                                ? Image.memory(_image!)
                                : IconButton(
                                    onPressed: () {
                                      selectGalleryImage();
                                    },
                                    icon: Icon(CupertinoIcons.photo),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      storeName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Store Name cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Store Name',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Number cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax Registered ?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Container(
                          width: 100,
                          child: DropdownButtonFormField(
                              hint: Text('Select'),
                              items: _taxOptions.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _taxRegistered = value;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                  if (_taxRegistered == 'Yes')
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        onChanged: (value) {
                          taxNumber = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tax Number cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(labelText: 'Tax Number'),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _saveVendorDetail();
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        await _auth.signOut();
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

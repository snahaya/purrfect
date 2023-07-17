import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _uploadVendorImageToSstorage(dynamic image) async {
    Reference ref =
        _storage.ref().child('storeImages').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  piclStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

  Future<String> registerVendor(
    String storeName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegistered,
    String taxNumber,
    Uint8List? image,
  ) async {
    String res = 'Some Error Occured';

    try {
      String _storeImage = await _uploadVendorImageToSstorage(image);

      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'storeName': storeName,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'taxNumber': taxNumber,
        'taxRegistered': taxRegistered,
        'storeImage': _storeImage,
        'approved': false,
        'vendorId' : _auth.currentUser!.uid,
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}

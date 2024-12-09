import 'package:flutter/material.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';

import '../../model/address.dart';


class AddAddressPage extends StatefulWidget {





  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _addressLine1Controller.dispose();

    _addressLine2Controller.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      Address newAddress = Address(
        address: _addressController.text,
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _cityController.text,
        pincode: _pincodeController.text,
        state: _stateController.text,
      );

      FirebaseService().addAddress(newAddress).then((_) {
        Navigator.pop(context); // Go back to the previous screen
      }).catchError((error) {
        // Handle errors, e.g., show an error message
        print("Failed to add address: $error");
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Address', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _addressController,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(labelText: 'Flat No / House No',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressLine1Controller,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(labelText: 'Address Line 1',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address line 1';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressLine2Controller,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(labelText: 'Address Line 2',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),),
                ),
                TextFormField(
                  controller: _cityController,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(labelText: 'City',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pincodeController,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(labelText: 'Pincode',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a pincode';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stateController,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(labelText: 'State',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _saveAddress,
                  child: Text('Save Address',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/model/user_data.dart';

import '../../gen/assets.gen.dart';
import '../../widget/custom_button.dart';

class UserDetailView extends StatefulWidget {
  UserCredential credential;

  UserDetailView({required this.credential});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  final _formKey = GlobalKey<FormState>();

  // Define controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Image.asset("assets/images/verification.png",
                height: 360,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Complete your profile',
                          style: TextStyle(
                              fontSize: 25,
                              color: Color(0Xff21618C),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          cursorHeight: 32,
                          cursorWidth: 2,
                          cursorColor: Colors.blueAccent,
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.person,color: Colors.blueAccent,),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          cursorHeight: 32,
                          cursorWidth: 2,
                          cursorColor: Colors.blueAccent,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email,color: Colors.blueAccent,),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        CustomButton(
                          title: 'Create Account',
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          callback: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, save the form and proceed
                              _formKey.currentState!.save();
                              var result = await FirebaseService().createUser(UserData(
                                  id: widget.credential.user!.uid,
                                  contact: widget.credential.user!.phoneNumber!,
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  createdAt:
                                      DateTime.now().millisecondsSinceEpoch,isActive: true));

                              if(result){
                                Navigator.pushNamedAndRemoveUntil(context, AppConstant.dashboardView, (route) => false);
                              }

                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

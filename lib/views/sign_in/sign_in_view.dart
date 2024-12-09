import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/widget/custom_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>(); // Add this line
  String mobileNumber = '';

  void _verifyPhoneNumber() async {
    FirebaseService().verifyPhoneNumber(
      mobileNumber,
          () {

        Navigator.pushNamed(context, AppConstant.verificationView, arguments: mobileNumber);
      },
          (String message) {
        print('Error : $message');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }


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
              height: 380),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    // Wrap your Column in a Form widget
                    key: _formKey, // Add this line
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Meeting Your Healthcare Needs',
                          style: TextStyle(
                              fontSize: 25,
                              color: Color(0Xff21618C),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorHeight: 32,
                          cursorWidth: 2,
                          cursorColor: Colors.blueAccent,
                          // Change TextField to TextFormField
                          decoration: InputDecoration(
                            labelText: 'Enter Mobile Number',
                            prefixText: '+91',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            suffixIcon: Icon(Icons.phone,
                              color: Colors.blueAccent.shade200,
                            size: 28,),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (value.length != 10) {
                              // Assuming Indian mobile numbers
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            mobileNumber = "+91$value";
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          title: 'Continue',
                          backgroundColor: Colors.blueAccent.shade100,
                          foregroundColor: Colors.white,
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              // Add this line
                              // If the form is valid, display a Snackbar.
                              _formKey.currentState!.save(); // Save the form
                              _verifyPhoneNumber();
                            }
                          },
                        )
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
}

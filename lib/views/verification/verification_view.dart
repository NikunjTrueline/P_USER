import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../widget/custom_button.dart';

class VerificationView extends StatefulWidget {
  String mobileNumber;

  VerificationView({required this.mobileNumber});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  TextEditingController _codeController = TextEditingController();

  void _signInWithPhoneNumber() async {
    FirebaseService().signInWithPhoneNumber(
      _codeController.text.trim(),
      (UserCredential userCredential) async {

        await FirebaseService().checkIfUserExists(userCredential.user!.uid).then((result) {
          if(!result){
            Navigator.pushReplacementNamed(context, AppConstant.userDetailView, arguments: userCredential);
          }else{
            Navigator.pushReplacementNamed(context, AppConstant.dashboardView);
          }
        });

      },
      (String message) {
        // On failure, show the error message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
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
              height: 400,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Verify your Mobile number',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color(0Xff21618C),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        // Typically OTP codes are of length 6
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.grey.shade300,
                          inactiveColor: Colors.grey,
                          activeColor: Colors.blueAccent.shade200
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        controller: _codeController,
                        onCompleted: (v) {
                          _signInWithPhoneNumber();
                        },
                        onChanged: (value) {},
                        beforeTextPaste: (text) {
                          // If you want to prevent clipboard pasting, return false.
                          return true;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        title: 'Verify and Continue',
                        backgroundColor: Colors.blueAccent.shade100,
                        foregroundColor: Colors.white,
                        callback: () {},
                      )
                    ],
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

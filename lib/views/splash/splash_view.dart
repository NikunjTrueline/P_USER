import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/views/dashboard/dashboard_view.dart';
import '../../constants/constants.dart';
import '../../gen/assets.gen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      var auth = FirebaseAuth.instance.currentUser;

      FirebaseService().getUserData1().then((user) {
        if (user != null && user.isActive) {
          if (auth == null) {
            Navigator.of(context).pushReplacementNamed(AppConstant.loginView);
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardView(),
                ));
            print("Done 1");
            //    welcome();
            print("Done 2");
          }
        } else {
          if (auth == null) {
            Navigator.of(context).pushReplacementNamed(AppConstant.onboarding);
          } else {
            showRestrictedDialog(context);
          }
        }
      });
    });
  }

  void welcome() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wel-come to  User Panel!'),
        backgroundColor: Color(0Xff21618C),
        shape: OutlineInputBorder(),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  showRestrictedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Restricted'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have been restricted by the admin.'),
                Text('Please try again later.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                SystemNavigator.pop(); // Attempts to close the application
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Assets.images.appLogo.image(),
      ),
    );
  }
}

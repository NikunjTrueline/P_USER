import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../model_for_onboarding.dart';
import 'custom_row.dart';


class OnBoardingBody extends StatefulWidget {

  const OnBoardingBody({super.key});

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody> {
  List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(
        title: "ONLINE SHOPPING",
        image: "assets/images/o1.jpeg",
        description: 'YOU CAN SHOPPING THE MEDICAL PRODUCTS ANYTIME , ANYWHERE THAT YOU WANT.'),

    OnBoardingModel(
        title: "ORDER MEDICINE & CHOOSE DELIVERY ",
        image: "assets/images/o2.jpeg",
        description: ' PRODUCTS THAT YOU ORDER WILL BE DELIVERED TO YOUR SPECIFIED ADDRESS.'),

    OnBoardingModel(
        title: "MULTIPLE PAYMENT SYSTEM",
        image: "assets/images/o3.jpg",
        description: 'YOU CAN USE MULTI-TYPES OF PAYMENT SYSTEM FOR PRODUCTS PAYMENTS.'),

  ];

  int currentIndex = 0;

  final _pageViewController= PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              height: 650,
              child: PageView.builder(
                controller: _pageViewController,
                itemCount: onBoardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: Image(
                              image: AssetImage(onBoardingData[index].image),
                            )),
                        SizedBox(height: 20,),
                        Text(onBoardingData[index].title,
                            style: const TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color: Color(0Xff21618C)),
                            textAlign: TextAlign.center),
                        SizedBox(height: 15,),
                        Text(onBoardingData[index].description,
                            style: const TextStyle(
                                fontSize: 19,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              )),
          SizedBox(height: 10,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 10),
                child: customRow(currentIndex: currentIndex),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24, top: 10),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (currentIndex < onBoardingData.length - 1) {
                        currentIndex++;
                        _pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.linear);

                      }
                      else{
                        Navigator.of(context).pushReplacementNamed(AppConstant.loginView);
                      }

                    });
                  },


                  backgroundColor: Colors.blueAccent.shade200,
                  child: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}

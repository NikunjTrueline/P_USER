import 'package:flutter/material.dart';

Widget customRow({required int currentIndex}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: currentIndex == 0 ? 18 : 12,
          width: currentIndex == 0 ? 18 : 12,
          decoration: BoxDecoration(
              color: currentIndex == 0 ? Colors.blueAccent.shade400 : Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: currentIndex == 1 ? 18 : 12,
          width: currentIndex == 1 ? 18 : 12,
          decoration: BoxDecoration(
              color: currentIndex == 1 ? Colors.blueAccent.shade400 : Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: currentIndex == 2 ? 18 : 12,
          width: currentIndex == 2 ? 18 : 12,
          decoration: BoxDecoration(
              color: currentIndex == 2 ? Colors.blueAccent.shade400 : Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(30)),
        ),
      )
    ],
  );
}

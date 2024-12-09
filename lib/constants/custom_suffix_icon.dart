import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSuffixIcon extends StatelessWidget {
  final String svgiconpath;

  const CustomSuffixIcon({super.key, required this.svgiconpath,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        10,
        12,
        10,
      ),
      child: SvgPicture.asset(
        svgiconpath,
        height: 14,
        colorFilter: const ColorFilter.mode(
            Colors.blueAccent,
            BlendMode.srcIn),
      ),
    );
  }
}

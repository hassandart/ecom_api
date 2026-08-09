import 'package:ecom_api/core/constants/image_constiant.dart';
import 'package:flutter/material.dart';

class MyHomeBanner extends StatelessWidget {
  const MyHomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 140, child: Image.asset(MyAppImage.banner));
  }
}

import 'package:ecom_api/core/constants/image_constiant.dart';
import 'package:ecom_api/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MySearchTextField extends StatelessWidget {
  const MySearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: EdgeInsets.all(16),
          child: Image.asset(
            MyAppIcons.search,
            height: 24,
            width: 24,
            color: MyAppColor.subTitleText,
          ),
        ),
        hint: Text("Search coffee", style: MyTextStyle.subTitleText(size: 16)),
        fillColor: Color(0xff2A2A2A),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}

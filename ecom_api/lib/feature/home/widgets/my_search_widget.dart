import 'package:ecom_api/core/constants/image_constiant.dart';
import 'package:ecom_api/core/shared/buttons.dart';
import 'package:ecom_api/core/shared/my_text_field.dart';
import 'package:flutter/widgets.dart';

class MySearchWidget extends StatelessWidget {
  const MySearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: MySearchTextField()),
        const SizedBox(width: 16),
        MyIconButton(icon: MyAppIcons.filter, onTap: () {}),
      ],
    );
  }
}

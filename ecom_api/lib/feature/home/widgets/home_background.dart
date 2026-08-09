import 'package:ecom_api/core/theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class HomeBackGround extends StatelessWidget {
  const HomeBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(color: MyAppColor.titleBlackText)),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }
}

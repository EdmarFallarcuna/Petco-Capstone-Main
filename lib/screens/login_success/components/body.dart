import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:petco/components/default_button.dart';
import 'package:petco/size_config.dart';

import '../../../riverpod/general_provider.dart';

class Body extends ConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Center(
          child: Lottie.asset(
            "assets/lottie/success.json",
            repeat: false,
            height: SizeConfig.screenHeight * 0.4,
            // width: getProportionateScreenWidth(235),
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Login Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              ref.read(withUserPageProvider.notifier).state = 0;
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

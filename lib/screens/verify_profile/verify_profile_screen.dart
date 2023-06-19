import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/verify_profile_form.dart';

class VerifyProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  const VerifyProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: topPadding),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.screenHeight * 0.03),

                Text("Verify Profile", style: headingStyle),
                const Text(
                  "We have send a verification code to your email. Please check the inbox and follow the instruction to verify your account. Thank you.\nPlease restart the application if the verification status did not change.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                const VerifyProfileForm(),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

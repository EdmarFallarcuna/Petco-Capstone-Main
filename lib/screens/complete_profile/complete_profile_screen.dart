import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../end_user_agreement/enduser_agreement_screen.dart';
import 'components/complete_profile_form.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  const CompleteProfileScreen({Key? key}) : super(key: key);
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

                Text("Complete Profile", style: headingStyle),
                const Text(
                  "Complete your details or continue",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                const CompleteProfileForm(),
                SizedBox(height: getProportionateScreenHeight(30)),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "By continuing your confirm that you agree \n",
                        style: Theme.of(context).textTheme.caption,
                        children: [
                          TextSpan(
                              text: "Term and Condition",
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    EndUserAgreementScreen.routeName,
                                  );
                                })
                        ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

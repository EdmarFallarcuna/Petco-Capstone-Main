import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants.dart';
import '../../riverpod/general_provider.dart';
import '../../size_config.dart';
import '../end_user_agreement/enduser_agreement_screen.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends ConsumerWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(
                      onPressed: () {
                        ref.read(withOutUserPageProvider.notifier).state = 1;
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text("Register Account", style: headingStyle),
                  const Text(
                    "Complete your details to continue",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  const SignUpForm(),

                  SizedBox(height: getProportionateScreenHeight(20)),
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
                          ]))                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

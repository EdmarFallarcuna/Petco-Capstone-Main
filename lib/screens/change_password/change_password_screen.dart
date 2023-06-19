import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/change_password_form.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String routeName = "/change_password";

  const ChangePasswordScreen({Key? key}) : super(key: key);
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

                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),

                Text("Change Password", style: headingStyle),
                const Text(
                  "Change your profile password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                const ChangePasswordForm(),
                SizedBox(height: getProportionateScreenHeight(30)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

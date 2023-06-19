import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/enduser_agreement_form.dart';

class EndUserAgreementScreen extends StatelessWidget {
  static String routeName = "/end_user";

  const EndUserAgreementScreen({Key? key}) : super(key: key);
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text("Terms and Conditions", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                const EndUserForm(),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

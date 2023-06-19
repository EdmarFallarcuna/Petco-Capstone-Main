import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  static String routeName = "/edit_profile";

  const EditProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final EditProfileArguments agrs =
    ModalRoute.of(context)!.settings.arguments as EditProfileArguments;
    final Map map=agrs.map;
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

                Text("Account Details", style: headingStyle),
                const Text(
                  "Complete your details or continue",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                EditProfileForm(map: map,),
                SizedBox(height: getProportionateScreenHeight(30)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
class EditProfileArguments {
  final Map map;


  EditProfileArguments({required this.map});
}

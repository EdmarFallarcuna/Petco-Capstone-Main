import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';



class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.15),
            Center(
              child: Image.asset(
                "assets/images/petco.png",
                height: SizeConfig.screenHeight * 0.4,
                // width: getProportionateScreenWidth(235),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            const Center(
              child: CircularProgressIndicator(color: kPrimaryColor,),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

}

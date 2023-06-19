import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/body.dart';

class RatingsScreen extends StatelessWidget {
  static String routeName = "/ratings";

  const RatingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final RatingArguments agrs =
    ModalRoute.of(context)!.settings.arguments as RatingArguments;
    final Map map=agrs.map;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
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

                Text("Your Rating", style: headingStyle),
                RatingBarIndicator(
                  rating: (map['rating']??0)/(map['numberOfRating']??1),
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: getProportionateScreenWidth(40),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                const Text(
                  "This ratings is given by the user who go \na transaction to you",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                const Body(),
                SizedBox(height: getProportionateScreenHeight(30)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingArguments {
  final Map map;


  RatingArguments({required this.map});
}

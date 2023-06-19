import 'package:flutter/material.dart';
import 'package:petco/size_config.dart';
import 'components/body.dart';

class LoadingScreen extends StatelessWidget {
  static String routeName = "/error";

  const LoadingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:petco/size_config.dart';
import 'components/body.dart';

class ErrorScreen extends StatelessWidget {
  static String routeName = "/error";

  const ErrorScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}

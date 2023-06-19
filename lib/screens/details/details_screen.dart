import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: AppBar(backgroundColor: const Color(0xFFF5F6F9),),
      ),
      body: Body(snapshot: agrs.snapshot),
    );
  }
}

class ProductDetailsArguments {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;


  ProductDetailsArguments({required this.snapshot});
}

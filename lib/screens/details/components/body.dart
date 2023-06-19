import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:petco/screens/details/components/user_description.dart';

import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {

  const Body({Key? key, required this.snapshot}) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(snapshot: snapshot),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                snapshot: snapshot,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          // margin: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20)),
          // padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20)),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              UserDescription(
                transactionID: snapshot.id,
                ownerID: snapshot.data()['owner'],
                petName: snapshot.data()['title'],
                petImage: snapshot.data()['idPhotoUrl1'],
                type: snapshot.data()['type'],
                paymentDetails: snapshot.data()['paymentDetails'],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

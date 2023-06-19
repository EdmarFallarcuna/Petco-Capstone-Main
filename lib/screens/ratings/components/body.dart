import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petco/screens/ratings/components/to_rate_item.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends HookConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('listing').where("buyer", isEqualTo: uid).where("rated",isEqualTo: 0).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "An unknown error has occurred",
                style: TextStyle(color: Colors.red),
              )
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: kPrimaryColor,
              )
            ],
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Column(
            children: const [
              SizedBox(height: 10),
            ],
          );
        }

        return Expanded(
          child: Column(
            children: [
              const Divider(
                thickness: 1.5,
              ),
              Text("To Rate",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(20), fontWeight: FontWeight.bold, color: Colors.black)),
              const Text(
                "Users that you have to rate for your previous transaction",
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ToRateItem(data:data, id: document.id);
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

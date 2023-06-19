

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petco/screens/home/components/search_field.dart';

import '../../../../size_config.dart';
import 'trade_list.dart';

class TradeBody extends HookWidget {
  const TradeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final list=useState<List<QueryDocumentSnapshot<Map<String, dynamic>>>>([]);
    final search=useTextEditingController();
    final searchText=useState('');
    useEffect(() {
      final subscription =FirebaseFirestore.instance.collection('listing')
          .where('type',isEqualTo: 'Trade')
          .where("status",isEqualTo: "available")
          .where("owner",isNotEqualTo: FirebaseAuth.instance.currentUser?.uid??'')
          .orderBy('owner')
          .orderBy('title')
          .snapshots().listen((event) {
         list.value=event.docs;

      });
      search.addListener(() {
        searchText.value=search.text;
      });
      return subscription.cancel;
    },
      // when the stream changes, useEffect will call the callback again.
      [],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),

            // Categories(),
            SizedBox(height: getProportionateScreenWidth(10)),
            SearchField(textEditingController: search),

            SizedBox(height: getProportionateScreenWidth(10)),
            Expanded(child: TradeList(list: list.value,search: searchText.value,)),
          ],
        ),
      ),
    );
  }
}

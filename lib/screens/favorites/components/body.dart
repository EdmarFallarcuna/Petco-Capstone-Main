import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../details/details_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget myList() {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid == '') {
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
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('listing').where("favorites.$uid",isEqualTo: true).where("status",isEqualTo: "available").snapshots(),
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
                Text(
                  "You don't have any favorites listed",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ],
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((QueryDocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(snapshot: document as QueryDocumentSnapshot<Map<String, dynamic>>),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(80),
                          child: AspectRatio(
                            aspectRatio: 1.02,
                            child: Container(
                              padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: data['idPhotoUrl1'],
                                placeholder: (context, url) => const CircularProgressIndicator(color: kPrimaryColor,),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['title']??'',
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(17),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              Text(data['description']??'',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Colors.grey,
                                  )),
                              Text(data['type']=="Adopt"?"For Adoption":data['type']=="Sell"?"For Sell":"For Trade",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: kPrimaryColor,
                                  )),
                              if(data['type']=="Sell")
                                Text("Php${NumberFormat("#,##0.00", "en_US").format(num.tryParse(data['price']??'')??0)}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(15),
                                      color: Colors.grey,
                                    )),
                              if(data['type']=="Trade")
                                Text(data['desire']??'',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(15),
                                      color: Colors.grey,
                                    )),

                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: kPrimaryColor,),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.2,
                  ),
                ],
              );
            }).toList(),
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Favorites", style: headingStyle),
              const SizedBox(
                width: 1,
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: getProportionateScreenWidth(30),
              )
            ],
          ),
          const Text(
            "Only shows your favorites that \nis still listed",
            textAlign: TextAlign.center,
          ),
          const Divider(
            thickness: 1.2,
          ),
          Expanded(child: myList()),
        ],
      ),
    );
  }
}

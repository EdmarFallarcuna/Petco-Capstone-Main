import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petco/screens/add_listing/add_listing_screen.dart';
import 'package:petco/screens/edit_listing/edit_listing_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

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
        stream: FirebaseFirestore.instance.collection('listing').where("owner",isEqualTo: uid).where("status",isNotEqualTo: "done").snapshots(),
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
                  "You don't have any listing",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ],
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        EditListingScreen.routeName,
                        arguments: EditListingArguments(map: data, id:document.id),
                      );
                    },
                    child: Row(
                      children: [
SizedBox(
  width: getProportionateScreenWidth(80),

  child:   Column(
    children: [
      AspectRatio(
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
      AutoSizeText((data['status']??'').toString().toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(15),
            color: data['status']=="reject"?Colors.red: kPrimaryColor,
          ))
    ],
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
              Text("Your Listing", style: headingStyle),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddListingScreen.routeName,
                  );
                },
                child: Container(
                  width: getProportionateScreenWidth(40),
                  height: getProportionateScreenWidth(40),
                  decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const Text(
            "Your list of pet will be shown from \nthe public view",
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

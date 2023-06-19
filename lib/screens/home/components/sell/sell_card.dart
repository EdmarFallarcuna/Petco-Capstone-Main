import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../details/details_screen.dart';


class SellCard extends HookWidget {
  const SellCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.snapshot
  }) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;
  final double width, aspectRetio;

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isFavorite=(snapshot.data()['favorites'] as Map?)?[uid]==true;
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              DetailsScreen.routeName,
              arguments: ProductDetailsArguments(snapshot: snapshot),
            );

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Stack(
  children: [
    AspectRatio(
      aspectRatio: 1.02,
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Hero(
          tag: snapshot.id,
          child: CachedNetworkImage(
            imageUrl: snapshot.data()['idPhotoUrl1'],
            placeholder: (context, url) => const CircularProgressIndicator(color: kPrimaryColor,),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    ),
    if(snapshot.data()['category']=="Exotic Pet")
      Positioned(
          bottom: 10,
          right: 10,
          child: Icon(Icons.gesture,
            shadows: <Shadow>[Shadow(color: Colors.yellow, blurRadius: 15.0)],
          ))
  ],
),
              const SizedBox(height: 10),
              Text(
                snapshot.data()['title'],
                style: const TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      "Php${NumberFormat("#,##0.00", "en_US").format(num.tryParse(snapshot.data()['price']??'')??0)}",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () async {
                        await FirebaseFirestore.instance.collection('listing').doc(snapshot.id).update({
                          "favorites.$uid": !isFavorite,
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                        height: getProportionateScreenWidth(28),
                        width: getProportionateScreenWidth(28),
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? kPrimaryColor.withOpacity(0.15)
                              : kSecondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Heart Icon_2.svg",
                          color: isFavorite
                              ? const Color(0xFFFF4848)
                              : const Color(0xFFDBDEE4),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

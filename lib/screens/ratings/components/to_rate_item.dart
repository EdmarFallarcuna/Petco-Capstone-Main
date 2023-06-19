import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';

import '../../../components/notification_body.dart';
import '../../../components/small_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class ToRateItem extends HookWidget {
  const ToRateItem({Key? key, required this.data, required this.id}) : super(key: key);
  final Map data;
  final String id;

  @override
  Widget build(BuildContext context) {
    final myRating = useState<double>(0);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Column(
      children: [
        Row(
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
                    placeholder: (context, url) => const CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? '',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  Text(data['description'] ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        color: Colors.grey,
                      )),
                  Text(
                      data['type'] == "Adopt"
                          ? "For Adoption"
                          : data['type'] == "Sell"
                              ? "For Sell"
                              : "For Trade",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        color: kPrimaryColor,
                      )),
                  if (data['type'] == "Sell")
                    Text("Php${NumberFormat("#,##0.00", "en_US").format(num.tryParse(data['price'] ?? '') ?? 0)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(15),
                          color: Colors.grey,
                        )),
                  if (data['type'] == "Trade")
                    Text(data['desire'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(15),
                          color: Colors.grey,
                        )),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: getProportionateScreenWidth(30),
              itemPadding: const EdgeInsets.symmetric(horizontal: 0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                myRating.value = rating;
              },
            ),
            const Expanded(child: SizedBox()),
            SmallButton(
              text: 'Rate Now!',
              press: () async {
                if (myRating.value == 0) {
                  InAppNotification.show(
                    child: const NotificationBody(
                      msg: "Please specify your rating before you continue",
                    ),
                    context: context,
                  );
                  return;
                }

                await FirebaseFirestore.instance.collection('listing').doc(id).update({
                  "rated": myRating.value,
                });
                await FirebaseFirestore.instance.collection('users').doc(data['owner']).update({
                  "rating": FieldValue.increment(myRating.value),
                  "numberOfRating": FieldValue.increment(1),
                });
                InAppNotification.show(
                  child: const NotificationBody(msg: "Thank you for your rating",),
                  context: context,
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: 1.2,
        ),
      ],
    );
  }
}

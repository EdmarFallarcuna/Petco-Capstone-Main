import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../helper/chat_core/firebase_chat_core.dart';
import '../../../size_config.dart';
import '../../chat/components/chat.dart';

class UserDescription extends StatelessWidget {
  const UserDescription({
    Key? key,
    required this.ownerID, required this.type,required this.transactionID, required this.petName, required this.petImage, this.paymentDetails
  }) : super(key: key);

  final String ownerID;
  final String transactionID;
  final String petName;
  final String petImage;
  final String type;
  final String? paymentDetails;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(ownerID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text(
            "An Unknown error has occurred.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text(
            "An Unknown error has occurred.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(20),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(50),
                    height: getProportionateScreenWidth(50),
                    child: data["imageUrl"]==null?ClipOval(child: Image.asset("assets/images/user_icon_box.png")):
                    ClipOval(child: CachedNetworkImage(
                      imageUrl: data["imageUrl"]!,
                      fit:BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        const Text(
                          "Owner",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        Text(
                          "${data['firstName']} ${data['lastName']}",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          "${data['streetAddress']} ${data['city']} ${data['province']}",
                          maxLines: 3,
                        ),
                        RatingBarIndicator(
                          rating: (data['rating']??0)/(data['numberOfRating']??1),
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: getProportionateScreenWidth(20),
                          itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.15,
                    right: SizeConfig.screenWidth * 0.15,
                    bottom: getProportionateScreenWidth(40),
                    top: getProportionateScreenWidth(15),
                  ),
                  child: DefaultButton(
                    text: type=='Sell'?"Buy Now":"Message",
                    press: () async {
                      final navigator=Navigator.of(context);
                      final room = await FirebaseChatCore.instance.createRoom(
                          ownerId: ownerID,
                          docId: transactionID,
                          roomName: petName, image: petImage,additionalMsg: type=='Sell'?paymentDetails:null);

                      await navigator.push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            room: room,

                          ),
                        ),
                      );
                    },
                  ),
                ),
              )

            ],
          );

        }

        return const CircularProgressIndicator(color: kPrimaryColor,);
      },
    );

  }
}

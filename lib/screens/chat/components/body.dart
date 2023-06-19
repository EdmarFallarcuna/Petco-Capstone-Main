import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../constants.dart';
import '../../../helper/chat_core/firebase_chat_core.dart';
import '../../../size_config.dart';
import 'chat.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget _buildAvatar(types.Room room) {
      var color = kPrimaryColor;


      final hasImage = room.imageUrl != null;
      final name = room.name ?? '';

      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: CircleAvatar(
          backgroundColor: hasImage ? Colors.transparent : color,
          backgroundImage: hasImage ? CachedNetworkImageProvider(room.imageUrl!) : null,
          radius: 20,
          child: !hasImage
              ? Text(
            name.isEmpty ? '' : name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white,),
          )
              : null,
        ),
      );
    }


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
      return StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(orderByUpdatedAt: true),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('You still not creating any chat'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        room: room,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildAvatar(room),
                      Expanded(child: Text(room.name ?? '',maxLines: 2,)),
                    ],
                  ),
                ),
              );
            },
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
          Text("Chat Room", style: headingStyle),
          const Text(
            "The list of chat with the \nowner of the pet",
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

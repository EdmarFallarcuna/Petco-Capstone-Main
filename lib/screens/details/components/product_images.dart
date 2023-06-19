import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends HookWidget {
  const ProductImages({Key? key, required this.snapshot}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    final selectedImage = useState(1);

    Widget buildSmallProductPreview(int index) {
      if (snapshot.data()['idPhotoUrl$index'] == null) {
        return const SizedBox();
      }
      return GestureDetector(
        onTap: () {
          selectedImage.value = index;
        },
        child: AnimatedContainer(
          duration: defaultDuration,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(8),
          height: getProportionateScreenWidth(48),
          width: getProportionateScreenWidth(48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kPrimaryColor.withOpacity(selectedImage.value == index ? 1 : 0)),
          ),
          child:CachedNetworkImage(
            imageUrl: snapshot.data()['idPhotoUrl$index'],
            placeholder: (context, url) => const CircularProgressIndicator(
              color: kPrimaryColor,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: snapshot.id,
              child: CachedNetworkImage(
                imageUrl: snapshot.data()['idPhotoUrl${selectedImage.value}'],
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
Stack(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSmallProductPreview(1),
        buildSmallProductPreview(2),
        buildSmallProductPreview(3),
        buildSmallProductPreview(4),
      ],
    ),
    if(snapshot.data()['category']=="Exotic Pet")
    Positioned(
        left: getProportionateScreenWidth(20),
        bottom: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gesture, size: 30,
              shadows: <Shadow>[Shadow(color: Colors.yellow, blurRadius: 15.0)],
            ),
            Text("Exotic", style: TextStyle(fontSize: getProportionateScreenWidth(10), fontWeight: FontWeight.bold, color: Colors.black),)

          ],
        )    )


  ],
)      ],
    );
  }
}

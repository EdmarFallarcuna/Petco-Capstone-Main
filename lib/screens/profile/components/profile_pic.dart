import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petco/constants.dart';

class ProfilePic extends HookWidget {
  const ProfilePic({
    Key? key,
    required this.idPhotoUrl
  }) : super(key: key);
final ValueNotifier<String?> idPhotoUrl;
  @override
  Widget build(BuildContext context) {
    final isLoading=useState(false);

    Future<String> uploadImage(File imageFile) async {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      Reference myRef = FirebaseStorage.instance.ref().child("user_res/$uid/profile.jpg");
      UploadTask uploadTask = myRef.putFile(imageFile);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      return downloadUrl.toString();
    }

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Material(
                color: Colors.grey[300],

                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(100.0),
              // backgroundImage:(idPhoto.value==null? AssetImage("assets/images/user_icon_box.png"):FileImage(File(idPhoto.value!.path))) as ImageProvider<Object>?,
              child: isLoading.value?
              const CircularProgressIndicator(color: kPrimaryColor,):
            idPhotoUrl.value==null?ClipOval(child: Image.asset("assets/images/user_icon_box.png")):
              ClipOval(child: CachedNetworkImage(
                imageUrl: idPhotoUrl.value!,
                fit:BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ))


            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  if(!isLoading.value){
                    isLoading.value=true;
                    XFile? photo= await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024,);
                    if (photo != null) {
                      final uid=FirebaseAuth.instance.currentUser?.uid;
                      if(uid!=null){
                        idPhotoUrl.value = await uploadImage(File(photo.path));


                        await FirebaseFirestore.instance
                            .collection('users').doc(uid)
                            .update({
                          'imageUrl': idPhotoUrl.value,
                        });

                      }
                    }
                    isLoading.value=false;
                  }

                },
                child: const Icon(Icons.camera_alt_outlined, color: Colors.grey,),
              ),
            ),
          )
        ],
      ),
    );
  }
}

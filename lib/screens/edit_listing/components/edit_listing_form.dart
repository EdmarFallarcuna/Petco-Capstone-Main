import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:petco/components/default_button.dart';
import 'package:petco/components/form_error.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../components/my_text_form.dart';
import '../../../components/notification_body.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class EditListingForm extends HookConsumerWidget {
  const EditListingForm({Key? key, required this.map, required this.id}) : super(key: key);
  final Map map;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final errors = useState<List<String?>>([]);
    final refresh = useState(false);
    final category = useTextEditingController(text: map['category']);
    final title = useTextEditingController(text: map['title']);
    final description = useTextEditingController(text: map['description']);
    final type = useTextEditingController(text: map['type']);
    final amount = useTextEditingController(text: map['price']);
    final paymentDetails=useTextEditingController(text: map['paymentDetails']);
    final desire = useTextEditingController(text: map['desire']);
    final isAmountVisible = useState(map['type'] == 'Sell');
    final isDesireTradeDescription = useState(map['type'] == 'Trade');
    final idPhoto1 = useState<XFile?>(null);
    final idPhoto2 = useState<XFile?>(null);
    final idPhoto3 = useState<XFile?>(null);
    final idPhoto4 = useState<XFile?>(null);

    void addError({String? error}) {
      if (!errors.value.contains(error)) {
        errors.value.add(error);
        refresh.value = !refresh.value;
      }
    }

    void removeError({String? error}) {
      if (errors.value.contains(error)) {
        errors.value.remove(error);
        refresh.value = !refresh.value;
      }
    }

    Future<String> uploadImage(File imageFile) async {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      String fileID = const Uuid().v4();
      Reference myRef = FirebaseStorage.instance.ref().child("user_res/$uid/$fileID.jpg");
      UploadTask uploadTask = myRef.putFile(imageFile);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      return downloadUrl.toString();
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            "Your pet picture",
            style: TextStyle(fontSize: getProportionateScreenWidth(17)),
          ),
          Text(
            "Click on the icons to add image",
            style: TextStyle(fontSize: getProportionateScreenWidth(13), color: kPrimaryColor),
          ),
          GestureDetector(
            onTap: () async {
              idPhoto1.value = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                maxWidth: 1024,
              );
              // Image.file(File(idPhoto.value!.path))
            },
            child: SizedBox(
              width: getProportionateScreenWidth(200),
              child: AspectRatio(
                  aspectRatio: 1,
                  child: idPhoto1.value == null
                      ? map['idPhotoUrl1'] != null
                          ? CachedNetworkImage(
                              imageUrl: map['idPhotoUrl1'],
                              placeholder: (context, url) => const CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Icon(
                              Icons.add_photo_alternate_outlined,
                              size: getProportionateScreenWidth(48),
                              color: kPrimaryColor,
                            )
                      : Image.file(File(idPhoto1.value!.path)) // Image.asset(widget.product.images[selectedImage]),
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  idPhoto2.value = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                  );
                },
                child: AnimatedContainer(
                  duration: defaultDuration,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(8),
                  height: getProportionateScreenWidth(48),
                  width: getProportionateScreenWidth(48),
                  child: idPhoto2.value == null
                      ? map['idPhotoUrl2'] != null
                          ? CachedNetworkImage(
                              imageUrl: map['idPhotoUrl2'],
                              placeholder: (context, url) => const CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Icon(
                              Icons.add_photo_alternate_outlined,
                              size: getProportionateScreenWidth(48),
                              color: kPrimaryColor,
                            )
                      : Image.file(File(idPhoto2.value!.path)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  idPhoto3.value = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                  );
                },
                child: AnimatedContainer(
                  duration: defaultDuration,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(8),
                  height: getProportionateScreenWidth(48),
                  width: getProportionateScreenWidth(48),
                  child: idPhoto3.value == null
                      ? map['idPhotoUrl3'] != null
                          ? CachedNetworkImage(
                              imageUrl: map['idPhotoUrl3'],
                              placeholder: (context, url) => const CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Icon(
                              Icons.add_photo_alternate_outlined,
                              size: getProportionateScreenWidth(48),
                              color: kPrimaryColor,
                            )
                      : Image.file(File(idPhoto3.value!.path)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  idPhoto4.value = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                  );
                },
                child: AnimatedContainer(
                  duration: defaultDuration,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(8),
                  height: getProportionateScreenWidth(48),
                  width: getProportionateScreenWidth(48),
                  child: idPhoto4.value == null
                      ? map['idPhotoUrl4'] != null
                          ? CachedNetworkImage(
                              imageUrl: map['idPhotoUrl4'],
                              placeholder: (context, url) => const CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Icon(
                              Icons.add_photo_alternate_outlined,
                              size: getProportionateScreenWidth(48),
                              color: kPrimaryColor,
                            )
                      : Image.file(File(idPhoto4.value!.path)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          MyTextForm(
            label: "Pet Category",
            hint: "Enter pet category",
            icon: Icons.category,
            controller: category,
            readOnly: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kCategoryError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kCategoryError);
                return "";
              }
              return null;
            },
            onTap: () {
              showCupertinoModalBottomSheet(
                context: context,
                enableDrag: false,
                builder: (context) => Material(
                  child: Container(
                    color: Colors.white,
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        category.text = "Normal/Ordinary Pet";
                                        removeError(error: kCategoryError);

                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Normal/Ordinary Pet",
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        category.text = "Exotic Pet";
                                        removeError(error: kCategoryError);
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Exotic Pet",
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },

          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          MyTextForm(
            label: "Pet Breed",
            hint: "Enter your Pet Breed",
            icon: Icons.title,
            controller: title,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kShortDescriptionError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kShortDescriptionError);
                return "";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          MyTextForm(
            label: "Full Description",
            hint: "Enter your full description",
            icon: Icons.description,
            maxLines: 10,
            controller: description,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kFullDescriptionError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kFullDescriptionError);
                return "";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          MyTextForm(
            label: "Type of listing",
            hint: "Enter type of listing",
            icon: Icons.class_,
            controller: type,
            readOnly: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kTypeError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kTypeError);
                return "";
              }
              return null;
            },
            onTap: () {
              showCupertinoModalBottomSheet(
                context: context,
                enableDrag: false,
                builder: (context) => Material(
                  child: Container(
                    color: Colors.white,
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        type.text = "Adopt";
                                        isAmountVisible.value = false;
                                        isDesireTradeDescription.value = false;
                                        removeError(error: kTypeError);
                                        removeError(error: kAskingPriceError);
                                        removeError(error: kDesireTradeError);
                                        removeError(error: kPaymentDetails);
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Adopt",
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        type.text = "Sell";
                                        isAmountVisible.value = true;
                                        isDesireTradeDescription.value = false;
                                        removeError(error: kTypeError);
                                        removeError(error: kDesireTradeError);
                                        removeError(error: kPaymentDetails);
                                        removeError(error: kAskingPriceError);
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Sell",
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        type.text = "Trade";
                                        isAmountVisible.value = false;
                                        isDesireTradeDescription.value = true;
                                        removeError(error: kTypeError);
                                        removeError(error: kAskingPriceError);
                                        removeError(error: kPaymentDetails);
                                        removeError(error: kDesireTradeError);
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Trade",
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          if (isAmountVisible.value)
            Column(
              children: [
                MyTextForm(
                  label: "Asking Price",
                  hint: "Enter your asking price",
                  icon: Icons.payments,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: amount,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kAskingPriceError);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kAskingPriceError);
                      return "";
                    }
                    return null;
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                MyTextForm(
                  label: "Payment Details",
                  hint: "e.g.\nHello, you could pay me using:\nGCash: 09xxxxxxxxx\nMaya: 09xxxxxxxxx,\nBPI: xxxx xxxx xxxx xxx",
                  maxLines: 10,
                  icon: Icons.payments_rounded,
                  controller: paymentDetails,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kPaymentDetails);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kPaymentDetails);
                      return "";
                    }
                    return null;
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          if (isDesireTradeDescription.value)
            Column(
              children: [
                MyTextForm(
                  label: "Desire trade description",
                  hint: "Enter desire trade description",
                  icon: Icons.description,
                  maxLines: 6,
                  controller: desire,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kDesireTradeError);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kDesireTradeError);
                      return "";
                    }
                    return null;
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          FormError(errors: errors.value),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Save Changes",
            press: () async {
              if (formKey.currentState!.validate()) {
                final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                if (uid == '') {
                  InAppNotification.show(
                    child: const NotificationBody(
                      msg: "Unknown Error has occurred",
                    ),
                    context: context,
                  );
                  return;
                }
                final navigator = Navigator.of(context);
                final myContext = context;
                String? idPhotoUrl1, idPhotoUrl2, idPhotoUrl3, idPhotoUrl4;
                if (idPhoto1.value != null) {
                  idPhotoUrl1 = await uploadImage(File(idPhoto1.value!.path));
                }
                if (idPhoto2.value != null) {
                  idPhotoUrl2 = await uploadImage(File(idPhoto2.value!.path));
                }
                if (idPhoto3.value != null) {
                  idPhotoUrl3 = await uploadImage(File(idPhoto3.value!.path));
                }
                if (idPhoto4.value != null) {
                  idPhotoUrl4 = await uploadImage(File(idPhoto4.value!.path));
                }
                if (type.text.trim() == "Adopt") {
                  await FirebaseFirestore.instance.collection('listing').doc(id).update({
                    "title": title.text.trim(),
                    "description": description.text.trim(),
                    "type": "Adopt",
                    "idPhotoUrl1": idPhotoUrl1 ?? map['idPhotoUrl1'],
                    "idPhotoUrl2": idPhotoUrl2 ?? map['idPhotoUrl2'],
                    "idPhotoUrl3": idPhotoUrl3 ?? map['idPhotoUrl3'],
                    "idPhotoUrl4": idPhotoUrl4 ?? map['idPhotoUrl4'],
                    "owner": uid,
                    "status": 'pending',
                    "category":category.text.trim()
                  });
                } else if (type.text.trim() == "Sell") {
                  await FirebaseFirestore.instance.collection('listing').doc(id).update({
                    "title": title.text.trim(),
                    "description": description.text.trim(),
                    "type": "Sell",
                    "price":amount.text.replaceAll(",", "").trim(),
                    "idPhotoUrl1": idPhotoUrl1 ?? map['idPhotoUrl1'],
                    "idPhotoUrl2": idPhotoUrl2 ?? map['idPhotoUrl2'],
                    "idPhotoUrl3": idPhotoUrl3 ?? map['idPhotoUrl3'],
                    "idPhotoUrl4": idPhotoUrl4 ?? map['idPhotoUrl4'],
                    "owner": uid,
                    "status": 'pending',
                    "category":category.text.trim(),
                    "paymentDetails":paymentDetails.text.trim()
                  });
                } else if (type.text.trim() == "Trade") {
                  await FirebaseFirestore.instance.collection('listing').doc(id).update({
                    "title": title.text.trim(),
                    "description": description.text.trim(),
                    "type": "Trade",
                    "desire": desire.text.trim(),
                    "idPhotoUrl1": idPhotoUrl1 ?? map['idPhotoUrl1'],
                    "idPhotoUrl2": idPhotoUrl2 ?? map['idPhotoUrl2'],
                    "idPhotoUrl3": idPhotoUrl3 ?? map['idPhotoUrl3'],
                    "idPhotoUrl4": idPhotoUrl4 ?? map['idPhotoUrl4'],
                    "owner": uid,
                    "status": 'pending',
                    "category":category.text.trim()
                  });
                } else {
                  InAppNotification.show(
                    child: const NotificationBody(
                      msg: "Unknown Error has occurred",
                    ),
                    context: context,
                  );
                  return;
                }

                InAppNotification.show(
                  child: const NotificationBody(
                    msg: "Successfully update listing",
                  ),
                  context: myContext,
                );
                navigator.pop();
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Change status as Done",
            color: Colors.blue,
            press: () async {


              showCupertinoModalBottomSheet(
                context: context,
                enableDrag: false,
                builder: (context) => Material(
                  child: FutureBuilder<QuerySnapshot >(
                    future: FirebaseFirestore.instance.collection('rooms').where("listID", isEqualTo: id).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot > snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          children: const [
                            SizedBox(height: 10),
                            Text(
                              "An unknown error has occurred",
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
                      // if (snapshot.data!.docs.isEmpty) {
                      //   return SizedBox(
                      //     height: MediaQuery.of(context).size.height*0.6,
                      //
                      //     child: Column(
                      //       children: const [
                      //         SizedBox(height: 10),
                      //         Text(
                      //           "You don't have any user listed",
                      //           style: TextStyle(color: kPrimaryColor),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }

                      return SizedBox(
                        height: MediaQuery.of(context).size.height*0.6,
                        child: Column(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Can you specify to whom you ended the listing?",
                                style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(20)),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  thickness: 1.2,
                                ),

                                InkWell(
                                  onTap: () async {
                                    final myContext = context;
                                    final navigator = Navigator.of(context);
                                    await FirebaseFirestore.instance.collection('listing').doc(id).update({"status": "done"});
                                    InAppNotification.show(
                                      child: const NotificationBody(
                                        msg: "Successfully update listing",
                                      ),
                                      context: myContext,
                                    );
                                    navigator.pop();
                                    navigator.pop();
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: getProportionateScreenHeight(10),),
                                      Row(
                                        children: [
                                          const SizedBox(width: 20,),
                                          Text("No one",
                                              style: TextStyle(
                                                fontSize: getProportionateScreenWidth(17),
                                                color: Colors.black,
                                              )),
                                          const SizedBox(width: 10,),
                                        ],
                                      ),
                                      SizedBox(height: getProportionateScreenHeight(10),),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.2,
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  final hasImage = data['imageUrl'] !=null;
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final myContext = context;
                                          final navigator = Navigator.of(context);
                                          await FirebaseFirestore.instance.collection('listing').doc(id).update({
                                            "status": "done",
                                            "buyer":(data["userIds"][0]==FirebaseAuth.instance.currentUser?.uid)?data["userIds"][1]:data["userIds"][0]
                                          });
                                          InAppNotification.show(
                                            child: const NotificationBody(
                                              msg: "Successfully update listing",
                                            ),
                                            context: myContext,
                                          );
                                          navigator.pop();
                                          navigator.pop();
                                        },
                                        child: Padding(
                                          padding:const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: hasImage ? Colors.transparent : Colors.blue,
                                                backgroundImage: hasImage ? CachedNetworkImageProvider(data['imageUrl']) : null,
                                                radius: 20,
                                                child: !hasImage
                                                    ? Text(
                                                  data['user'].isEmpty ? '' : data['user'][0].toUpperCase(),
                                                  style: const TextStyle(color: Colors.white,),
                                                )
                                                    : null,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text("${data['user'] ?? ''}",
                                                    style: TextStyle(
                                                      fontSize: getProportionateScreenWidth(17),
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1.2,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

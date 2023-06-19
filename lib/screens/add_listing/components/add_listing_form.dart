import 'dart:io';

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

class AddListingForm extends HookConsumerWidget {
  const AddListingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final errors = useState<List<String?>>([]);
    final refresh = useState(false);
    final category = useTextEditingController();
    final title = useTextEditingController();
    final description = useTextEditingController();
    final type = useTextEditingController();
    final amount=useTextEditingController();
    final paymentDetails=useTextEditingController();
    final desire=useTextEditingController();
    final isAmountVisible=useState(false);
    final isDesireTradeDescription=useState(false);
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
            style: TextStyle( fontSize: getProportionateScreenWidth(17)),
          ),
          Text(
            "Click on the icons to add image",
            style: TextStyle( fontSize: getProportionateScreenWidth(13),color: kPrimaryColor),
          ),
          GestureDetector(
            onTap: () async {
              idPhoto1.value = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024,);
              // Image.file(File(idPhoto.value!.path))
            },
            child: SizedBox(
              width: getProportionateScreenWidth(200),
              child: AspectRatio(
                aspectRatio: 1,
                child: idPhoto1.value==null?Icon(Icons.add_photo_alternate,
                size: getProportionateScreenWidth(200),
                color: kPrimaryColor,):Image.file(File(idPhoto1.value!.path))
                // Image.asset(widget.product.images[selectedImage]),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  idPhoto2.value = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024,);

                },
                child: AnimatedContainer(
                  duration: defaultDuration,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(8),
                  height: getProportionateScreenWidth(48),
                  width: getProportionateScreenWidth(48),
                  child: idPhoto2.value==null?Icon(Icons.add_photo_alternate_outlined,
                    size: getProportionateScreenWidth(48),
                    color: kPrimaryColor,):Image.file(File(idPhoto2.value!.path)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  idPhoto3.value = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024,);
                },
                child: AnimatedContainer(
                  duration: defaultDuration,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(8),
                  height: getProportionateScreenWidth(48),
                  width: getProportionateScreenWidth(48),
                  child: idPhoto3.value==null?Icon(Icons.add_photo_alternate_outlined,
                    size: getProportionateScreenWidth(48),
                    color: kPrimaryColor,):Image.file(File(idPhoto3.value!.path)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  idPhoto4.value = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024,);
                },
                child: AnimatedContainer(
                  duration: defaultDuration,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(8),
                  height: getProportionateScreenWidth(48),
                  width: getProportionateScreenWidth(48),
                  child: idPhoto4.value==null?Icon(Icons.add_photo_alternate_outlined,
                    size: getProportionateScreenWidth(48),
                    color: kPrimaryColor,):Image.file(File(idPhoto4.value!.path))
                  ,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
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
                                        isAmountVisible.value=false;
                                        isDesireTradeDescription.value=false;
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
                                        isAmountVisible.value=true;
                                        isDesireTradeDescription.value=false;
                                        removeError(error: kTypeError);
                                        removeError(error: kDesireTradeError);
                                        removeError(error: kAskingPriceError);
                                        removeError(error: kPaymentDetails);
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
                                        isAmountVisible.value=false;
                                        isDesireTradeDescription.value=true;
                                        removeError(error: kTypeError);
                                        removeError(error: kDesireTradeError);
                                        removeError(error: kAskingPriceError);
                                        removeError(error: kPaymentDetails);
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
          if(isAmountVisible.value)
          Column(
            children: [
              MyTextForm(
                label: "Asking Price",
                hint: "Enter your asking price",
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          if(isDesireTradeDescription.value)
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
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Add Listing",
            press: () async {

              if (formKey.currentState!.validate()) {
                final navigator = Navigator.of(context);
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
                String? idPhotoUrl1,idPhotoUrl2,idPhotoUrl3,idPhotoUrl4;
                if (idPhoto1.value != null) {
                  idPhotoUrl1 = await uploadImage(File(idPhoto1.value!.path));
                }else{
                  InAppNotification.show(
                    child: const NotificationBody(
                      msg: "You should add a main picture of your pet",
                    ),
                    context: context,
                  );
                  return;
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
                if(type.text.trim()=="Adopt"){

                  await FirebaseFirestore.instance.collection('listing').add({
                    "title": title.text.trim(),
                    "description": description.text.trim(),
                    "type": "Adopt",
                    "idPhotoUrl1":idPhotoUrl1,
                    "idPhotoUrl2":idPhotoUrl2,
                    "idPhotoUrl3":idPhotoUrl3,
                    "idPhotoUrl4":idPhotoUrl4,
                    "owner":uid,
                    "status":"pending",
                    "rated":0,
                    "category":category.text.trim()
                  });
                }else if(type.text.trim()=="Sell"){
                  await FirebaseFirestore.instance.collection('listing').add({
                    "title": title.text.trim(),
                    "description": description.text.trim(),
                    "type": "Sell",
                    "price":amount.text.replaceAll(",", "").trim(),
                    "idPhotoUrl1":idPhotoUrl1,
                    "idPhotoUrl2":idPhotoUrl2,
                    "idPhotoUrl3":idPhotoUrl3,
                    "idPhotoUrl4":idPhotoUrl4,
                    "owner":uid,
                    "status":"pending",
                    "rated":0,
                    "category":category.text.trim(),
                    "paymentDetails":paymentDetails.text.trim()
                  });
                }else if(type.text.trim()=="Trade"){
                  await FirebaseFirestore.instance.collection('listing').add({
                    "title": title.text.trim(),
                    "description": description.text.trim(),
                    "type": "Trade",
                    "desire":desire.text.trim(),
                    "idPhotoUrl1":idPhotoUrl1,
                    "idPhotoUrl2":idPhotoUrl2,
                    "idPhotoUrl3":idPhotoUrl3,
                    "idPhotoUrl4":idPhotoUrl4,
                    "owner":uid,
                    "status":"pending",
                    "rated":0,
                    "category":category.text.trim()
                  });
                }else{
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
                    msg: "Successfully added listing",
                  ),
                  context: context,
                );
                navigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

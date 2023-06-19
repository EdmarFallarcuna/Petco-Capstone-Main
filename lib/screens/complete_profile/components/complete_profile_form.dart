import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:petco/components/default_button.dart';
import 'package:petco/components/form_error.dart';

import '../../../components/my_text_form.dart';
import '../../../components/notification_body.dart';
import '../../../constants.dart';
import '../../../size_config.dart';


class CompleteProfileForm extends HookConsumerWidget {
  const CompleteProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final errors=useState<List<String?>>([]);
    final refresh=useState(false);
    final firstName=useTextEditingController();
    final lastName=useTextEditingController();
    final phoneNumber=useTextEditingController();
    final street=useTextEditingController();
    final city=useTextEditingController();
    final province=useTextEditingController();
    void addError({String? error}) {
      if (!errors.value.contains(error)){
        errors.value.add(error);
        refresh.value=!refresh.value;
      }

    }

    void removeError({String? error}) {
      if (errors.value.contains(error)){
        errors.value.remove(error);
        refresh.value=!refresh.value;
      }

    }

    return Form(
      key: formKey,
      child: Column(
        children: [
        MyTextForm(
        label: "First Name",
        hint: "Enter your first name",
        icon: Icons.person_outline,
        controller: firstName,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kFNameNullError);
          }
          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kFNameNullError);
            return "";
          }
          return null;
        },
      ),
          SizedBox(height: getProportionateScreenHeight(30)),
      MyTextForm(
        label: "Last Name",
        hint: "Enter your last name",
        icon: Icons.person_outline,
        controller: lastName,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kLNameNullError);
          }
          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kLNameNullError);
            return "";
          }
          return null;
        },
      ),
          SizedBox(height: getProportionateScreenHeight(30)),
      MyTextForm(
        label: "Phone Number",
        hint: "Enter your phone number",
        icon: Icons.phone_android_outlined,
        keyboardType: TextInputType.phone,
        controller: phoneNumber,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPhoneNumberNullError);
          }
          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPhoneNumberNullError);
            return "";
          }
          return null;
        },
      ),
          SizedBox(height: getProportionateScreenHeight(30)),
        MyTextForm(
          label: "Street Address",
          hint: "Enter your street address",
          icon: Icons.map_outlined,
          controller: street,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kStreetAddressNullError);
            }
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kStreetAddressNullError);
              return "";
            }
            return null;
          },
        ),
          SizedBox(height: getProportionateScreenHeight(30)),
          MyTextForm(
            label: "City",
            hint: "Enter your city",
            icon: Icons.map_outlined,
            controller: city,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kCityNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kCityNullError);
                return "";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          MyTextForm(
            label: "Province",
            hint: "Enter your province",
            icon: Icons.map_outlined,
            controller: province,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProvinceNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProvinceNullError);
                return "";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors.value),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () {
              if (formKey.currentState!.validate()) {

                final uid=FirebaseAuth.instance.currentUser?.uid??'';
                if(uid==''){
                  InAppNotification.show(
                    child: const NotificationBody(msg: "Unknown Error has occurred",),
                    context: context,
                  );
                  return;
                }


                FirebaseFirestore.instance.collection('users').doc(uid).set({
                  "firstName":firstName.text.trim(),
                  "lastName":lastName.text.trim(),
                  "streetAddress":street.text.trim(),
                  "city":city.text.trim(),
                  "province":province.text.trim(),
                  "contactNumber":phoneNumber.text.trim(),
                  "createdAt":FieldValue.serverTimestamp()
                });
              }
            },
          ),
        ],
      ),
    );
  }
}


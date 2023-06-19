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
import '../../../riverpod/general_provider.dart';
import '../../../size_config.dart';

class SignUpForm extends HookConsumerWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final errors=useState<List<String?>>([]);
    final refresh=useState(false);
    final email=useTextEditingController();
    final password=useTextEditingController();
    final confirmPassword=useTextEditingController();
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
        label: "Email",
        hint: "Enter your email",
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        controller: email,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
            if (emailValidatorRegExp.hasMatch(value)) {
              removeError(error: kInvalidEmailError);
            }
          }

          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          }else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
            return "";
          }
          return null;
        },
      ),
          SizedBox(height: getProportionateScreenHeight(30)),
      MyTextForm(
        label: "Password",
        hint: "Enter your password",
        icon: Icons.lock_outline,
        obscureText: true,
        controller: password,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
            if (value.length >= 8) {
              removeError(error: kShortPassError);
            }
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if (value.length < 8) {
            addError(error: kShortPassError);
            return "";
          }
          return null;
        },

      ),
          SizedBox(height: getProportionateScreenHeight(30)),
      MyTextForm(
        label: "Confirm Password",
        hint: "Re-enter your password",
        icon: Icons.lock_outline,
        obscureText: true,
        controller: confirmPassword,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
            if (value.isNotEmpty && password.text == confirmPassword.text) {
              removeError(error: kMatchPassError);
            }
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if ((password.text != value)) {
            addError(error: kMatchPassError);
            return "";
          }
          return null;
        },

      ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors.value),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text.trim(),
                    password: password.text.trim(),
                  );
                  await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  ref.read(withUserPageProvider.notifier).state = 1;
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    InAppNotification.show(
                      child: const NotificationBody(msg: "The password provided is too weak.",),
                      context: context,);
                  } else if (e.code == 'email-already-in-use') {
                    InAppNotification.show(
                      child: const NotificationBody(msg: "The account already exists for that email.",),
                      context: context,
                    );
                  }
                } catch (e) {
                  InAppNotification.show(
                    child: const NotificationBody(msg: "Unknown Error has occurred",),
                    context: context,
                  );
                }

              }
            },
          ),
        ],
      ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:petco/components/form_error.dart';
import 'package:petco/helper/keyboard.dart';
import 'package:petco/screens/forgot_password/forgot_password_screen.dart';

import '../../../components/default_button.dart';
import '../../../components/my_text_form.dart';
import '../../../components/notification_body.dart';
import '../../../constants.dart';
import '../../../riverpod/general_provider.dart';
import '../../../size_config.dart';


class SignForm extends HookConsumerWidget {
  const SignForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final email=useTextEditingController();
    final password=useTextEditingController();

    final errors=useState<List<String?>>([]);
    final refresh=useState(false);

    void addError({String? error}) {

      if (!errors.value.contains(error)) {
        errors.value.add(error);
        refresh.value=!refresh.value;
      }

    }

    void removeError({String? error}) {
      if (errors.value.contains(error)) {
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
            controller: email,
            keyboardType: TextInputType.emailAddress,
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
              } else if (!emailValidatorRegExp.hasMatch(value)) {
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
            controller: password,
            icon: Icons.lock_outline,
            obscureText: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
                if (value.length >= 8) {
                  removeError(error: kShortPassError);
                }
              }
              return;
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
          FormError(errors: errors.value),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),

          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                try {
                   await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text.trim(),
                      password: password.text.trim()
                  );
                   ref.read(withUserPageProvider.notifier).state = 1;

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    InAppNotification.show(
                      child: const NotificationBody(msg: "Wrong username or password",),
                      context: context,);
                  } else if (e.code == 'wrong-password') {
                    InAppNotification.show(
                      child: const NotificationBody(msg: "Wrong username or password",),
                      context: context,);
                  }
                }

              }
            },
          ),
        ],
      ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:petco/components/default_button.dart';
import 'package:petco/components/form_error.dart';
import 'package:petco/components/my_text_form.dart';
import 'package:petco/components/no_account_text.dart';
import 'package:petco/size_config.dart';

import '../../../components/notification_body.dart';
import '../../../constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              const ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}
class ForgotPassForm extends HookWidget {
  const ForgotPassForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final errors=useState<List<String?>>([]);
    final refresh=useState(false);
    final email=useTextEditingController();

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
          FormError(errors: errors.value),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (formKey.currentState!.validate()) {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                print(email.text);
                InAppNotification.show(
                  child: const NotificationBody(
                    msg: "Successfully sent reset on your email",
                  ),
                  context: context,
                );
                navigator.pop();
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          const NoAccountText(),
        ],
      ),
    );
  }
}

// class ForgotPassForm extends StatefulWidget {
//   const ForgotPassForm({Key? key}) : super(key: key);
//
//   @override
//   ForgotPassFormState createState() => ForgotPassFormState();
// }
//
// class ForgotPassFormState extends State<ForgotPassForm> {
//   final _formKey = GlobalKey<FormState>();
//   List<String> errors = [];
//   String? email;
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

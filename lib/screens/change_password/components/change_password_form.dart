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

class ChangePasswordForm extends HookConsumerWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final errors = useState<List<String?>>([]);
    final refresh = useState(false);
    final currentPassword = useTextEditingController();
    final newPassword = useTextEditingController();
    final confirmPassword = useTextEditingController();

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

    return Form(
      key: formKey,
      child: Column(
        children: [
          MyTextForm(
            label: "Current Password",
            hint: "Enter your current password",
            icon: Icons.lock_outline,
            obscureText: true,
            controller: currentPassword,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          MyTextForm(
            label: "New Password",
            hint: "Enter your new password",
            icon: Icons.lock_outline,
            controller: newPassword,
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
          MyTextForm(
            label: "Confirm Password",
            hint: "Re-type your new password",
            icon: Icons.lock_outline,
            controller: confirmPassword,
            obscureText: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
                if (value.isNotEmpty && newPassword.text == confirmPassword.text) {
                  removeError(error: kMatchPassError);
                }
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if ((newPassword.text != value)) {
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
            text: "continue",
            press: () async {
              if (formKey.currentState!.validate()) {
                var user = FirebaseAuth.instance.currentUser;
                final uid = user?.uid ?? '';
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
                final cred = EmailAuthProvider.credential(email: user!.email!, password: currentPassword.text.trim());
                user.reauthenticateWithCredential(cred).then((value) {
                  user.updatePassword(newPassword.text.trim()).then((value) {
                    InAppNotification.show(
                      child: const NotificationBody(
                        msg: "Successfully changed your password.",
                      ),
                      context: context,
                    );
                    navigator.pop();
                  }).catchError((e) {
                    InAppNotification.show(
                      child: const NotificationBody(
                        msg: "Unknown Error has occurred",
                      ),
                      context: context,
                    );
                  });
                }).catchError((e) {
                  InAppNotification.show(
                    child: const NotificationBody(
                      msg: "Wrong current password",
                    ),
                    context: context,
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

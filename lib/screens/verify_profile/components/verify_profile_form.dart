import 'dart:async';

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

class VerifyProfileForm extends HookConsumerWidget {
  const VerifyProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = useState(30);
    useEffect(
      () {
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (count.value > 0) {
            count.value = count.value - 1;
          }
        });

        return timer.cancel;
      },
      [],
    );
    return Column(
      children: [
        DefaultButton(
          text: "Resend Verification to my Email",
          color: count.value > 0 ? Colors.grey : null,
          press: count.value > 0
              ? null
              : () async {
                  try {
                    if (FirebaseAuth.instance.currentUser?.email != null) {
                      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      // print("success : ${FirebaseAuth.instance.currentUser?.email}");
                    }

                    count.value = 60;
                  } catch (_) {
                    InAppNotification.show(
                      child: const NotificationBody(
                        msg: "Unknown Error has occurred",
                      ),
                      context: context,
                    );
                  }
                },
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(visible: count.value > 0, child: Text("You may resend your verification in ${count.value}seconds"))
      ],
    );
  }
}

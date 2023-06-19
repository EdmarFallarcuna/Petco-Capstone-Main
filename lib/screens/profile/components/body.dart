import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petco/screens/ratings/ratings_screen.dart';

import '../../../riverpod/auth_controller.dart';
import '../../change_password/change_password_screen.dart';
import '../../edit_profile/edit_profile_screen.dart';
import '../../end_user_agreement/enduser_agreement_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends HookConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = useState({});
    final idPhotoUrl = useState<String?>(null);
    useEffect(
      () {
        String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        final subscription = FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((event) {
          map.value = event.data() ?? {};
          idPhotoUrl.value = map.value['imageUrl'];
        });
        return subscription.cancel;
      },
      // when the stream changes, useEffect will call the callback again.
      [],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(
            idPhotoUrl: idPhotoUrl,
          ),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: Icons.person_outline,
            press: () {
              Navigator.pushNamed(
                context,
                EditProfileScreen.routeName,
                arguments: EditProfileArguments(map: map.value),
              );
            },
          ),
          ProfileMenu(
            text: "Change Password",
            icon: Icons.settings_applications_outlined,
            press: () {
              Navigator.pushNamed(
                context,
                ChangePasswordScreen.routeName,
              );

            },
          ),
          ProfileMenu(
            text: "Ratings",
            icon: Icons.star_border_purple500_outlined,
            press: () {
              Navigator.pushNamed(
                context,
                RatingsScreen.routeName,
                arguments: RatingArguments(map: map.value),
              );

            },
          ),
          ProfileMenu(
            text: "End User License Agreement",
            icon: Icons.handshake_outlined,
            press: () {
              Navigator.pushNamed(
                context,
                EndUserAgreementScreen.routeName,
              );
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icons.exit_to_app,
            press: () async {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}

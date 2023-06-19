import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petco/screens/sign_in/sign_in_screen.dart';
import 'package:petco/screens/sign_up/sign_up_screen.dart';
import 'package:petco/screens/splash/splash_screen.dart';
import '../riverpod/general_provider.dart';
import 'error/error_screen.dart';


class WithoutUserPageManager extends ConsumerWidget {
  const WithoutUserPageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(withOutUserPageProvider);

    if (page == -1) {
      return const ErrorScreen();
    } else if (page == 0) {
      return const SplashScreen();
    } else if (page == 1) {
      return const SignInScreen();
    } else if (page == 2) {
      return const SignUpScreen();
    } else {
      return const ErrorScreen();
    }
  }
}

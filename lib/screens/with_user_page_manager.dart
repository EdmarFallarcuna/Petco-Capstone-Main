import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petco/screens/login_success/login_success_screen.dart';
import '../riverpod/general_provider.dart';
import 'error/error_screen.dart';
import 'home/home_screen.dart';


class WithUserPageManager extends ConsumerWidget {
  const WithUserPageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(withUserPageProvider);

    if (page == -1) {
      return const ErrorScreen();
    } else if (page == 0) {
      return const HomeScreen();
    } else if (page == 1) {
      return const LoginSuccessScreen();
    }  else {
      return const ErrorScreen();
    }
  }
}

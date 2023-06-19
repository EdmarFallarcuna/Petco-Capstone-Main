import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petco/screens/complete_profile/complete_profile_screen.dart';
import 'package:petco/screens/loading/loading_screen.dart';
import 'package:petco/screens/verify_profile/verify_profile_screen.dart';
import 'package:petco/screens/with_user_page_manager.dart';
import 'package:petco/screens/without_user_page_manager.dart';
import 'package:petco/size_config.dart';
import '../riverpod/general_provider.dart';
import 'error/error_screen.dart';


class MainPageManager extends ConsumerWidget {
  const MainPageManager({Key? key}) : super(key: key);
  static String routeName = "/mainManager";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(mainPageProvider);
    SizeConfig().init(context);
    // return const VerifyProfileScreen();
    if (page == -1) {
      return const ErrorScreen();
    } else if (page == 0) {
      return const LoadingScreen();
    } else if (page == 1) {
      return const WithoutUserPageManager();
    } else if (page == 2) {
      return const WithUserPageManager();
    } else if (page == 3) {
      return const CompleteProfileScreen();
    } else if (page == 4) {
      return const VerifyProfileScreen();
    }  else {
      return const ErrorScreen();
    }
  }
}

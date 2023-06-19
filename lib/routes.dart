

import 'package:flutter/widgets.dart';
import 'package:petco/screens/add_listing/add_listing_screen.dart';
import 'package:petco/screens/change_password/change_password_screen.dart';
import 'package:petco/screens/complete_profile/complete_profile_screen.dart';
import 'package:petco/screens/details/details_screen.dart';
import 'package:petco/screens/edit_listing/edit_listing_screen.dart';
import 'package:petco/screens/edit_profile/edit_profile_screen.dart';
import 'package:petco/screens/end_user_agreement/enduser_agreement_screen.dart';
import 'package:petco/screens/forgot_password/forgot_password_screen.dart';
import 'package:petco/screens/home/home_screen.dart';
import 'package:petco/screens/login_success/login_success_screen.dart';
import 'package:petco/screens/main_page_manager.dart';
import 'package:petco/screens/profile/profile_screen.dart';
import 'package:petco/screens/ratings/ratings_screen.dart';
import 'package:petco/screens/sign_in/sign_in_screen.dart';
import 'package:petco/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  MainPageManager.routeName:(context) => const MainPageManager(),
  AddListingScreen.routeName:(context)=>const AddListingScreen(),
  EditProfileScreen.routeName:(context)=>const EditProfileScreen(),
  ChangePasswordScreen.routeName:(context)=>const ChangePasswordScreen(),
  EditListingScreen.routeName:(context)=>const EditListingScreen(),
  RatingsScreen.routeName:(context)=>const RatingsScreen(),
  EndUserAgreementScreen.routeName:(context)=>const EndUserAgreementScreen(),
};

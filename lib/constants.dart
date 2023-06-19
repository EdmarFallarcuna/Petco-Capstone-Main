import 'package:flutter/material.dart';
import 'package:petco/size_config.dart';

const kPrimaryColor = Color(0xFF00af43);
const kPrimaryLightColor = Color(0xFFFFECDF);

const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kFNameNullError = "Please Enter your first name";
const String kLNameNullError = "Please Enter your last name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kStreetAddressNullError = "Please Enter your street address";
const String kCityNullError = "Please Enter your city";
const String kProvinceNullError = "Please Enter your province";
const String kShortDescriptionError = "Please Enter your short description";
const String kFullDescriptionError = "Please Enter your full description";
const String kTypeError = "Please Enter the type of listing";
const String kCategoryError = "Please Enter the category of listing";
const String kAskingPriceError = "Please Enter your asking price";
const String kPaymentDetails = "Please Enter your payment details";
const String kDesireTradeError = "Please Enter your desire trade";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

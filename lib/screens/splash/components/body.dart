import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petco/constants.dart';
import 'package:petco/riverpod/general_provider.dart';
import 'package:petco/size_config.dart';

import '../components/splash_content.dart';
import '../../../components/default_button.dart';



class Body extends HookConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentPage=useState(0);
    List<Map<String, String>> splashData = [
      {
        "text": "Welcome to PETCO,\ntrade, adopt and sell pets!",
        "image": "assets/lottie/splash3.json"
      },
      {
        "text":
        "We help our little pets \nearn their home and love they deserve",
        "image": "assets/lottie/splash1.json"
      },
      {
        "text": "We show the easy way to connect \nto our hearts.",
        "image": "assets/lottie/splash2.json"
      },
    ];

    AnimatedContainer buildDot({int? index}) {
      return AnimatedContainer(
        duration: kAnimationDuration,
        margin: const EdgeInsets.only(right: 5),
        height: 6,
        width: currentPage.value == index ? 20 : 6,
        decoration: BoxDecoration(
          color: currentPage.value == index ? kPrimaryColor : const Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(3),
        ),
      );
    }


    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  currentPage.value = value;

                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        ref.read(withOutUserPageProvider.notifier).state = 1;
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





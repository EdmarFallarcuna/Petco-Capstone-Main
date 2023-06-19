import 'package:flutter/material.dart';
import 'package:petco/screens/home/components/adopt/adopt_body.dart';
import 'package:petco/screens/home/components/sell/sell_body.dart';
import 'package:petco/screens/home/components/trade/trade_body.dart';
import 'package:tab_container/tab_container.dart';

import '../../../constants.dart';
import 'categories.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 7, left: 10, right: 10),
        child: TabContainer(

          color: kPrimaryColor,
          isStringTabs: false,
          tabs: [
            CategoryCard(text: 'Adopt', press: () {  }, icon: Icons.pets,),
            CategoryCard(text: 'Sell', press: () {  }, icon: Icons.store,),
            CategoryCard(text: 'Trade', press: () {  }, icon: Icons.handshake,),
          ],
          children: const [
           AdoptBody(),
           SellBody(),
          TradeBody(),
          ],
        ),
      ),
    );
  }
}

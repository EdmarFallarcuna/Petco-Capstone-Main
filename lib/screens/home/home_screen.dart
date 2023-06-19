import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petco/screens/listing/listing_screen.dart';

import '../chat/chat_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import 'components/body.dart';

class HomeScreen extends HookWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final currentIndex=useState(0);
    Widget _buildTitle() {
      return CustomNavigationBar(
        iconSize: 30.0,
        selectedColor: const Color(0xff040307),
        strokeColor: const Color(0x30040307),
        unSelectedColor: const Color(0xffacacac),
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text("Favorite"),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.chat),
            title: const Text("Chat"),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.list),
            title: const Text("Your List"),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            title: const Text("Me"),
          ),
        ],
        currentIndex: currentIndex.value,
        onTap: (index) {
          currentIndex.value=index;
        },
      );
    }
    Widget _buildBody() {
      if(currentIndex.value==0){
        return const Body();
      }else if(currentIndex.value==1){
        return const FavoritesScreen();
      }else if(currentIndex.value==2){
        return const ChatScreen();
      }else if(currentIndex.value==3){
        return const ListingScreen();
      }else if(currentIndex.value==4){
        return const ProfileScreen();
      }else{
        return const Body();
      }

    }
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildTitle(),
    );
  }
}

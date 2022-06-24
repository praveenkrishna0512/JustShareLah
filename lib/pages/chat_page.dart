import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Chat"), context, '/feed'),
      body: ListView(
        children: [
          Text("Chat"),
          MySlider(),
        ],
        // ignore: prefer_const_constructors
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}

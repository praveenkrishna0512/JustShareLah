// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/utils/apptheme.dart';
import 'package:justsharelah_v1/models/ForRenting.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:supabase/supabase.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:justsharelah_v1/models/ForBorrowing.dart';
import '../models/ListingCard.dart';
import 'chat_page.dart';
import 'addListing.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:justsharelah_v1/models/listings.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _searchController = TextEditingController();
  var _loading = false;
  // Index for bottom nav bar
  int _selectedIndex = 0;

  // List of next pages to go to

  // // Routing for bottom nav bar
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _loading = true;
  //   });
  //   switch (index) {
  //     case 0:
  //       // _navigatorKey.currentState!.pushNamed("/chat");
  //       break;
  //     case 1:
  //       // _navigatorKey.currentState!.pushNamed("/addlisting");
  //       break;
  //     case 2:
  //       Navigator.of(context).pushNamed("/account");
  //       break;
  //   }
  //   setState(() {
  //     _selectedIndex = index;
  //     _loading = false;
  //   });
  // }

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile(String userId) async {
    // setState(() {
    //   _loading = true;
    // });
    // final response = await supabase
    //     .from('profiles')
    //     .select()
    //     .eq('id', userId)
    //     .single()
    //     .execute();
    // final error = response.error;
    // if (error != null && response.status != 406) {
    //   context.showErrorSnackBar(message: error.message);
    // }
    // final data = response.data;
    // if (data != null) {
    //   _usernameController.text = (data['username'] ?? '') as String;
    //   _websiteController.text = (data['website'] ?? '') as String;
    // }
    // setState(() {
    //   _loading = false;
    // });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService().signOut();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 35),
              child: Text("Logout"),
            ),
          ]),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/location.png', width: 40, height: 30),
            const SizedBox(width: 10.0),
            Text(
              "NUS, Singapore",
            )
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore",
                  style: kJustShareLahStyle.copyWith(
                      fontSize: 35, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Listings For You',
                  style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
                ),
                const SizedBox(height: defaultPadding),
                ForBorrowing(),
                const SizedBox(height: defaultPadding),
                ForRenting()
              ],
            ),
          ],
        ),
      ),
      //TODO: LISTINGS DONT AUTO UPDATE ON FEED PAGE AFTER LISTING IS ADDED
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}

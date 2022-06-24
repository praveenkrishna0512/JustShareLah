import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class MakeReviewPage extends StatefulWidget {
  const MakeReviewPage({Key? key}) : super(key: key);

  @override
  State<MakeReviewPage> createState() => _MakeReviewPageState();
}

class _MakeReviewPageState extends State<MakeReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar()
          .buildAppBar(const Text("Leave A Review"), context, '/feed'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "How was the experience?",
                style: kBodyText.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Give John a rating out of 10",
              style: TextStyle(
                  fontFamily: "Lato",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300),
            ),
            MySlider(),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Write a review for the buyer",
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              obscureText: false,
              textAlign: TextAlign.center,
              minLines: 4,
              maxLines: 6,
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Describe the experience',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtonField(
                    "CANCEL", Colors.red, 20.0, context, FeedPage()),
                SizedBox(width: 10.0),
                buildButtonField(
                    "SUBMIT", Colors.green, 20.0, context, ProfilePage()),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}

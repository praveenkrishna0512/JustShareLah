import 'package:flutter/material.dart';

class MyBottomNavBar {
  List<String> widgetPages = <String>[
    "/feed",
    "/chat",
    "/addlisting",
    "/activity",
    "/profile",
  ];

  BottomNavigationBar buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          activeIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo_outlined),
          activeIcon: Icon(Icons.add_a_photo_rounded),
          label: 'Add Listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active_outlined),
          activeIcon: Icon(Icons.notification_add),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          activeIcon: Icon(Icons.person),
          label: 'User Profile',
        ),
      ],
      onTap: (index) {
        String selectedRoute = widgetPages.elementAt(index);
        Navigator.of(context).pushNamed(selectedRoute).then(
          (_) => null);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sportseventapp/ui/Homepage/AboutPage/aboutPage.dart';
import 'package:sportseventapp/ui/Homepage/onGoing/eventPage.dart';
import 'package:sportseventapp/ui/Homepage/FavoritesPage/favoritesPage.dart';

import '../ui/Homepage/homepage.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  //list of widgets that build the main pages
  final List<Widget> pages = [
    Homepage(key: PageStorageKey('homepage')),
    EventPage(key: PageStorageKey('events')),
    Favorites(key: PageStorageKey('favorites')),
    AboutPage(key: PageStorageKey('about'))
  ];

  //instance of the bucket that will store the keys and states
  final PageStorageBucket bucket = PageStorageBucket();

  //index that will be used to access the pages in the pages list
  int _selectedIndex = 0;

  Widget _bottomNavBarUI(int selectedIndex) {
     return BottomNavigationBar(
       //defines the first index to be shown
        currentIndex: _selectedIndex,
       //defines the behavior of the NavBar onTap
        onTap: (int index) => setState(() {_selectedIndex = index;}),
       //UI details
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Color(0xff38aac3),
        iconSize: 27,
        type: BottomNavigationBarType.fixed,
        //items on the nav bar
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        bottomNavigationBar: _bottomNavBarUI(_selectedIndex),
        body: PageStorage(
          child: pages[_selectedIndex],
          bucket: bucket,
        ));
  }
}

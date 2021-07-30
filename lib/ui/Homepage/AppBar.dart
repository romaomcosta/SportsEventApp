import 'package:flutter/material.dart';


class AppBars {
// APP BAR HOMEPAGE //
  Widget mainAppBar(String title) {
    return PreferredSize( //change size of appBar
        preferredSize: Size.fromHeight(60.0), //height of the appBar
        child: AppBar(
            backgroundColor: Color(0xff38aac3),
            automaticallyImplyLeading: false, //hide hamburger icon
            title: Text(title),
            actions: [
              IconButton( //adds icons in right of appbar
                onPressed: () {
                                 }, //define behavior
                icon: Icon(Icons.search,
                color: Colors.white,
                size: 30,
              ),
            ),
          ]
        )
      );
    }

  Widget secondaryAppBar(String title) {
    return PreferredSize( //change size of appBar
        preferredSize: Size.fromHeight(60.0), //height of the appBar
        child: AppBar(
            backgroundColor: Color(0xff38aac3),
            automaticallyImplyLeading: false, //hide hamburger icon
            title: Text(title)
        )
    );
  }
}


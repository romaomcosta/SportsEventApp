import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportseventapp/ui/Homepage/mainEventList.dart';


class Homepage extends StatefulWidget {
  Homepage({Key key}): super(key:key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MainEventsList(),
    );
  }
}







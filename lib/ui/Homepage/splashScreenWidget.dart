
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sportseventapp/handlers/bottomNavigationBarController.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        //will load this widget after splash screen finished being displayed
        navigateAfterSeconds: new BottomNavBar(),
        title: new Text('A mobile application for tracking sport-related events',
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontStyle: FontStyle.italic,
              //fontWeight: FontWeight.bold,
              fontSize: 12.0,
            color: Colors.white
          ),),
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff38aac3),
            Color(0xff9bd4e1)
          ],
        ),
        image: Image.asset("assets/sporteventswhite.png"),
        photoSize: 130.0,
        loaderColor: Colors.white);
  }
}

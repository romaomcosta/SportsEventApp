import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportseventapp/ui/Homepage/AppBar.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<String> versionInfo = [];
  String _projectVersion = '';
  String _projectBuildNumber = '';

  appDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _projectVersion = packageInfo.version;
      _projectBuildNumber = packageInfo.buildNumber;
    }
    );
  }
  Widget aboutPage() {
    appDetails();
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Sport Events",
                    style: TextStyle(
                        color: Color(0xff38aac3),
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  )),
              Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "A mobile application for tracking sport-related events",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        color: Colors.black54),
                  )),
              SizedBox(
                height: 10,
              ),
              Center(
                  child:  Image.asset("assets/sporteventsblack.png", width: 250,
              )),
              Container(
                  padding:
                      EdgeInsets.only(left: 35, right: 35, top: 20, bottom: 30),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                        "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
                        "nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in "
                        "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
                        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt "
                        "mollit anim id est laborum.",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 11),
                  )),
              Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                      child: Text(
                    "Powered by",
                    style: TextStyle(
                        color: Color(0xff38aac3), fontWeight: FontWeight.w500),
                  ))),
              Container(
                  width: 150,
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Center(child: Image.asset("assets/cybermap.png"))),
              Container(
                  child: Text("App version: " +
                      _projectVersion +
                      ". Build number: " +
                      _projectBuildNumber +
                      ".", style: TextStyle(color: Colors.black54, fontSize: 11),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return PreferredSize(
        //change size of appBar
        preferredSize: Size.fromHeight(60.0), //height of the appBar
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBars().secondaryAppBar("About us"),
            body: aboutPage()));
  }
}

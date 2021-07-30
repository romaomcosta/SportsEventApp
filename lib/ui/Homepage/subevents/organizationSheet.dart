import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart' as eSysFS;
import 'package:sportseventapp/models/Member.dart';

// ignore: must_be_immutable
class OrganizationSheet extends StatefulWidget {
  List<Member> pickedMember = [];

  OrganizationSheet({this.pickedMember, Key key}) : super(key: key);

  @override
  _OrganizationSheetState createState() =>
      _OrganizationSheetState(pickedMember);
}

class _OrganizationSheetState extends State<OrganizationSheet> {
  List<Member> pickedMember = [];
  GlobalKey globalKey = GlobalKey();

  _OrganizationSheetState(this.pickedMember);

  @override
  Widget build(BuildContext context) {
    void navigateBack() {
      Navigator.pop(context);
    }

    void convertWidgetToImg() async {
      RenderRepaintBoundary renderRepaintBoundary = globalKey.currentContext
          .findRenderObject(); //creates "duplicate" of a widget
      ui.Image boxImage = await renderRepaintBoundary.toImage(
          pixelRatio:
              2); //returns a future; waits until repaintBoundary converts view to image
      ByteData byteData = await boxImage.toByteData(
          format: ui.ImageByteFormat.png); //get data from image ^

      await eSysFS.Share.file('Share this now!', 'esys.png',
          byteData.buffer.asUint8List(), 'image/png',
          text: 'Test');
    }

    Widget organizationSheet() {
      //after entering the team page, user will see the team sheet with all the info about the picked team
      return Scaffold(
        body: new Container(
            padding: EdgeInsets.all(9.0),
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    Container(
                        padding: EdgeInsets.only(top: 20, bottom: 30),
                        child: Text(pickedMember[0].organization,
                            style: TextStyle(
                                color: Color(0xff38aac3),
                                fontWeight: FontWeight.w700,
                                fontSize: 23))),
                    Container(
                        width: 150,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff38aac3), width: 5)),
                        child: FadeInImage.assetNetwork(
                                placeholder: ("assets/ph-1.png"),
                                image: pickedMember[0].orgPic)
                        ),
                    SizedBox(height: 20),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: EdgeInsets.all(5),
                        child: Text(
                          pickedMember[0].orgDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //color: Colors.black54,
                            height: 2,
                            fontSize: 13,
                          ),
                        ))
                  ]);
                })),
      );
    }

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          navigateBack();
        },
        child: PreferredSize(
            //change size of appBar
            preferredSize: Size.fromHeight(60.0), //height of the appBar
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Center(child: Icon(Icons.share)),
                  backgroundColor: Color(0xff38aac3),
                  onPressed: () {
                    convertWidgetToImg();
                  },
                  //share(context, pickedEvent[0]),
                ),
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Color(0xff38aac3),
                  automaticallyImplyLeading: false,
                  //hide hamburger icon
                  title: Text("Club's sheet"),
                  leading: IconButton(
                    //adds icons in right of appbar
                    onPressed: () {
                      navigateBack();
                    }, //define behavior
                    icon: Icon(
                      Icons.navigate_before,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                body: RepaintBoundary(
                    key: globalKey, child: organizationSheet()))));
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sportseventapp/ui/Homepage/subevents/individualCompetitor.dart';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart' as eSysFS;
import 'package:sportseventapp/models/Event.dart';
import 'package:sportseventapp/models/Participant.dart';
import 'package:sportseventapp/models/Member.dart';

/// SOCCER ONLY - TEAM SHEET WITH ALL THE INFO ABOUT PICKED TEAM ///

// ignore: must_be_immutable
class CompetitorPage extends StatefulWidget {
  List<Event> pickedEvent = [];
  List<Participant> pickedParticipant = []; //teams of soccer event
  int backIndex;

  CompetitorPage({this.backIndex, this.pickedParticipant, this.pickedEvent, Key key})
      : super(key: key);

  @override
  _CompetitorPageState createState() =>
      _CompetitorPageState(backIndex, pickedParticipant, pickedEvent);
}

class _CompetitorPageState extends State<CompetitorPage> {
  List<Event> pickedEvent = [];
  List<Participant> pickedParticipant = [];
  int backIndex;
  List<Member> pickedMember = []; //team selected by user will be allocated here and used in IndividualCompetitor
  int currentIndex; //will keep the index of the current page for back-navigation purposes
  GlobalKey globalKey = GlobalKey();

  _CompetitorPageState(this.backIndex, this.pickedParticipant, this.pickedEvent);

  void navigateBackMainEvent() {
    Navigator.pop(context);
    pickedParticipant.clear();
  }

  void navigateToIndividualsProfile() { //for road run
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return IndividualCompetitor(
          pickedMember: pickedMember, pickedParticipant: pickedParticipant,);
    }));
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

  /// soccer ///

  Widget showTeamPicture() {
    return Column(children: [
      Container(
          padding: EdgeInsets.only(top: 18),
          child: Text(
            pickedParticipant[0].name,
            style: TextStyle(
                color: Color(0xff38aac3),
                fontWeight: FontWeight.w700,
                fontSize: 23),
          )),
      Container(
          width: 200,
          padding: EdgeInsets.all(20),
          child: FadeInImage.assetNetwork(placeholder: 'assets/ph-1.png', image: pickedParticipant[0].picture))
    ]);
  }

  Widget getDescription() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: (pickedParticipant[0].description != null)
            ? Text(
                pickedParticipant[0].description,
                style: TextStyle(height: 2, color: Colors.black54),
                textAlign: TextAlign.justify,
              )
            : Container());
  }

  Widget teamSheet() { //after entering the team page, user will see the team sheet with all the info about the picked team
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Center(child: Icon(Icons.share)),
        backgroundColor: Color(0xff38aac3),
        onPressed: () {
          convertWidgetToImg();
        },
      ),
      body: new Container(
          padding: EdgeInsets.all(9.0),
          child: ListView.builder(
              itemCount: pickedParticipant[0].members.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                    children: (index == 0)
                        ? [
                            showTeamPicture(),
                            getDescription(),
                            Container(
                                padding: EdgeInsets.only(top: 28, bottom: 20),
                                child: Text("Members",
                                    style: TextStyle(
                                        color: Color(0xff38aac3),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 23))),
                            new GestureDetector(
                                onTap: () {
                                  pickedMember
                                      .add(pickedParticipant[0].members[0]);
                                  navigateToIndividualsProfile();
                                },
                                child: new Container(
                                  width: 280.0,
                                  padding: new EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10,
                                      bottom: 10),
                                  color: Color(0xffF0F0F0),
                                  child: new Column(children: [
                                    Text(
                                      pickedParticipant[0].members[0].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black54),
                                      maxLines: 2,
                                    ),
                                  ]),
                                )),
                            Container(
                              padding: EdgeInsets.all(5),
                            )
                          ]
                        : [
                            new GestureDetector(
                                onTap: () {
                                  pickedMember
                                      .add(pickedParticipant[0].members[index]);
                                  pickedParticipant.add(pickedParticipant[0]);
                                  navigateToIndividualsProfile();
                                },
                                child: new Container(
                                  width: 280.0,
                                  padding: new EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10,
                                      bottom: 10),
                                  color: Color(0xffF0F0F0),
                                  child: new Column(children: [
                                    Text(
                                      pickedParticipant[0].members[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black54),
                                      maxLines: 2,
                                    ),
                                  ]),
                                )),
                            Container(padding: EdgeInsets.all(5))
                          ]);
              })),
    );
  }

  /// end soccer ///


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          navigateBackMainEvent();
        },
        child: PreferredSize(
            //change size of appBar
            preferredSize: Size.fromHeight(60.0), //height of the appBar
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Color(0xff38aac3),
                  automaticallyImplyLeading: false,
                  //hide hamburger icon
                  title: Text(pickedParticipant[0].name + " sheet"),
                  leading: IconButton(
                    //adds icons in right of appbar
                    onPressed: () {
                      navigateBackMainEvent();
                    }, //define behavior
                    icon: Icon(
                      Icons.navigate_before,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                body: RepaintBoundary(key: globalKey, child: teamSheet()))));
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart' as eSysFS;
import 'organizationSheet.dart';
import 'package:sportseventapp/models/Member.dart';
import 'package:sportseventapp/models/Participant.dart';

// ignore: must_be_immutable
class IndividualCompetitor extends StatefulWidget {
  List<Member> pickedMember = [];
  List<Participant> pickedParticipant = [];

  IndividualCompetitor({this.pickedMember, this.pickedParticipant, Key key})
      : super(key: key);

  @override
  _IndividualCompetitorState createState() =>
      _IndividualCompetitorState(pickedMember, pickedParticipant);
}

class _IndividualCompetitorState extends State<IndividualCompetitor> {
  List<Member> pickedMember = [];
  List<Participant> pickedParticipant = [];
  GlobalKey globalKey = GlobalKey();

  _IndividualCompetitorState(this.pickedMember, this.pickedParticipant);

  void navigateBack() {
    Navigator.pop(context);
    pickedMember.clear();
  }

  void navigateToOrganizationProfile() { //for road run
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrganizationSheet(pickedMember: pickedMember);
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
    Uint8List uInt8list = byteData.buffer.asUint8List();
    await eSysFS.Share.file('Share this now!', 'esys.png',
        uInt8list, 'image/png',
        text: 'My optional text.');
  }

  Widget infoIndividual(String title, String value) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(title + ": ",
          style: TextStyle(
              color: Color(0xff38aac3),
              fontSize: 15,
              fontWeight: FontWeight.w700)),
      Text(value, style: TextStyle(color: Colors.black54, fontSize: 15))
    ]));
  }

  Widget individualsComponentsSoccer() {
    return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
                child: Text(
                  pickedMember[0].name,
                  style: TextStyle(
                      color: Color(0xff38aac3),
                      fontWeight: FontWeight.w700,
                      fontSize: 23),
                )),
            SizedBox(height: 20),
            Stack(children: [
              Container(
                  width: 170,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff38aac3), width: 5)),
                  child: (pickedMember[0].picture != null) ? FadeInImage.assetNetwork(image: pickedMember[0].picture, placeholder: 'assets/ph-1.png',) : Image.asset('assets/ph-1.png', height: 160,)),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        navigateBack();
                      },
                      child: CircleAvatar(
                        radius: 29,
                        backgroundImage:
                        (pickedParticipant[0].picture != null) ? NetworkImage(pickedParticipant[0].picture) : Image.asset('assets/ph-1.png', height: 160,),
                        backgroundColor: Color(0xff38aac3),
                      )))
            ]),
            SizedBox(height: 26),
            infoIndividual("HOMETOWN ", ((pickedMember[0].country != null) ? pickedMember[0].country : "N/A")),
            SizedBox(height: 12),
            infoIndividual("BIRTHDATE ", ((pickedMember[0].birthDate != null) ? pickedMember[0].birthDate : "N/A")),
            SizedBox(height: 12),
            infoIndividual("POSITION ", ((pickedMember[0].position != null) ? pickedMember[0].position : "N/A")),
            SizedBox(height: 12),
            infoIndividual("CAREER ", ((pickedMember[0].career != null) ? pickedMember[0].career : "N/A")),
          ],
        ));}

  Widget individualsComponentsRunner() {
    return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
                child: Text(
                  pickedMember[0].name,
                  style: TextStyle(
                      color: Color(0xff38aac3),
                      fontWeight: FontWeight.w700,
                      fontSize: 23),
                )),
            SizedBox(height: 20),
            Stack(children: [
              Container(
                  width: 170,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff38aac3), width: 5)),
                  child: (pickedMember[0].picture != null) ? FadeInImage.assetNetwork(image: pickedMember[0].picture, placeholder: 'assets/ph-1.png',) : Image.asset('assets/ph-1.png', height: 160,)),
               Positioned(
                  bottom: 0,
                  right: 0,
                  child:  GestureDetector(
                      onTap: () {
                        navigateToOrganizationProfile();
                      },
                      child: (pickedMember[0].orgPic != "") ? CircleAvatar(
                        radius: 29,
                        backgroundImage:
                        (pickedMember[0].orgPic != null) ? NetworkImage(pickedMember[0].orgPic) : Image.asset('assets/ph-1.png', height: 160,),
                        backgroundColor: Color(0xff38aac3),
                      ) : Container()))
            ]),
            SizedBox(height: 26),
            infoIndividual("HOMETOWN ", ((pickedMember[0].country != null) ? pickedMember[0].country : "N/A")),
            SizedBox(height: 12),
            infoIndividual("AGE ", ((pickedMember[0].age != null) ? pickedMember[0].age : "N/A")),
            SizedBox(height: 12),
            infoIndividual("CAREER ", ((pickedMember[0].career != null) ? pickedMember[0].country : "N/A")),
          ],
        ));
  }

  Widget individualSheet() {
    return Scaffold(
    body: (pickedMember[0].organization != null) ? individualsComponentsRunner() :individualsComponentsSoccer() );
  }


  @override
  Widget build(BuildContext context) {
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
                  title: Text("Individual's sheet"),
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
                    key: globalKey, child: individualSheet()))));
  }
}


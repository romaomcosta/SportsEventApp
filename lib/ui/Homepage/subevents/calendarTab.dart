import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sportseventapp/models/Calendar.dart';
import 'package:sportseventapp/ui/Homepage/FavoritesPage/favoritesPage.dart';
import 'package:sportseventapp/ui/Homepage/subevents/competitorsPage.dart';
import 'package:sportseventapp/ui/Homepage/subevents/individualCompetitor.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:random_color/random_color.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart' as eSysFS;
import 'package:sportseventapp/models/Event.dart';
import 'package:sportseventapp/models/Member.dart';
import 'package:sportseventapp/models/Participant.dart';

//whenever user taps on an event, that event will be stored in this list
List<Event> suggestedEvents = <Event>[];

// ignore: must_be_immutable
class CalendarTab extends StatefulWidget {
  int backIndex;
  List<Event> pickedEvent = [];

  CalendarTab({this.backIndex, this.pickedEvent, Key key}) : super(key: key);

  @override
  _CalendarTabState createState() => _CalendarTabState(pickedEvent);
}

class _CalendarTabState extends State<CalendarTab> {
  GlobalKey globalKey = GlobalKey();
  List<Event> pickedEvent =
      []; //keeps the event that was picked on the homepage
  List<Member> runners = <Member>[]; // for runners

  ///for competitors' page
  List<Participant> pickedParticipant =
      []; //will put the picked participant here
  int currentIndex; //will keep the index of the current page for back-navigation purposes
  List<Member> pickedMember = [];

  _CalendarTabState(this.pickedEvent);

  void navigateBack() {
    Navigator.pop(context);
    pickedEvent
        .clear(); //clears the pickedEvent list so it doesn't keep adding events
  }

  void navigateToCompetitorsPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CompetitorPage(
          backIndex: currentIndex, pickedParticipant: pickedParticipant);
    }));
  }

  void navigateToRunnerPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return IndividualCompetitor(pickedMember: pickedMember);
    }));
  }

  void convertWidgetToImg() async {
    //creates "duplicate" of a widget
    RenderRepaintBoundary renderRepaintBoundary =
        globalKey.currentContext.findRenderObject();
    //returns a future; waits until repaintBoundary converts view to image
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 2);
    //gets data from image ^
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    await eSysFS.Share.file('Share this now!', 'esys.png',
        byteData.buffer.asUint8List(), 'image/png',
        text: 'My optional text.');
  }

  /// Puts stats of each team, considering its name, on a list; returns it
  getStatsTeam(String teamName) {
    int globalScore = 0;
    int wins = 0;
    int defeats = 0;
    int totalGames = 0;
    int draws = 0;
    int scoredGoals = 0;
    int concededGoals = 0;
    List<String> stats = [];
    
    for (var match in pickedEvent[0].calendar) {
      if (!(match.scoret2 == "" && match.scoret1 == "")) {
        if (match.team1 == teamName) {
          if (int.parse(match.scoret1) > int.parse(match.scoret2)) {
            wins += 1;
            globalScore += 3;
          }
          if (int.parse(match.scoret1) == int.parse(match.scoret2)) {
            globalScore += 1;
            draws += 1;
          }
          if (int.parse(match.scoret1) < int.parse(match.scoret2)) {
            defeats += 1;
          }
          scoredGoals += int.parse(match.scoret1);
          concededGoals += int.parse(match.scoret2);
        }
        if (match.team2 == teamName) {
          if (int.parse(match.scoret1) < int.parse(match.scoret2)) {
            wins += 1;
            globalScore += 3;
          }
          if (int.parse(match.scoret1) == int.parse(match.scoret2)) {
            globalScore += 1;
            draws += 1;
          }
          if (int.parse(match.scoret1) > int.parse(match.scoret2)) {
            defeats += 1;
          }
          scoredGoals += int.parse(match.scoret2);
          concededGoals += int.parse(match.scoret1);
        }
      }
    }
    totalGames = wins + defeats + draws;
    stats.add(globalScore.toString());
    stats.add(wins.toString());
    stats.add(draws.toString());
    stats.add(defeats.toString());
    stats.add(totalGames.toString());
    stats.add(scoredGoals.toString());
    stats.add(concededGoals.toString());
    return stats;
  }

  /// statistic related
  List<charts.Series<SoccerStats, String>> seriesData;

  Map<String, double> teamsSGInfo = new Map();
  Map<String, double> teamsCG = new Map();

  generateTeamStatsInfo() {
    List<SoccerStats> soccerData = <SoccerStats>[];
    var participantsList = pickedEvent[0].participants;

    for (var i = 0; i < participantsList.length; i++) {
      String teamName = participantsList[i].name;
      teamsSGInfo.putIfAbsent(
          teamName, () => double.parse(getStatsTeam(teamName)[5]));
      teamsCG.putIfAbsent(
          teamName, () => double.parse(getStatsTeam(teamName)[6]));

      var statsTeam = new SoccerStats(
        participant: participantsList[i].name,
        valueSG: getStatsTeam(participantsList[i].name)[5],
        wins: getStatsTeam(participantsList[i].name)[1],
        draws: getStatsTeam(participantsList[i].name)[2],
        losses: getStatsTeam(participantsList[i].name)[3],
        valueCG: getStatsTeam(participantsList[i].name)[6],
      );
      soccerData.add(statsTeam);
    }

    //data to be considered in bar chart
    seriesData.add(charts.Series(
      data: soccerData,
      domainFn: (SoccerStats stats, _) => stats.participant,
      measureFn: (SoccerStats stats, _) => double.parse(stats.wins),
      colorFn: (SoccerStats stats, _) =>
          charts.ColorUtil.fromDartColor(Color(0xff49A3BC)),
      id: "Wins",
    ));
    seriesData.add(charts.Series(
      data: soccerData,
      domainFn: (SoccerStats stats, _) => stats.participant,
      measureFn: (SoccerStats stats, _) => double.parse(stats.draws),
      colorFn: (SoccerStats stats, _) =>
          charts.ColorUtil.fromDartColor(Color(0xff7ED0E6)),
      id: "Draws",
    ));
    seriesData.add(charts.Series(
      data: soccerData,
      domainFn: (SoccerStats stats, _) => stats.participant,
      measureFn: (SoccerStats stats, _) => double.parse(stats.losses),
      colorFn: (SoccerStats stats, _) =>
          charts.ColorUtil.fromDartColor(Color(0xffB5EDFC)),
      id: "Losses",
    ));
  }

  @override
  void initState() {  
    super.initState();
    seriesData = <charts.Series<SoccerStats, String>>[];
    generateTeamStatsInfo();
  }

  @override
  Widget build(BuildContext context) {
    ///Functions related to CALENDAR TAB -> Inside event
    //should go through each team and check for equal team names; should return picture of team if names are equal
    // ignore: missing_return
    returnTeamPicture(String teamName) {
      for (var participant in pickedEvent[0].participants) {
        if (participant.name == teamName) {
          return participant.picture;
        }
      }
    }

    /// sorts sub-events considering its dates
    orderedSubEvents() {
      var orderedCalendar = [];
      for (var subEvent in pickedEvent[0].calendar) {
        orderedCalendar.add(subEvent);
      }
      orderedCalendar.sort((a, b) => -a.date.compareTo(b.date));
      return orderedCalendar;
    }

    Widget subEventsList() {
      var calendar = orderedSubEvents();
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Center(child: Icon(Icons.share)),
          backgroundColor: Color(0xff38aac3),
          onPressed: () {
            convertWidgetToImg();
          },
          //share(context, pickedEvent[0]),
        ),
        body: new Container(
            padding: EdgeInsets.only(left: 15, bottom: 20, right: 15),
            child: ListView.builder(
                itemCount: calendar.length,
                itemBuilder: (BuildContext context, int indexPop) {
                  return Column(children: [
                    Card(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: [
                              //first container contains team on the left w/ its name
                              Container(
                                  width: 75,
                                  child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      //so that widgets start at the beginning of the column
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(11),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                child: FadeInImage.assetNetwork(
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                    placeholder:
                                                        ("assets/ph-1.png"),
                                                    image: returnTeamPicture(
                                                        calendar[indexPop]
                                                            .team1)))),
                                        Container(
                                            width: 70,
                                            padding: EdgeInsets.only(left: 2),
                                            child: Text(
                                                calendar[indexPop].team1,
                                                //pickedEvent[0].participants[indexPop].team[indexPop].name,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight
                                                        .w500) //boldness
                                                ,
                                                textAlign: TextAlign.center))
                                      ])),
                              //expanded contains a column where the score and the date are represented
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        (calendar[indexPop].scoret1 != "")
                                            ? Text(
                                                calendar[indexPop].scoret1 +
                                                    " : " +
                                                    calendar[indexPop].scoret2,
                                                style: TextStyle(
                                                    color: Color(0xff38aac3),
                                                    fontSize: 30.0,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Text(" - : - ",
                                                style: TextStyle(
                                                    color: Color(0xff38aac3),
                                                    fontSize: 30.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Container(padding: EdgeInsets.all(5)),
                                        Text(
                                          new DateFormat.yMMMMd()
                                              .format(calendar[indexPop].date),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black38),
                                        )
                                      ])),
                              //last column contains team on the right w/ its name
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //so widgets start at the beginning of the column
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(11),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            child: FadeInImage.assetNetwork(
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                                placeholder:
                                                    ("assets/ph-1.png"),
                                                image: returnTeamPicture(
                                                    calendar[indexPop]
                                                        .team2)))),
                                    Container(
                                        width: 70,
                                        //padding: EdgeInsets.all(5),
                                        child: Text(
                                          calendar[indexPop].team2,
                                          //pickedEvent[0].participants[indexPop].team[indexPop].name,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )),
                                  ])
                            ]))),
                    (indexPop == calendar.length - 1)
                        ? SizedBox(
                            height: 55,
                          )
                        : Container()
                    //Divider(thickness: 1.5),
                  ]);
                })),
      );
    }

    /// scoreboard related

    //widget for each title in header
    Widget headerContainers(Color color, String label) {
      return Container(
          width: 20,
          child: Text(label,
              style: TextStyle(
                  fontSize: 14, color: color, fontWeight: FontWeight.w700)));
    }

    Widget tableHeader() {
      return Container(
          child: Row(children: [
        SizedBox(width: 9),
        Container(
            width: 50,
            child: Text("Team",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff38aac3),
                    fontWeight: FontWeight.w700))),
        SizedBox(width: 45),
        Expanded(child: headerContainers(Color(0xff38aac3), "MP")),
        SizedBox(width: 10),
        Expanded(child: headerContainers(Colors.lightGreen, "W")),
        SizedBox(width: 5),
        Expanded(child: headerContainers(Colors.amber, "D")),
        SizedBox(width: 6),
        Expanded(child: headerContainers(Colors.red, "L")),
        //SizedBox(width: 21),
        Expanded(
            child: Text("SG:CG",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff38aac3),
                    fontWeight: FontWeight.w700))),
        SizedBox(width: 10),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text("P ",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff38aac3),
                        fontWeight: FontWeight.w700)))),
        Container(padding: EdgeInsets.only(bottom: 45)),
      ]));
    }

    //widget for each value
    Widget statsContainers(String value) {
      return Container(
          //width: 15,
          child: Text(value,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 9)));
    }

    Widget tableScores(int indexPop) {
      String teamName = pickedEvent[0].participants[indexPop].name;
      return Row(children: [
        Container(
            width: 60,
            child: Text(
              teamName,
              style: TextStyle(fontSize: 10),
            )),
        SizedBox(width: 35),
        Container(
            width: 20,
            child:
                Text(getStatsTeam(teamName)[4], style: TextStyle(fontSize: 9))),
        SizedBox(width: 14),
        Expanded(child: statsContainers(getStatsTeam(teamName)[1])),
        Expanded(child: statsContainers(getStatsTeam(teamName)[2])),
        Expanded(child: statsContainers(getStatsTeam(teamName)[3])),
        Expanded(
            child: Container(
                width: 30,
                child: Text(
                    getStatsTeam(teamName)[5] +
                        " : " +
                        getStatsTeam(teamName)[6],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9)))),
        Expanded(child: statsContainers(getStatsTeam(teamName)[0])),
      ]);
    }

    //widget for each label
    Widget labelContainers(double width, double height, String text,
        Color colorContainer, Color colorText,
        {double size}) {
      return Container(
          width: width,
          height: height,
          color: colorContainer,
          child: Center(
              child: Text(
            text,
            style: TextStyle(
                color: colorText, fontSize: size, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          )));
    }

    Widget tableLabels() {
      return Container(
          padding: EdgeInsets.only(left: 13),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Container(padding: EdgeInsets.all(9)),
                  labelContainers(25, 25, "P", Color(0xff38aac3), Colors.white),
                  SizedBox(
                    height: 10,
                  ),
                  labelContainers(25, 25, "W", Colors.lightGreen, Colors.white),
                  SizedBox(height: 10),
                  labelContainers(25, 25, "D", Colors.amber, Colors.white),
                  SizedBox(height: 10),
                ]),
                Container(
                  padding: EdgeInsets.all(4),
                ),
                //text description to labels
                Column(children: [
                  Container(padding: EdgeInsets.all(8)),
                  labelContainers(
                      33, 33, "Points", Colors.transparent, Colors.black54,
                      size: 10),
                  SizedBox(
                    height: 2,
                  ),
                  labelContainers(
                      30, 30, "Wins", Colors.transparent, Colors.black54,
                      size: 10),
                  SizedBox(height: 4),
                  labelContainers(
                      33, 33, "Draws", Colors.transparent, Colors.black54,
                      size: 10),
                ]),
                Container(padding: EdgeInsets.all(10)),
                Column(children: [
                  Container(padding: EdgeInsets.all(9)),
                  labelContainers(25, 25, "L", Colors.red, Colors.white),
                  SizedBox(height: 10),
                  labelContainers(
                      25, 25, "SG", Color(0xff38aac3), Colors.white),
                  SizedBox(height: 10.5),
                  labelContainers(
                      25, 25, "CG", Color(0xff38aac3), Colors.white),
                ]),
                Container(padding: EdgeInsets.all(5)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: EdgeInsets.all(8)),
                  labelContainers(
                      40, 28, "Losses", Colors.transparent, Colors.black54,
                      size: 10),
                  SizedBox(height: 7),
                  labelContainers(40, 29, "Scored goals", Colors.transparent,
                      Colors.black54,
                      size: 10),
                  SizedBox(height: 6),
                  labelContainers(50, 29, "Conceded goals", Colors.transparent,
                      Colors.black54,
                      size: 10),
                ]),
                Container(padding: EdgeInsets.all(5)),
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(padding: EdgeInsets.all(9)),
                  labelContainers(
                      28, 25, "MP", Color(0xff38aac3), Colors.white),
                ]),
                Container(
                  padding: EdgeInsets.all(5),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: EdgeInsets.all(8)),
                  labelContainers(48, 29, "Matches played", Colors.transparent,
                      Colors.black54,
                      size: 10)
                ])
              ]));
    }

    Widget scoreBoard() {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Center(child: Icon(Icons.share)),
          backgroundColor: Color(0xff38aac3),
          onPressed: () {
            convertWidgetToImg();
          },
          //share(context, pickedEvent[0]),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 9.0, left: 9.0, bottom: 9.0),
            child: ListView.builder(
                itemCount: pickedEvent[0].participants.length,
                itemBuilder: (BuildContext context, int indexPop) {
                  return Column(children: [
                    (indexPop == 0) ? tableHeader() : Container(),
                    (indexPop >= 0)
                        ? Container(
                            padding: EdgeInsets.all(13),
                            child: tableScores(indexPop))
                        : Container(),
                    (indexPop == pickedEvent[0].participants.length - 1)
                        ? tableLabels()
                        : Container(),
                  ]);
                })),
      );
    }

    /// end - scoreboard related

    /// stats related
    List colorList() {
      List<Color> randomColorList = <Color>[];
      for (var i = 0; i < teamsSGInfo.length; i++) {
        randomColorList.add(RandomColor().randomColor(
            colorHue: ColorHue.blue,
            colorBrightness: ColorBrightness.veryLight));
      }
      return randomColorList;
    }

    PieChart pieChart(Map dataMap, ChartType chartType) {
      return PieChart(
        chartLegendSpacing: 40,
        dataMap: dataMap,
        animationDuration: Duration(seconds: 2),
        chartRadius: MediaQuery.of(context).size.width / 2.3,
        colorList: colorList(),
        showChartValueLabel: true,
        chartValueBackgroundColor: Colors.grey[100],
        showChartValuesInPercentage: false,
        chartType: chartType,
      );
    }

    Widget stats() {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Center(child: Icon(Icons.share)),
            backgroundColor: Color(0xff38aac3),
            onPressed: () {
              convertWidgetToImg();
            },
            //share(context, pickedEvent[0]),
          ),
          body: ListView.builder(
              itemCount: 3,
              // ignore: missing_return
              itemBuilder: (BuildContext context, int indexPop) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: (indexPop == 0)
                        ? [
                            Container(
                                padding: EdgeInsets.only(top: 25, bottom: 20),
                                child: Text(
                                  "Wins, draws and losses per team",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17,
                                  ),
                                )),
                            Container(
                                height: 350,
                                width: 320,
                                child: charts.BarChart(seriesData,
                                    animate: true,
                                    animationDuration: Duration(seconds: 2),
                                    behaviors: [new charts.SeriesLegend()],
                                    vertical: false)),
                            Container(
                                padding: EdgeInsets.only(top: 25),
                                child: Text(
                                  "Teams' scored goals",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                )),
                            Container(
                                padding: EdgeInsets.only(top: 20),
                                child: (pieChart(teamsSGInfo, ChartType.disc))),
                            Container(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                child: Text(
                                  "Teams' conceded goals",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                )),
                            Container(
                                padding: EdgeInsets.only(top: 20, bottom: 30),
                                child: (pieChart(teamsCG, ChartType.ring))),
                          ]
                        : [Container()]);
              }));
    }

    /// end - stats related

    List listOfRunners() {
      if (runners.isNotEmpty) {
        runners.clear();
      }
      for (var participant in pickedEvent[0].participants) {
        for (var member in participant.members) {
          runners.add(member);
        }
      }
      runners.sort((a, b) => (a.finish != "")
          ? a.finish.compareTo(b.finish)
          : (a.name.compareTo(b.name)));
      //comparator to sort by finish time
      return runners;
    }

    Widget competitorTab() {
      //shows every team in the event
      var soccerTeams = pickedEvent[0].participants;
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
                itemCount: soccerTeams.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    Card(
                      child: Container(
                          padding: new EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                    placeholder: ("assets/ph-1.png"),
                                    image: soccerTeams[index].picture)),
                            title: Text(soccerTeams[index].name,
                                style: TextStyle(
                                    color: Color(0xff38aac3),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17)),
                            subtitle: Text(
                              soccerTeams[index].members.length.toString() +
                                  " MEMBERS",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(Icons.navigate_next),
                            onTap: () {
                              currentIndex = index;
                              pickedParticipant.add(
                                  pickedEvent[0].participants[currentIndex]);
                              navigateToCompetitorsPage();
                            },
                          )),
                    )
                  ]);
                })),
      );
    }

    Widget competitorRunnerTab() {
      var runnerList = listOfRunners();
      runnerList.sort((a, b) => a.name.compareTo(b.name));
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
                itemCount: runnerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    Card(
                      child: Container(
                          padding: new EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder: ("assets/ph-1.png"),
                                image: runnerList[index].picture),
                            title: Text(runnerList[index].name,
                                style: TextStyle(
                                    color: Color(0xff38aac3),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17)),
                            subtitle: Text(
                              runnerList[index].age + " YEARS OLD",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(Icons.navigate_next),
                            onTap: () {
                              currentIndex = index;
                              pickedMember.add(runnerList[index]);
                              navigateToRunnerPage();
                            },
                          )),
                    )
                  ]);
                })),
      );
    }

    /// for road running ///
    /// info tab
    descriptionsRunningEvent(String label, String value) {
      return Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          label,
          style:
              TextStyle(color: Color(0xff38aac3), fontWeight: FontWeight.w500),
        ),
        Text(value, style: TextStyle(color: Colors.black54))
      ]));
    }

    // ignore: missing_return
    showInfoRunEvent() {
      var actualRunningEvent = pickedEvent[0];
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
          Widget>[
        Container(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
            child: Text(
              actualRunningEvent.eventName,
              style: TextStyle(
                  color: Color(0xff38aac3),
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Divider(
              thickness: 1,
            )),
        Container(
            padding: EdgeInsets.all(10),
            width: 200,
            height: 200,
            child: FadeInImage.assetNetwork(
                placeholder: ("assets/ph-1.png"),
                image: actualRunningEvent.picture)),
        Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            width: 100,
            child: Divider(
              thickness: 1,
            )),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Center(
                child: Text(
              actualRunningEvent.shortDesc,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black45, fontStyle: FontStyle.italic),
            ))),
        Container(
            padding: EdgeInsets.all(10),
            width: 100,
            child: Divider(
              thickness: 1,
            )),
        descriptionsRunningEvent(
            "DISTANCE: ", actualRunningEvent.distance + " Km"),
        SizedBox(height: 7),
        descriptionsRunningEvent("LOCATION: ", actualRunningEvent.location),
        SizedBox(height: 7),
        descriptionsRunningEvent("HAPPENING IN: ",
            new DateFormat.yMMMMd().format(actualRunningEvent.date)),
        SizedBox(height: 7),
        descriptionsRunningEvent("STARTING AT: ",
            new DateFormat.Hm().format(actualRunningEvent.date)),
        Container(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              "Gallery",
              style: TextStyle(
                  color: Color(0xff38aac3),
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            )),
        Container(
            padding: EdgeInsets.only(bottom: 15),
            width: MediaQuery.of(context).size.width * 0.5,
            child: Divider(
              thickness: 1,
            )),
        Container(
            padding: EdgeInsets.only(bottom: 15),
            width: MediaQuery.of(context).size.width * 0.8,
            child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                placeholder: ("assets/ph-1.png"),
                image: actualRunningEvent.gallery[0])),
      ]);
    }

    aboutSection() {
      var actualRunningEvent = pickedEvent[0];
      return ListView.builder(
          itemCount: actualRunningEvent.gallery.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (index == 0)
                      ? showInfoRunEvent() //widget that shows 1st part of the page
                      : Container(
                          //the gallery
                          padding: EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: ("assets/ph-1.png"),
                              image: actualRunningEvent.gallery[index]))
                ]);
          });
    }

    aboutEventRun() {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Center(child: Icon(Icons.share)),
              backgroundColor: Color(0xff38aac3),
              onPressed: () {
                convertWidgetToImg();
              }),
          body: aboutSection());
    }

    scoreBoardRunnersContainer() {
      return ListView.builder(
          itemCount: listOfRunners().length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                (index == 0)
                    ? Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Text("Rank",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff38aac3),
                                    fontSize: 16)),
                            SizedBox(
                              width: 28,
                            ),
                            Expanded(
                                child: Text(
                              "Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff38aac3),
                                  fontSize: 16),
                            )),
                            Expanded(
                                child: Text("Club",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff38aac3),
                                        fontSize: 16))),
                            Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Text("Finish",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff38aac3),
                                        fontSize: 16)))
                          ],
                        ),
                      )
                    : Container(),
                (index >= 0)
                    ? Row(
                        children: <Widget>[
                          Container(
                              padding:
                                  EdgeInsets.only(left: 24, top: 5, bottom: 5),
                              child: Text((index + 1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12))),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 16, top: 5, bottom: 5),
                                  child: Text(
                                    listOfRunners()[index].name,
                                    style: TextStyle(fontSize: 13),
                                  ))),
                          SizedBox(
                            width: 14,
                          ),
                          (listOfRunners()[index].organization != "")
                              ? Expanded(
                                  child: Container(
                                      child: Text(
                                          listOfRunners()[index].organization,
                                          style: TextStyle(fontSize: 13))))
                              : Expanded(
                                  child: Text("-",
                                      style: TextStyle(fontSize: 13))),
                          Container(
                              child: Text(listOfRunners()[index].finish,
                                  style: TextStyle(fontSize: 13))),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      )
                    : Container()
              ],
            );
          });
    }

    Widget scoreboardRoadRunning() {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Center(child: Icon(Icons.share)),
            backgroundColor: Color(0xff38aac3),
            onPressed: () {
              convertWidgetToImg();
            },
            //share(context, pickedEvent[0]),
          ),
          body: Container(
              padding: EdgeInsets.only(top: 9.0, left: 9.0, bottom: 9.0),
              child: scoreBoardRunnersContainer()));
    }

    averageTimePerKilometer() {
      listOfRunners();
      var timestamps = []; //will store minKm from each participant
      for (var runner in runners) {
        var timeValues = runner.minKm.split(':');
        timestamps.add(timeValues);
      }
      double seconds = 0;
      for (var times in timestamps) {
        seconds += double.parse(times[0]) * 60; //min to sec
        seconds += double.parse(times[1]);
      }

      seconds /= timestamps.length; //avg time of timestamps, but in secs
      double minutes = (seconds / 60);
      seconds = seconds % 60;

      return [minutes.toInt(), seconds.toInt()];
    }

    statsRunning() {
      var time = averageTimePerKilometer();
      var runnersList = listOfRunners();

      //sort to get fastest and slowest
      runnersList.sort((a, b) => a.minKm.compareTo(b.minKm));
      var timesOfFastestRunner = runnersList[0].minKm.toString().split(':');
      var fastest = runnersList[0];
      var slowest = runnersList[runnersList.length - 1];
      var timesOfSlowestRunner =
          runnersList[runnersList.length - 1].minKm.toString().split(':');

      //sort to get youngest and oldest
      runnersList.sort((a, b) => a.age.compareTo(a.age));
      var youngest = runnersList[0];
      var oldest = runnersList[runnersList.length - 1];
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text("Average time ran per kilometer",
                        style: TextStyle(
                            color: Color(0xff38aac3),
                            fontWeight: FontWeight.w700,
                            fontSize: 22))),
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      time[0].toString() +
                          " minutes and " +
                          time[1].toString() +
                          " seconds",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text("Fastest runner",
                        style: TextStyle(
                            color: Color(0xff38aac3),
                            fontWeight: FontWeight.w700,
                            fontSize: 22))),
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      fastest.name,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    )),
                Container(
                    child: Text(
                  "(" +
                      int.parse(timesOfFastestRunner[0]).toString() +
                      " minutes and " +
                      timesOfFastestRunner[1] +
                      " seconds per kilometer)",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 10),
                )),
                Container(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text("Slowest runner",
                        style: TextStyle(
                            color: Color(0xff38aac3),
                            fontWeight: FontWeight.w700,
                            fontSize: 22))),
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      slowest.name,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    )),
                Container(
                    child: Text(
                  "(" +
                      int.parse(timesOfSlowestRunner[0]).toString() +
                      " minutes and " +
                      timesOfSlowestRunner[1] +
                      " seconds per kilometer)",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 10),
                )),
                Container(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text("Oldest participant",
                        style: TextStyle(
                            color: Color(0xff38aac3),
                            fontWeight: FontWeight.w700,
                            fontSize: 22))),
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      oldest.name.toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    )),
                Container(
                    child: Text(
                  "(" + int.parse(oldest.age).toString() + " years old)",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 10),
                )),
                Container(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text("Youngest participant",
                        style: TextStyle(
                            color: Color(0xff38aac3),
                            fontWeight: FontWeight.w700,
                            fontSize: 22))),
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      youngest.name.toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    )),
                Container(
                    child: Text(
                  "(" + int.parse(youngest.age).toString() + " years old)",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 10),
                )),
                SizedBox(
                  height: 10,
                )
              ],
            );
          });
    }

    statsRunningWidget() {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Center(child: Icon(Icons.share)),
            backgroundColor: Color(0xff38aac3),
            onPressed: () {
              convertWidgetToImg();
            },
            //share(context, pickedEvent[0]),
          ),
          body: statsRunning());
    }

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          navigateBack();
        },
        child: PreferredSize(
            //change size of appBar
            preferredSize: Size.fromHeight(60.0), //height of the appBar
            child: DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Color(0xff38aac3),
                    automaticallyImplyLeading: false,
                    //hide hamburger icon
                    title: Text(pickedEvent[0].eventName),
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
                    actions: <Widget>[
                      IconButton(
                          color: Color(0xff88CCDB),
                          onPressed: () {
                            bool check = true;
                            if (favoritesManager.isNotEmpty) {
                              for (var i = 0;
                                  i < favoritesManager.length;
                                  i++) {
                                if (favoritesManager[i].eventName ==
                                    pickedEvent[0].eventName) {
                                  check = false;
                                }
                              }
                              if (check) {
                                favoritesManager.add(pickedEvent[0]);
                              }
                            }
                            if (favoritesManager.isEmpty) {
                              favoritesManager.add(pickedEvent[0]);
                            }
                          },
                          padding: EdgeInsets.only(right: 12),
                          icon: Icon(Icons.favorite, color: Colors.white)),
                    ],
                    bottom: (pickedEvent[0].sport == "Road running")
                        ? TabBar(
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            tabs: <Widget>[
                              Tab(icon: Icon(Icons.info_outline)),
                              Tab(icon: Icon(Icons.table_chart)),
                              Tab(icon: Icon(Icons.show_chart)),
                              Tab(icon: Icon(Icons.person))
                            ],
                          )
                        : TabBar(
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            tabs: <Widget>[
                              Tab(icon: Icon(Icons.event)),
                              Tab(icon: Icon(Icons.table_chart)),
                              Tab(icon: Icon(Icons.show_chart)),
                              Tab(icon: Icon(Icons.person))
                            ],
                          ),
                  ),
                  body: (pickedEvent[0].sport == "Road running")
                      ? RepaintBoundary(
                          key: globalKey,
                          child: TabBarView(
                            children: <Widget>[
                              aboutEventRun(),
                              scoreboardRoadRunning(),
                              statsRunningWidget(),
                              competitorRunnerTab()
                            ],
                          ),
                        )
                      : RepaintBoundary(
                          key: globalKey,
                          child: TabBarView(
                            children: <Widget>[
                              subEventsList(),
                              scoreBoard(),
                              stats(),
                              competitorTab()
                            ],
                          ),
                        ),
                ))));
  }
}

class SoccerStats {
  String participant;
  String valueSG;
  String valueCG;
  String wins;
  String draws;
  String losses;

  @override
  String toString() {
    return 'SoccerStats{participant: $participant, value: $valueSG}';
  }

  SoccerStats(
      {this.participant,
      this.valueSG,
      this.valueCG,
      this.wins,
      this.draws,
      this.losses});
}

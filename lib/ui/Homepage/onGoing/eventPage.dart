import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportseventapp/models/Calendar.dart';
import 'package:sportseventapp/ui/Homepage/AppBar.dart';
import 'package:sportseventapp/models/Event.dart';
import 'package:sportseventapp/models/DataSearch.dart';

class EventPage extends StatefulWidget {
  EventPage({Key key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Calendar> monthMatches =
      <Calendar>[]; //keeps events of the month in the list
  List<Event> associatedEvent = <Event>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBars().secondaryAppBar(titleOnGoingEventsAppBar()),
      body: subEventsList(),
    );
  }

  String titleOnGoingEventsAppBar() {
    return (new DateFormat.yMMMM().format(new DateTime.now()) + "'s events");
  }

  String titleOnGoingEventsAppBar2(){
    return ("Events Calendar");
  }

  calendarOfEvents() {
    if (monthMatches.isEmpty && associatedEvent.isEmpty) {
      DateTime today = DateTime.now();
      for (var event in eventDataUsable) {
        for (var match in event.calendar) {
          if (match.date.month == today.month &&
              match.date.year == today.year) {
            monthMatches.add(match);
            //event of the match will stay in the same index as the match
            associatedEvent.add(event);
          }
        }
      }
    } else {
      monthMatches.clear();
      associatedEvent.clear();
    }
    monthMatches.sort((a, b) => -a.date.compareTo(b.date));
  }

  returnTeamPicture(String team, Event teamEvent) {
    for (var event in eventDataUsable) {
      if (teamEvent.eventName == event.eventName) {
        for (var participant in event.participants) {
          if (team == participant.name) {
            return participant.picture;}}}}
  }

  Widget subEventsList() {
    calendarOfEvents();
    if (monthMatches.isNotEmpty) {
      return Container(
          padding: EdgeInsets.only(left: 15, bottom: 20, right: 15),
          child: ListView.builder(
              itemCount: monthMatches.length,
              itemBuilder: (BuildContext context, int indexPop) {
                return Column(children: [
                  Card(
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Row(children: [
                            Container(
                                width: 75,
                                child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(11),
                                          child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                placeholder: ("assets/ph-1.png"),
                image:returnTeamPicture(monthMatches[indexPop].team1,
                                                      associatedEvent[
                                                          indexPop]))),),
                                      Container(
                                          width: 70,
                                          padding: EdgeInsets.only(left: 2),
                                          child: Text(
                                              monthMatches[indexPop].team1,
                                              //pickedEvent[0].participants[indexPop].team[indexPop].name,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight
                                                      .w500) //boldness
                                              ,
                                              textAlign: TextAlign.center))
                                    ])),
                            Expanded(
                                flex: 3,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        associatedEvent[indexPop].sport,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38),
                                      ),
                                      Container(padding: EdgeInsets.all(5)),
                                      (monthMatches[indexPop].scoret1 != "")
                                          ? Text(
                                              monthMatches[indexPop].scoret1 +
                                                  " : " +
                                                  monthMatches[indexPop]
                                                      .scoret2,
                                              style: TextStyle(
                                                  color: Color(0xff38aac3),
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold))
                                          : Text(" - : - ",
                                              style: TextStyle(
                                                  color: Color(0xff38aac3),
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold)),
                                      Container(padding: EdgeInsets.all(5)),
                                      Text(
                                        new DateFormat.yMMMMd().format(
                                            monthMatches[indexPop].date),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38),
                                      )
                                    ])),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //so widgets start at the beginning of the column
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(11),
                                      child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25.0),
                                              child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                  placeholder: ("assets/ph-1.png"),
                                                  image:(
                                              returnTeamPicture(
                                                  monthMatches[indexPop].team2,
                                                  associatedEvent[indexPop]))))),
                                  Container(
                                      width: 70,
                                      //padding: EdgeInsets.all(5),
                                      child: Text(
                                        monthMatches[indexPop].team2,
                                        //pickedEvent[0].participants[indexPop].team[indexPop].name,
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13.5,
                                            fontWeight:
                                                FontWeight.w500) //boldness
                                        ,
                                        textAlign: TextAlign.center,
                                      ))
                                ])
                          ])))
                ]);
              }));
    } else {
      return Container(
          padding: EdgeInsets.all(10),
          child: Text("There are no events going on this month."));


    }
  }
}

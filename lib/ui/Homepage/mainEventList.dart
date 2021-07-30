import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportseventapp/ui/Homepage/subevents/calendarTab.dart';
import 'package:sportseventapp/models/Event.dart';
import 'package:sportseventapp/models/DataSearch.dart';

List<Event> eventDataFavorites = <Event>[];

class MainEventsList extends StatefulWidget {
  MainEventsList({Key key}) : super(key: key);

  @override
  _MainEventsListState createState() => _MainEventsListState();
}

class _MainEventsListState extends State<MainEventsList> {
  List<Event> pickedEvent = [];

  @override
  Widget build(BuildContext context) {
    // when called goes to SubEvent page
    void navigateToSubEvent() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        /// for suggested events; whenever user taps arrow back, suggestedEvents list is populated w/ the picked event
        bool check = true;
        if (suggestedEvents.isNotEmpty) {
          for (var i = 0; i < suggestedEvents.length; i++) {
            if (suggestedEvents[i].eventName == pickedEvent[0].eventName) {
              check = false;
            }
          }
          if (check) {
            suggestedEvents.add(pickedEvent[0]);
          }
        }
        if (suggestedEvents.isEmpty) {
          suggestedEvents.add(pickedEvent[0]);
        }

        return CalendarTab(pickedEvent: pickedEvent);
      }));
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
                backgroundColor: Color(0xff38aac3),
                automaticallyImplyLeading: false, //hide hamburger icon
                title: Text("Sport Events"),
                actions: [
                  IconButton(
                    //adds icons in right of appbar
                    onPressed: () {
                      showSearch(context: context, delegate: DataSearch());
                    }, //define behavior
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ])),
        body: new Container(
            //create FutureBuilder widget
            child: FutureBuilder(
                future: Event().getEventData(),
                //takes in the name of the function w/ data
                //AsyncSnapshot gives us the data we get when the future ^ resolves
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                        child: Center(
                            child: SizedBox(
                               child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color(0xff38aac3))),
                      width: 50,
                      height: 50,
                    )));
                  } else {
                    eventDataUsable = snapshot.data; /// also for eventDataUsable
                    eventDataFavorites = snapshot.data;  /// populate eventDataFavorites list -- USED IN FAVORITES PAGE!
                    //has to return a listViewBuilder which takes
                    //an itemCount and an item Builder
                    return Container(
                        padding: EdgeInsets.all(7.0),
                        child: ListView.builder(
                            itemCount: eventDataUsable.length,
                            //how each item in my list is going to look like
                            // ignore: missing_return
                            itemBuilder: (BuildContext context, int index) {
                              //index makes it possible to access every item inside the array
                              //return widget to define how each item inside the list will look like
                              return Column(children: [
                                ListTile(
                                  title: Text(eventDataUsable[index].eventName,
                                      style: TextStyle(
                                          color: Color(0xff38aac3),
                                          fontSize: 19.0,
                                          fontWeight:
                                              FontWeight.w500) //boldness
                                      ),
                                  subtitle: Text(eventDataUsable[index].sport,
                                      style: TextStyle(fontSize: 16)),
                                  leading: Container(
                                      width: 70,
                                      padding: EdgeInsets.only(right: 5),
                                      child: FadeInImage.assetNetwork(image:eventDataUsable[index].picture, placeholder: 'assets/ph-1.png',),
                                      ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  trailing: new Icon(
                                    Icons.navigate_next,
                                    color: Colors.black54,
                                    size: 25,
                                  ),
                                  onTap: () {
                                    pickedEvent.add(eventDataUsable[index]);
                                    navigateToSubEvent();
                                  },
                                  // tap on the tile - code not correct
                                ),
                                Divider(thickness: 1.0),
                              ]);
                            }));
                  }
                })));
  }
}

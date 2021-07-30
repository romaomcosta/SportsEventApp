import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportseventapp/ui/Homepage/subevents/calendarTab.dart';
import 'package:sportseventapp/models/Event.dart';

List<Event> eventDataUsable = <Event>[];

class DataSearch extends SearchDelegate<String> {
  final searchHistory = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    //icon on the right of the appBar
    //actions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if(query.isEmpty){
            close(context, null);
          } else {
          query = "";
          showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //back button
    //leading icon on the appBar
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        }
        );
  }

  @override
  // ignore: missing_return
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text("Select an existent event!"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //navigation to specific page of the picked event
    List<Event> pickedEvent = [];
    void navigateToSubEvent() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CalendarTab(pickedEvent: pickedEvent);
      }));
    }

    //shows stuff while searching
    final suggestionList = query.isEmpty ? searchHistory : eventDataUsable.where((p) =>
                p.eventName.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(5),
          child: ListTile(
              onTap: () {
                pickedEvent.add(suggestionList[index]);
                navigateToSubEvent();
              },
              leading: CircleAvatar(
                  child: Image.network(suggestionList[index].picture)),
              title: RichText(
                  text: TextSpan(
                      text: suggestionList[index].eventName.toString().substring(0, query.length),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: suggestionList[index].eventName.toString().substring(query.length),
                        style: TextStyle(color: Colors.grey))
                      ])
                )
           )
      ),
    );
  }
}

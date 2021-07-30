import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sportseventapp/ui/Homepage/mainEventList.dart';
import 'package:sportseventapp/ui/Homepage/subevents/calendarTab.dart';
import '../AppBar.dart';
import '../../../models/Event.dart';

/// List where favorite events will be added and removed
List<Event> favoritesManager = <Event>[];

// ignore: must_be_immutable
class Favorites extends StatefulWidget {
  Favorites({Key key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int currentIndex;
  List<Event> pickedEvent = [];
  Icon initialIcon = Icon(Icons.favorite, color: Colors.red);

  // ignore: top_level_function_literal_block
  final myFuture = Future(() {
    return favoritesManager;
  });

  void navigateToSubEvent() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CalendarTab(backIndex: currentIndex, pickedEvent: pickedEvent);
    }));
  }

  // ignore: missing_return
  Widget favoritesPage() {
    //if there are no events marked as favorite in favoritesManager
    if (favoritesManager.isEmpty) {
      //if user has already picked an event
      if (suggestedEvents.isNotEmpty) {
        return Scaffold(
          appBar: AppBars().secondaryAppBar("Favorites"),
          body: Container(
              padding: EdgeInsets.all(7.0),
              child: ListView.builder(
                  itemCount: suggestedEvents.length,
                  // ignore: missing_return
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      (index == 0)
                          ? Container(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                "It looks like you haven't picked any favorite events yet. Pick one now!",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ))
                          : Container(),
                      ListTile(
                        title: Text(suggestedEvents[index].eventName,
                            style: TextStyle(
                                color: Color(0xff38aac3),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500) //boldness
                            ),
                        subtitle: Text(suggestedEvents[index].sport,
                            style: TextStyle(fontSize: 16)),
                        leading: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    placeholder: ("assets/ph-1.png"),
                    image:suggestedEvents[index].picture)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        trailing: IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {
                              ///as soon as the items are added, it "flies" to the else statement
                              favoritesManager.add(suggestedEvents[index]);
                              myFuture.then((response) {
                                setState(() {
                                  response = suggestedEvents;
                                });
                              });
                            }),
                        onTap: () {
                          currentIndex = index;
                          pickedEvent.add(suggestedEvents[currentIndex]);
                          navigateToSubEvent();
                        }, // tap on the tile - code not correct*/
                      ),
                      Divider(thickness: 1.0),
                    ]);
                  })),
        );
      } else {
        (eventDataFavorites.isNotEmpty) ? eventDataFavorites.shuffle() : Center(child: Text("Something wrong happened. Please, try again later."));
        int nextInt = (eventDataFavorites.isNotEmpty) ? Random().nextInt(eventDataFavorites.length) : 0;
        return Scaffold(
          appBar: AppBars().secondaryAppBar("Favorites"),
          body: (eventDataFavorites.isNotEmpty) ? Container(
              padding: EdgeInsets.all(7.0),
              child: ListView.builder(
                  itemCount: (nextInt != 0) ? nextInt : nextInt++,
                  // ignore: missing_return
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      (index == 0)
                          ? Container(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                "It looks like you haven't picked any favorite events yet. Pick one now!",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ))
                          : Container(),
                      ListTile(
                        title: Text(eventDataFavorites[index].eventName,
                            style: TextStyle(
                                color: Color(0xff38aac3),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500) //boldness
                            ),
                        subtitle: Text(eventDataFavorites[index].sport,
                            style: TextStyle(fontSize: 16)),
                        leading:ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: FadeInImage.assetNetwork(
                    width: 55,
                    height: 55,
                    placeholder: ("assets/ph-1.png"),
                    image:(eventDataFavorites[index].picture))),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        trailing: IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {
                              ///as soon as the items are added, it "flies" to the else statement
                              favoritesManager.add(eventDataFavorites[index]);
                              myFuture.then((response) {
                                setState(() {
                                  response = eventDataFavorites;
                                });
                              });
                            }),
                        onTap: () {
                          currentIndex = index;
                          pickedEvent.add(eventDataFavorites[currentIndex]);
                          navigateToSubEvent();
                        }, // tap on the tile - code not correct*/
                      ),
                      Divider(thickness: 1.0),
                    ]);
                  })) : Center(child: Text("Something wrong happened. Please, try again later.")),
        );
      }
    } else {
      var firstIndex = 0;
      return Scaffold(
        appBar: AppBars().secondaryAppBar("Favorites"),
        body: Container(
            padding: EdgeInsets.all(7.0),
            child: ListView.builder(
                itemCount: favoritesManager.length,
                // ignore: missing_return
                 itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    ListTile(
                      title: Text(favoritesManager[index].eventName,
                          style: TextStyle(
                              color: Color(0xff38aac3),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w500)
                          ),
                      subtitle: Text(favoritesManager[index].sport,
                          style: TextStyle(fontSize: 16)),
                      leading:ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: FadeInImage.assetNetwork(
                              width: 50,
                              height: 50,
                              placeholder: ("assets/ph-1.png"),
                              image: favoritesManager[index].picture)
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      trailing: IconButton(
                          icon: initialIcon, //red icon
                          onPressed: () {
                            //meaning, pressing the favorite button (which is already active)
                            eventDataFavorites.add(favoritesManager[
                                index]);
                            //so that the removed favorite goes back to eventDataFavorites
                            favoritesManager.remove(favoritesManager[index]);
                            myFuture.then((response) {
                              setState(() {
                                response = favoritesManager;
                              });
                            });
                          }),
                      onTap: () {
                        currentIndex = index;
                        pickedEvent.add(favoritesManager[currentIndex]);
                        navigateToSubEvent();
                      },
                    ),
                    Divider(thickness: 1.0),
                    (index == favoritesManager.length - 1 &&
                            eventDataFavorites.isNotEmpty)
                        ? Container(
                            child: (candidateAsFavorite() == true)
                                ? Column(children: [
                                    Container(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                                "We think you might like this event too!",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black54),
                                                textAlign: TextAlign.center,
                                              )
                                            ),
                                    ListTile(
                                      title: Text(
                                          (eventDataFavorites[firstIndex]
                                              .eventName),
                                          style: TextStyle(
                                              color: Color(0xff38aac3),
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w500)),
                                      subtitle: Text(
                                          eventDataFavorites[firstIndex].sport,
                                          style: TextStyle(fontSize: 16)),
                                      leading: FadeInImage.assetNetwork(
                   width: 50,
                   height: 50,
                   placeholder: ("assets/ph-1.png"),
                   image: eventDataFavorites[firstIndex]
                       .picture),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      trailing: IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          onPressed: () {
                                            bool check = true;
                                            if (favoritesManager.isNotEmpty) {
                                              for (var i = 0;
                                                  i < favoritesManager.length;
                                                  i++) {
                                                if (eventDataFavorites[
                                                            firstIndex]
                                                        .eventName ==
                                                    favoritesManager[index]
                                                        .eventName) {
                                                  check = false;
                                                }
                                              }
                                              if (check) {
                                                favoritesManager.add(
                                                    eventDataFavorites[
                                                        firstIndex]);
                                              }
                                            }
                                            //print(suggestedEvents.toString());
                                            if (favoritesManager.isEmpty) {
                                              favoritesManager.add(
                                                  eventDataFavorites[
                                                      firstIndex]);
                                            }

                                            ///as soon as the items are added, it "flies" to the else statement
                                            myFuture.then((response) {
                                              setState(() {
                                                response = eventDataFavorites;
                                              });
                                            });
                                          }),
                                      onTap: () {
                                        currentIndex = 0;
                                        pickedEvent.add(
                                            eventDataFavorites[currentIndex]);
                                        navigateToSubEvent();
                                      },
                                    )
                                  ])
                                : Container(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      "We have no more suggestions for you at the moment.",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    )))
                        : Container()
                  ]);
                })),
      );
    }
  }

  // ignore: missing_return
  bool candidateAsFavorite() {
    if (favoritesManager.isNotEmpty && eventDataFavorites.isNotEmpty) {
      for (var i = 0; i < favoritesManager.length; i++) {
        var favorite = favoritesManager[i];
        for (var j = 0; j < eventDataFavorites.length; j++) {
          if (favorite.eventName == eventDataFavorites[j].eventName) {
            eventDataFavorites.remove(eventDataFavorites[j]);
          }
        }
      }
    }
    if (eventDataFavorites.isNotEmpty) {
      return true;
    }
  }

  Widget build(BuildContext context) {
    return favoritesPage();
  }
}

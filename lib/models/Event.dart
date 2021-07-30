import 'dart:convert';

import 'package:flutter/material.dart';

import 'Calendar.dart';
import 'Member.dart';
import 'Participant.dart';
import 'package:http/http.dart' as http;

class Event {
  String eventName;
  String picture;
  String sport;
  String distance; //run race specific
  DateTime date; //run race specific
  List<Participant> participants;
  List<Calendar> calendar;
  String location;
  String shortDesc;
  List<String> gallery;

  //For getEventData() function
  Map data;
  List<Event> eventData = [];
  List<Calendar> calendarData = [];
  List<Member> membersData = [];
  List<Participant> participantsData = [];
  List<String> galleryData = [];


  Event(
      {this.eventName,
        this.picture,
        this.sport,
        this.participants,
        this.calendar,
        this.distance,
        this.date,
        this.location, this.shortDesc, this.gallery});

  Future getEventData() async {
    // A base de dados está com algumas inconsistências em relação ao projeto, é preciso
    // corrigir para eventualmente mudar a app
    http.Response response = await http.get("https://projects.cybermap.eu/sportevents/odata/SportEventsDB/TSeEvents");
    var data = json.decode(response.body);
    for (var event in data["value"]) {
      if (event["sport"] == "Road running") {
        for (var participant in event["participants"]) {
          for (var member in participant["members"]) {
            Member m = Member.fromJson(member);
            membersData.add(m);
          }

          if(participant["picture"] == null && participant["name"] == null && participant["country"] == null
              && participant["description"] == null) {
            Participant p = Participant(
                members: membersData);
            membersData = <Member>[];
            participantsData.add(p);
          }
          for(var image in event["gallery"]){
            galleryData.add(image);
          }
        }

        Event e = Event(
            sport: event["sport"],
            location: event["location"],
            shortDesc: event["shortDesc"],
            eventName: event["eventName"],
            picture: event["picture"],
            gallery: galleryData,
            calendar: calendarData,
            participants: participantsData,
            distance: event["distance"],
            date: DateTime.parse(event["date"],  )
        );
        eventData.add(e);
        participantsData = <Participant>[];
        galleryData = <String>[];
      }
      //for soccer, basket (team vs team)
      else {
        for (var subEvent in event["calendar"]) {
          //iteration on calendar of event
          Calendar c = Calendar(
              team1: subEvent["team1"],
              team2: subEvent["team2"],
              date: DateTime.parse(subEvent["date"]),
              scoret1: DateTime.parse(subEvent["date"]).compareTo(DateTime.now()) < 0 ? subEvent["scoret1"]: "",
              scoret2: DateTime.parse(subEvent["date"]).compareTo(DateTime.now()) < 0 ? subEvent["scoret2"]: ""
              );
          calendarData.add(c);
        }
        for (var participant in event["participants"]) {
          for (var member in participant["members"]) {
            Member m = Member.fromJsonTeam(member);
            membersData.add(m);
          }
          Participant p = Participant(
              picture: participant["picture"],
              name: participant["name"],
              country: participant["country"],
              members: membersData,
              description: participant["description"]);
          membersData = <Member>[];
          participantsData.add(p);
        }

        Event e = Event(
          sport: event["sport"],
          eventName: event["eventName"],
          picture: event["picture"],
          calendar: calendarData,
          participants: participantsData,
        ); //distance: event["distance"], date: DateTime.parse(event["date"])
        eventData.add(e);
        participantsData = <Participant>[];
        calendarData = <Calendar>[]; //criar nova referência da lista de calendários para que a nova n sobreponha a já existente
      }
    }
    return eventData;
  }

  compareTo(DateTime dateTime) {}
}
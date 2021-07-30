import 'Member.dart';

class Participant {
  String name;
  String picture;
  String country;
  String description;
  List<Member> members;

  Participant(
      {this.name, this.picture, this.description, this.country, this.members});
}
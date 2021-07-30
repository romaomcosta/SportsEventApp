class Member {
  String picture;
  String name;
  String age;
  String country;
  String birthDate;
  String position;
  String career;

  //for run race
  String hourRace;
  String minuteRace;
  String secondRace;
  String organization;
  String orgPic;
  String orgDesc;
  String finish;
  String minKm;

  Member(
      {this.picture,
        this.name,
        this.age,
        this.country,
        this.birthDate,
        this.position,
        this.career,
        this.hourRace,
        this.minuteRace,
        this.secondRace,
        this.organization, this.orgDesc, this.orgPic, this.finish, this.minKm});

  //For normal events
  Member.fromJson(Map<String, dynamic> json){
    name = json['name'];
    country = json['country'];
    age = json['age'];
    picture = json['picture'];
    career = json['career'];
    organization =  json['organization'];
    orgDesc = json['orgDesc'];
    orgPic = json['orgPic'];
    finish = json['finish'];
    minKm = json['minKm'];
  }
  //For normal events
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['country'] = this.country;
    data['age'] = this.age;
    data['picture'] = this.picture;
    data['career'] = this.career;
    data['organization'] = this.organization;
    data['orgDesc'] = this.orgDesc;
    data['orgPic'] = this.orgPic;
    data['finish'] = this.finish;
    data['minKm'] = this.minKm;
    return data;
  }

  //For team vs team events
  Member.fromJsonTeam(Map<String, dynamic> json){
    name = json['name'];
    country = json['country'];
    age = json['age'];
    picture = json['picture'];
    birthDate = json['birthdate'];
    position = json['position'];
    career = json['career'];
  }

  //For team vs team events
  Map<String, dynamic> toJsonTeam() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['country'] = this.country;
    data['age'] = this.age;
    data['picture'] = this.picture;
    data['birthdate'] = this.birthDate;
    data['position'] = this.position;
    data['career'] = this.career;
    return data;
  }
  @override
  String toString() {
    return 'Members{name: $name, age: $age, country: $country}';
  }
}
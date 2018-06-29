import 'dart:async';

class User {
  int id;
  String name;
  String username;
  String password;
  String token;
  int admin;
  String ageBracket;

  String avatarUrl = "https://www.shareicon.net/data/512x512/2016/06/25/786530_people_512x512.png";

  User({this.id, this.name, this.username, this.password, this.token, this.admin, this.ageBracket});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Id"] = id;
    map["Name"] = name;
    map["Username"] = username;
    map["Password"] = password;
    map["Token"] = token;
    map["Admin"] = admin;
    map["AgeBracket"] = ageBracket;

    return map;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['Id'],
      name: json['Name'],
      username: json['Username'],
      password: json['Password'],
      token: json['Token'],
      admin: json['Admin'],
      ageBracket: json['AgeBracket']
    );
  }

  Future getAvatarUrl() async {
    if (avatarUrl != null) {
      return;
    }
  }
}

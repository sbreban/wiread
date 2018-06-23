import 'dart:async';

class User {
  int id;
  String name;
  String username;
  String password;
  int admin;

  String avatarUrl;

  User({this.id, this.name, this.username, this.password, this.admin});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Id"] = id;
    map["Name"] = name;
    map["Username"] = username;
    map["Password"] = password;
    map["Admin"] = admin;

    return map;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['Id'],
      name: json['Name'],
      username: json['Username'],
      password: json['Password'],
      admin: json['Admin'],
    );
  }

  Future getAvatarUrl() async {
    if (avatarUrl != null) {
      return;
    }
  }
}

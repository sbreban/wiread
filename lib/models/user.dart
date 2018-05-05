class User {
  int id;
  String username;
  String password;

  User({this.id, this.username, this.password});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Id"] = id;
    map["Username"] = username;
    map["Password"] = password;

    return map;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        id: json['Id'],
        username: json['Username'],
        password: json['Password']
    );
  }
}
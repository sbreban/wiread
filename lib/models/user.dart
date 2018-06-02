class User {
  int id;
  String username;
  String password;
  int admin;

  User({this.id, this.username, this.password, this.admin});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Id"] = id;
    map["Username"] = username;
    map["Password"] = password;
    map["Admin"] = admin;

    return map;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        id: json['Id'],
        username: json['Username'],
        password: json['Password'],
        admin: json['Admin'],
    );
  }
}
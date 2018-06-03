import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wiread/util/auth.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/database_helper.dart';

class UserHomeWidget extends StatefulWidget {

  final int userId;

  UserHomeWidget(this.userId);

  @override
  State createState() {
    return new UserHomeWidgetState(userId);
  }
}

class UserHomeWidgetState extends State<UserHomeWidget> {

  final int userId;

  UserHomeWidgetState(this.userId);

  @override
  Widget build(BuildContext context) {
    print("Build UserHomeWidgetState");
    return new AppBar(
      leading: new Container(),
      bottom: new PreferredSize(child: new Column(
        children: <Widget>[
          new RaisedButton(
            onPressed: _registerDevice,
            child: new Text("Register device"),
          ),
          new RaisedButton(
            onPressed: _logout,
            child: new Text("Logout"),
          ),
        ],
      ), preferredSize: const Size.fromHeight(48.0)),
    );
  }

  void _logout() {
    var db = new DatabaseHelper();
    Future<int> delete = db.deleteUsers();
    delete.then((int value) {
      print("Delete user: $value");
      var authStateProvider = new AuthStateProvider();
      authStateProvider.clear();
      Config.getInstance().router.navigateTo(context, "/", replace: true);
    });
  }

  _registerDevice() {
    Config.getInstance().router.navigateTo(context, "/registerDevice?userId=$userId");
  }
}

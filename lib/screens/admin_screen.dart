import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wiread/util/auth.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/database_helper.dart';

class AdminWidget extends StatefulWidget {
  final int userId;

  AdminWidget(this.userId);

  @override
  State createState() {
    return new HomeState(userId);
  }
}

class HomeState extends State<AdminWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final int userId;

  HomeState(this.userId);

  @override
  Widget build(BuildContext context) {
    print("Build HomeWidget state");
    return new AppBar(
      leading: new Container(),
      bottom: new PreferredSize(child: new Column(
        children: <Widget>[
          new RaisedButton(
            onPressed: _clients,
            child: new Text("Users"),
          ),
          new RaisedButton(
            onPressed: _domains,
            child: new Text("Domains"),
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
      Config.getInstance().router.navigateTo(context, "/");
    });
  }

  void _clients() {
    Config.getInstance().router.navigateTo(context, "/clients?userId=$userId");
  }

  void _domains() {
    Config.getInstance().router.navigateTo(context, "/domains?userId=$userId");
  }
}

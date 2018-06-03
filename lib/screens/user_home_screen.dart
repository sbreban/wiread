import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wiread/util/auth.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/database_helper.dart';
import 'package:wiread/util/routes.dart';

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
  final Router router = Config.getInstance().router;

  UserHomeWidgetState(this.userId);

  @override
  Widget build(BuildContext context) {
    print("Build UserHomeWidgetState");
    return new AppBar(
      title: new Text("Welcome, user!"),
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
    AuthStateProvider authStateProvider = new AuthStateProvider();
    authStateProvider.logout(context);
  }

  _registerDevice() {
    router.navigateTo(context, "${Routes.registerDeviceRoute}?userId=$userId");
  }
}

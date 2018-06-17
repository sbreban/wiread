import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wiread/util/auth.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/routes.dart';

class AdminWidget extends StatefulWidget {

  final int userId;

  AdminWidget(this.userId);

  @override
  State createState() {
    return new AdminWidgetState(userId);
  }
}

class AdminWidgetState extends State<AdminWidget> {

  final int userId;
  final Router router = Config.getInstance().router;

  AdminWidgetState(this.userId);

  @override
  Widget build(BuildContext context) {
    print("Build AdminWidgetState");
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Welcome, admin!"),
            backgroundColor: Colors.black87,
            leading: new Container()),
        body: new Container(
          color: Colors.black54,
          child: new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 32.0,
            ),
            child: new Column(
              children: [
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    onPressed: _users,
                    child: new Text("Users"),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    onPressed: _domains,
                    child: new Text("Domains"),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    onPressed: _topDevices,
                    child: new Text("Top devices"),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    onPressed: _logout,
                    child: new Text("Logout"),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  void _logout() {
    AuthStateProvider authStateProvider = new AuthStateProvider();
    authStateProvider.logout(context);
  }

  void _users() {
    router.navigateTo(context, "${Routes.usersRoute}?userId=$userId");
  }

  void _domains() {
    router.navigateTo(context, "${Routes.domainsRoute}");
  }

  void _topDevices() {
    router.navigateTo(context, "${Routes.topDevicesRoute}");
  }
}

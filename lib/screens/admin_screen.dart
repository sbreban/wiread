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
    return new AppBar(
      title: new Text("Welcome, admin!"),
      leading: new Container(),
      bottom: new PreferredSize(child: new Column(
        children: <Widget>[
          new RaisedButton(
            onPressed: _users,
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
    AuthStateProvider authStateProvider = new AuthStateProvider();
    authStateProvider.logout(context);
  }

  void _users() {
    router.navigateTo(context, "${Routes.usersRoute}?userId=$userId");
  }

  void _domains() {
    router.navigateTo(context, "${Routes.domainsRoute}");
  }
}

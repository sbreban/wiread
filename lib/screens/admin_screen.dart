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
            title: new Text("Welcome, admin!"), leading: new Container()),
        body: new GridView.count(
          primary: true,
          padding: const EdgeInsets.all(1.0),
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: <Widget>[
            new InkWell(
                onTap: _users,
                child: new Card(
                    elevation: 1.5,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        new Center(
                          child: new Text("Users"),
                        )
                      ],
                    ))),
            new InkWell(
                onTap: _domains,
                child: new Card(
                    elevation: 1.5,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        new Center(
                          child: new Text("Domains"),
                        )
                      ],
                    ))),
            new InkWell(
                onTap: _topDevices,
                child: new Card(
                    elevation: 1.5,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        new Center(
                          child: new Text("Top devices"),
                        )
                      ],
                    ))),
            new InkWell(
                onTap: _topDomains,
                child: new Card(
                    elevation: 1.5,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        new Center(
                          child: new Text("Top domains"),
                        )
                      ],
                    ))),
            new InkWell(
                onTap: _logout,
                child: new Card(
                    elevation: 1.5,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        new Center(
                          child: new Text("Logout"),
                        )
                      ],
                    )))
          ],
        ));
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

  void _topDomains() {
    router.navigateTo(context, "${Routes.topDomainsRoute}");
  }
}

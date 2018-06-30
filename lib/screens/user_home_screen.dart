import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wifistate/wifistate.dart';
import 'package:wiread/util/auth.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/rest_data_source.dart';
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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Welcome, user!"),
          leading: new Container(),
        ),
        body: new Builder(builder: (BuildContext context) {
          return new GridView.count(
            primary: true,
            padding: const EdgeInsets.all(1.0),
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: <Widget>[
              new InkWell(
                  onTap: () => registerDevice(context),
                  child: new Card(
                      elevation: 1.5,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          new Center(
                            child: new Text("Register device"),
                          )
                        ],
                      ))),
              new InkWell(
                  onTap: _takeQuiz,
                  child: new Card(
                      elevation: 1.5,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          new Center(
                            child: new Text("Take quiz"),
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
          );
        }));
  }

  void registerDevice(context) {
    final Wifistate connectivity = new Wifistate();

    connectivity.checkConnectivity().then((ConnectivityResult result) {
      print("Mac address ${result.mac}");

      RestDataSource restDataSource = new RestDataSource();
      final Future<Response> response =
          restDataSource.post("check_device_registration", result.mac);
      response.then((Response response) {
        if (response.body != null && response.body.isNotEmpty) {
          print("Response: ${response.body}");
          if (response.body == "PRESENT") {
            Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: new Text('Device already registered!'),
                  ),
                );
          } else if (response.body == "MISSING") {
            router.navigateTo(
                context, "${Routes.registerDeviceRoute}?userId=$userId");
          }
        }
      });
    });
  }

  void _takeQuiz() {
    router.navigateTo(context, "${Routes.subjectsRoute}");
  }

  void _logout() {
    AuthStateProvider authStateProvider = new AuthStateProvider();
    authStateProvider.logout(context);
  }
}

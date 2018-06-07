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
        backgroundColor: Colors.black87,
        leading: new Container(),
      ),
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
                child: new Builder(
                  builder: (context) {
                    return new RaisedButton(
                      onPressed: () => registerDevice(context),
                      child: new Text("Register device"),
                    );
                  },
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  onPressed: _logout,
                  child: new Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    AuthStateProvider authStateProvider = new AuthStateProvider();
    authStateProvider.logout(context);
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
}

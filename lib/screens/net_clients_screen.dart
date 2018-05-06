import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/net_client.dart';
import 'package:wiread/util/auth.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/database_helper.dart';
import 'package:wiread/util/rest_data_source.dart';

class NetClientsWidget extends StatefulWidget {

  final int userId;

  NetClientsWidget(this.userId);

  @override
  State createState() {
    return new NetClientsState(userId);
  }
}

class NetClientsState extends State<NetClientsWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final int userId;

  NetClientsState(this.userId);

  Widget _buildClientsList() {
    print("_buildClientsList");

    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("clients/$userId");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Clients response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("Client $index : ${responseJson[index]}");
                    if (responseJson[index] != null) {
                      NetClient netDomain =
                          NetClient.fromJson(responseJson[index]);
                      return _buildRow(netDomain);
                    }
                  }
                });
          } catch (e) {
            return new Text("Error loading: " + e.toString());
          }
        } else {
          return new CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildRow(NetClient value) {
    return new ListTile(
      title: new Text(
        value.name,
        style: _biggerFont,
      ),
      onTap: () {
        print("Router: ${Config.getInstance().router}");
        Config.getInstance().router.navigateTo(context, "/domains?clientId=${value.id}");
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Build NetClientWidget state");
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Clients'),
      ),
      bottomNavigationBar: new ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[new RaisedButton(
          onPressed: _logout,
          child: new Text("Logout"),
        )],
      ),
      body: _buildClientsList(),
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
}

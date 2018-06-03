import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/device.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class DevicesWidget extends StatefulWidget {

  final int userId;

  DevicesWidget(this.userId);

  @override
  State createState() {
    return new DevicesWidgetState(userId);
  }
}

class DevicesWidgetState extends State<DevicesWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final int userId;

  DevicesWidgetState(this.userId);

  Widget _buildDevicesList() {
    print("_buildDevicesList");

    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("${Routes.devicesRoute}/$userId");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Devices response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("Device $index : ${responseJson[index]}");
                    if (responseJson[index] != null) {
                      Device netDomain =
                          Device.fromJson(responseJson[index]);
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

  Widget _buildRow(Device value) {
    return new ListTile(
      title: new Text(
        value.name,
        style: _biggerFont,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Build DevicesWidgetState");
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Devices'),
      ),
      body: _buildDevicesList(),
    );
  }
}

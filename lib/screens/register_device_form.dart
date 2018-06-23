import 'dart:async';
import 'dart:convert';

import 'package:wifistate/wifistate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/device.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class RegisterDeviceForm extends StatefulWidget {
  final int userId;

  RegisterDeviceForm(this.userId);

  @override
  RegisterDeviceFormState createState() => new RegisterDeviceFormState(userId);
}

class RegisterDeviceFormState extends State<RegisterDeviceForm> {
  final int userId;

  RegisterDeviceFormState(this.userId);

  TextEditingController nameController = new TextEditingController();

  void submit(context) {
    if (nameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Device name cannot be empty!'),
        ),
      );
    } else {
      final Wifistate connectivity = new Wifistate();

      connectivity.checkConnectivity().then((ConnectivityResult result) {
        print("Mac address ${result.mac}");

        var newDevice = new Device(
            id: 0, name: nameController.text, macAddr: result.mac, ipAddr: '');

        var deviceJson = json.encode(newDevice.toMap());
        print("New device JSON: $deviceJson");

        RestDataSource restDataSource = new RestDataSource();
        final Future<Response> response =
        restDataSource.post("${Routes.registerDeviceRoute}/$userId", deviceJson);
        response.then((Response response) {
          if (response.body != null && response.body.isNotEmpty) {
            print("Response: ${response.body}");
          }
        });

        Navigator.of(context).pop(newDevice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add a new device'),
      ),
      body: new Container(
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                    controller: nameController,
                    decoration: new InputDecoration(
                      labelText: 'Name the new device',
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Builder(
                  builder: (context) {
                    return new RaisedButton(
                      color: Colors.indigoAccent,
                      child: new Text('Submit'),
                      onPressed: () => submit(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

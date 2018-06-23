import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/device.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class AddDeviceForm extends StatefulWidget {
  final int userId;
  final Device device;

  AddDeviceForm(this.userId, this.device);

  @override
  AddDeviceFormState createState() => new AddDeviceFormState(userId, device);
}

class AddDeviceFormState extends State<AddDeviceForm> {
  final int userId;
  final Device device;

  AddDeviceFormState(this.userId, this.device);

  TextEditingController nameController = new TextEditingController();
  TextEditingController macController = new TextEditingController();

  void submit(context) {
    if (nameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Domain name cannot be empty!'),
        ),
      );
    } else if (macController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('MAC cannot be empty!'),
        ),
      );
    } else {
      if (device != null) {
        var editedDevice = new Device(id: device.id,
            name: nameController.text,
            macAddr: macController.text,
            ipAddr: '');

        var deviceJson = json.encode(editedDevice.toMap());
        print("Edited device JSON: $deviceJson");

        RestDataSource restDataSource = new RestDataSource();
        final Future<Response> response = restDataSource.post(
            "${Routes.editDomainRoute}/${editedDevice.id}", deviceJson);
        response.then((Response response) {
          if (response.body != null && response.body.isNotEmpty) {
            print("Response: ${response.body}");
          }
        });

        Navigator.of(context).pop();
      } else {
        var newDevice = new Device(id: 0,
            name: nameController.text,
            macAddr: macController.text,
            ipAddr: '');


        var deviceJson = json.encode(newDevice.toMap());
        print("New device JSON: $deviceJson");

        RestDataSource restDataSource = new RestDataSource();
        final Future<Response> response =
        restDataSource.post(
            "${Routes.registerDeviceRoute}/$userId", deviceJson);
        response.then((Response response) {
          if (response.body != null && response.body.isNotEmpty) {
            print("Response: ${response.body}");
          }
        });

        Navigator.of(context).pop(newDevice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (device != null) {
      nameController.text = device.name;
      macController.text = device.macAddr;
    }
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
                      labelText: "Device name",
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                  controller: macController,
                  decoration: new InputDecoration(
                    labelText: "Device MAC",
                  ),
                ),
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

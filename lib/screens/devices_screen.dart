import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/device.dart';
import 'package:wiread/models/device_block.dart';
import 'package:wiread/screens/add_device_form.dart';
import 'package:wiread/screens/edit_time_window_form.dart';
import 'package:wiread/util/config.dart';
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
    return new DeviceWidget(value, userId);
  }

  addDevice() {
    var router = Config.getInstance().router;
    router.navigateTo(context, "${Routes.addDeviceRoute}?userId=$userId");
  }

  @override
  Widget build(BuildContext context) {
    print("Build DevicesWidgetState");
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Devices'),
          actions: [
            new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () => addDevice(),
            ),
          ]
      ),
      body: _buildDevicesList(),
    );
  }
}

class DeviceWidget extends StatefulWidget {
  final Device device;
  final int userId;

  DeviceWidget(this.device, this.userId);

  @override
  State createState() {
    return new DeviceWidgetState(device, userId);
  }
}

class DeviceWidgetState extends State<DeviceWidget> {
  final Device device;
  final int userId;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  int _block;

  DeviceWidgetState._default(this.device, this.userId);

  factory DeviceWidgetState(Device device, int userId) {
    DeviceWidgetState domainWidgetState = DeviceWidgetState._default(device, userId);
    domainWidgetState._block = device.block;
    return domainWidgetState;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        device.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        Icons.block,
        color: _block == 1 ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_block == 1) {
            _block = 0;
          } else {
            _block = 1;
          }
          print("Set device state: $_block");
          RestDataSource restDataSource = new RestDataSource();
          restDataSource.post("${Routes.devicesRoute}/${device.id}/$_block", "");
        });
      },
      onLongPress: () {
        showDialog(context: context, builder: (BuildContext context) {
          return new SimpleDialog(title: new Text(device.name),
            children: <Widget>[
              new ListTile(title: new Text("Edite time window"),
                  onTap: editTimeWindow),
              new ListTile(title: new Text("Delete"),
                  onTap: deleteDevice),
              new ListTile(title: new Text("Edit"),
                  onTap: editDevice)
            ],);
        });
      },
    );
  }

  editTimeWindow() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("${Routes.getDeviceBlockRoute}/${device.id}");

    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new FutureBuilder(
          future: response,
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.data != null) {
              try {
                final responseJson = json.decode(snapshot.data.body);
                DeviceBlock deviceBlock = DeviceBlock.fromJson(responseJson);
                print("Get device block: $deviceBlock");
                return new EditTimeWindowForm(userId, device, deviceBlock);
              } catch (e) {
                return new Text("Error loading: " + e.toString());
              }
            } else {
              return new CircularProgressIndicator();
            }
          },
        );
      },
    ));
  }

  deleteDevice() {
    Navigator.of(context).pop();
  }

  editDevice() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new AddDeviceForm(userId, device);
      },
    ));
  }

}



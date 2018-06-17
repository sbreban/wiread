import 'dart:async';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/device_query_statistic.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class DeviceQueryStatisticsWidget extends StatefulWidget {
  @override
  State createState() {
    return new DeviceQueryStatisticsWidgetState();
  }
}

class DeviceQueryStatisticsWidgetState extends State<DeviceQueryStatisticsWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Router router = Config.getInstance().router;

  Widget _buildStatisticsList() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("${Routes.topDevicesRoute}");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Top devices response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("Device query $index: ${responseJson[index]}");
                    if (responseJson[index] != null) {
                      DeviceQueryStatistic deviceQueryStatistic =
                      DeviceQueryStatistic.fromJson(responseJson[index]);
                      return _buildRow(deviceQueryStatistic);
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

  Widget _buildRow(DeviceQueryStatistic deviceQueryStatistic) {
    return new DeviceQueryStatisticWidget(deviceQueryStatistic);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Top devices'),
          backgroundColor: Colors.black87,
      ),
      body: _buildStatisticsList(),
    );
  }
}

class DeviceQueryStatisticWidget extends StatefulWidget {
  final DeviceQueryStatistic deviceQueryStatistic;

  DeviceQueryStatisticWidget(this.deviceQueryStatistic);

  @override
  State createState() {
    return new DeviceQueryStatisticState(deviceQueryStatistic);
  }
}

class DeviceQueryStatisticState extends State<DeviceQueryStatisticWidget> {
  final DeviceQueryStatistic deviceQueryStatistic;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  DeviceQueryStatisticState(this.deviceQueryStatistic);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        "${deviceQueryStatistic.position} ${deviceQueryStatistic.queries} "
            "${deviceQueryStatistic.ip} ${deviceQueryStatistic.name}",
        style: _biggerFont,
      ),
      onLongPress: () {

      },
    );
  }

}

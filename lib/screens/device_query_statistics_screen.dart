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
            List<DeviceQueryStatistic> deviceQueryStatistics = [];
            for (int index = 0; index < responseJson.length; index++) {
              print("Device query $index: ${responseJson[index]}");
              if (responseJson[index] != null) {
                DeviceQueryStatistic deviceQueryStatistic =
                DeviceQueryStatistic.fromJson(responseJson[index]);
                deviceQueryStatistics.add(deviceQueryStatistic);
              }
            }
            return new ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  new PaginatedDataTable(
                      header: const Text("Devices"),
                      columns: <DataColumn>[
                        new DataColumn(
                            label: const Text('Position'),
                            numeric: true
                        ),
                        new DataColumn(
                          label: const Text('Queries'),
                          numeric: true,
                        ),
                        new DataColumn(
                          label: const Text('IP'),
                        ),
                        new DataColumn(
                          label: const Text('Name'),
                        )
                      ],
                      source: new DeviceQueryStatisticDataSource(
                          deviceQueryStatistics))
                ]);
          } catch (e) {
            return new Text("Error loading: " + e.toString());
          }
        } else {
          return new CircularProgressIndicator();
        }
      },
    );
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

class DeviceQueryStatisticDataSource extends DataTableSource {
  final List<DeviceQueryStatistic> deviceQueryStatistics;

  DeviceQueryStatisticDataSource(this.deviceQueryStatistics);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= deviceQueryStatistics.length)
      return null;
    final DeviceQueryStatistic deviceQueryStatistic = deviceQueryStatistics[index];
    return new DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          new DataCell(new Text('${deviceQueryStatistic.position}')),
          new DataCell(new Text('${deviceQueryStatistic.queries}')),
          new DataCell(new Text('${deviceQueryStatistic.ip}')),
          new DataCell(new Text('${deviceQueryStatistic.name}')),
        ]
    );
  }

  @override
  int get rowCount => deviceQueryStatistics.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

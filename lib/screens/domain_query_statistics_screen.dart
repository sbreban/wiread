import 'dart:async';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/domain_query_statistic.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class DomainQueryStatisticsWidget extends StatefulWidget {

  final List<DomainQueryStatistic> domainQueryStatistics;

  DomainQueryStatisticsWidget(this.domainQueryStatistics);

  @override
  State createState() {
    return new DomainQueryStatisticsWidgetState(domainQueryStatistics);
  }
}

class DomainQueryStatisticsWidgetState extends State<DomainQueryStatisticsWidget> {

  final List<DomainQueryStatistic> domainQueryStatistics;
  final Router router = Config.getInstance().router;

  DomainQueryStatisticsWidgetState(this.domainQueryStatistics);

  Widget _buildStatisticsList() {
    print("Domain queries statistics $domainQueryStatistics");
    if (domainQueryStatistics == null) {
      RestDataSource restDataSource = new RestDataSource();
      final Future<Response> response = restDataSource.get(
          "${Routes.topDomainsRoute}");

      return new FutureBuilder(
        future: response,
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.data != null) {
            try {
              print("Top domains response data: ${snapshot.data.body}");
              final responseJson = json.decode(snapshot.data.body);
              List<DomainQueryStatistic> domainQueryStatistics = [];
              for (int index = 0; index < responseJson.length; index++) {
                print("Domain query $index: ${responseJson[index]}");
                if (responseJson[index] != null) {
                  DomainQueryStatistic domainQueryStatistic =
                  DomainQueryStatistic.fromJson(responseJson[index]);
                  domainQueryStatistics.add(domainQueryStatistic);
                }
              }
              return buildListView(domainQueryStatistics);
            } catch (e) {
              return new Text("Error loading: " + e.toString());
            }
          } else {
            return new CircularProgressIndicator();
          }
        },
      );
    } else {
      return buildListView(domainQueryStatistics);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Top domains'),
      ),
      body: _buildStatisticsList(),
    );
  }

  Widget buildListView(List<DomainQueryStatistic> domainQueryStatistics) {
    return new ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          new PaginatedDataTable(
              header: const Text("Domains"),
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
                  label: const Text('Name'),
                ),
              ],
              source: new DomainQueryStatisticDataSource(
                  domainQueryStatistics))
        ]);
  }
}

class DomainQueryStatisticDataSource extends DataTableSource {
  final List<DomainQueryStatistic> domainQueryStatistics;

  DomainQueryStatisticDataSource(this.domainQueryStatistics);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= domainQueryStatistics.length)
      return null;
    final DomainQueryStatistic domainQueryStatistic = domainQueryStatistics[index];
    return new DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          new DataCell(new Text('${domainQueryStatistic.position}')),
          new DataCell(new Text('${domainQueryStatistic.queries}')),
          new DataCell(new Text('${domainQueryStatistic.name}')),
        ]
    );
  }

  @override
  int get rowCount => domainQueryStatistics.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

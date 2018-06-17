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
  @override
  State createState() {
    return new DomainQueryStatisticsWidgetState();
  }
}

class DomainQueryStatisticsWidgetState extends State<DomainQueryStatisticsWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Router router = Config.getInstance().router;

  Widget _buildStatisticsList() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("${Routes.topDomainsRoute}");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Top domains response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("Domain query $index: ${responseJson[index]}");
                    if (responseJson[index] != null) {
                      DomainQueryStatistic domainQueryStatistic =
                      DomainQueryStatistic.fromJson(responseJson[index]);
                      return _buildRow(domainQueryStatistic);
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

  Widget _buildRow(DomainQueryStatistic domainQueryStatistic) {
    return new DomainQueryStatisticWidget(domainQueryStatistic);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Top domains'),
        backgroundColor: Colors.black87,
      ),
      body: _buildStatisticsList(),
    );
  }
}

class DomainQueryStatisticWidget extends StatefulWidget {
  final DomainQueryStatistic domainQueryStatistic;

  DomainQueryStatisticWidget(this.domainQueryStatistic);

  @override
  State createState() {
    return new DomainQueryStatisticState(domainQueryStatistic);
  }
}

class DomainQueryStatisticState extends State<DomainQueryStatisticWidget> {
  final DomainQueryStatistic domainQueryStatistic;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  DomainQueryStatisticState(this.domainQueryStatistic);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        "${domainQueryStatistic.position} ${domainQueryStatistic.queries} "
            "${domainQueryStatistic.name}",
        style: _biggerFont,
      ),
      onLongPress: () {

      },
    );
  }

}

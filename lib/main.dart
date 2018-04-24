import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(new WireAd());

class NetClient {
  final String name;
  final String macAddr;
  final String ipAddr;

  NetClient({this.name, this.macAddr, this.ipAddr});

  factory NetClient.fromJson(Map<String, dynamic> json) {
    return new NetClient(
        name: json['Name'],
        macAddr: json['MacAddr'],
        ipAddr: json['IpAddr']
    );
  }
}

class WireAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final NetClientsWidget netClientsWidget = new NetClientsWidget();
    return new MaterialApp(
      title: 'Clients',
      home: netClientsWidget,
    );
  }
}

class NetClientsWidget extends StatefulWidget {
  @override
  State createState() {
    return new NetClientsState();
  }
}

class NetClientsState extends State<NetClientsWidget> {
  final _clientNames = <String>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildClients() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final Client client = new Client();
          final Future<Response> response =
          client.get('http://pc.ddns.net:8080/clients');

          final index = i ~/ 2;
          if (index >= _clientNames.length) {
            response.then((Response value) {
              _clientNames.add(value.body);
            });
          }

          return new FutureBuilder(
            future: response,
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.data != null) {
                try {
                  print(snapshot.data.body);
                  final responseJson = json.decode(snapshot.data.body);
                  NetClient netClient = NetClient.fromJson(responseJson);
                  return _buildRow(netClient.name);
                } catch (e) {
                  return new Text("Error loading: " + e.toString());
                }
              } else {
                return new CircularProgressIndicator();
              }
            },
          );
        });
  }

  Widget _buildRow(String value) {
    return new ListTile(
        title: new Text(value,
        style: _biggerFont,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Clients'),
      ),
      body: _buildClients(),
    );
  }
}

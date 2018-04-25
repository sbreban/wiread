import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:wiread/net_domains.dart';

class NetClient {
  final String name;
  final String macAddr;
  final String ipAddr;

  NetClient({this.name, this.macAddr, this.ipAddr});

  factory NetClient.fromJson(Map<String, dynamic> json) {
    return new NetClient(
        name: json['Name'], macAddr: json['MacAddr'], ipAddr: json['IpAddr']);
  }
}

class NetClientsWidget extends StatefulWidget {
  @override
  State createState() {
    return new NetClientsState();
  }
}

class NetClientsState extends State<NetClientsWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildClientsList() {
    final Client client = new Client();
    final Future<Response> response =
        client.get('http://pc.ddns.net:8080/clients');

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print(snapshot.data.body);
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print(responseJson[index]);
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
    );
  }

  void _viewDomains() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      new NetDomainsWidget();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Clients'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _viewDomains),
        ],
      ),
      body: _buildClientsList(),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class NetDomain {
  final int id;
  final String name;
  final String domain;

  NetDomain({this.id, this.name, this.domain});

  factory NetDomain.fromJson(Map<String, dynamic> json) {
    return new NetDomain(
        id: json['Id'],
        name: json['Name'],
        domain: json['Domain']);
  }
}

class NetDomainsWidget extends StatefulWidget {
  @override
  State createState() {
    return new NetDomainsState();
  }
}

class NetDomainsState extends State<NetDomainsWidget> {

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildDomainsList() {
    final Client client = new Client();
    final Future<Response> response =
        client.get('http://pc.ddns.net:8080/domains');

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
                      NetDomain netDomain = NetDomain.fromJson(
                          responseJson[index]);
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

  Widget _buildRow(NetDomain value) {
    return new NetDomainWidget(value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Domains'),
      ),
      body: _buildDomainsList(),
    );
  }
}

class NetDomainWidget extends StatefulWidget {

  final NetDomain domain;

  NetDomainWidget(this.domain);

  @override
  State createState() {
    return new NetDomainState(domain);
  }
}

class NetDomainState extends State<NetDomainWidget> {

  final NetDomain domain;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  bool _blocked = false;

  NetDomainState(this.domain);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        domain.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        _blocked ? Icons.favorite : Icons.favorite_border,
        color: _blocked ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          _blocked = !_blocked;
        });
      },
    );
  }
}

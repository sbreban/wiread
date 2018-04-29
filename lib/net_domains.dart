import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:wiread/config.dart';
import 'package:wiread/net_clients.dart';

class NetDomain {
  final int id;
  final int clientId;
  final String name;
  final String domain;
  final int block;

  NetDomain({this.id, this.clientId, this.name, this.domain, this.block});

  factory NetDomain.fromJson(Map<String, dynamic> json) {
    return new NetDomain(
        id: json['Id'],
        clientId: json['ClientId'],
        name: json['Name'],
        domain: json['Domain'],
        block: json['Block']);
  }
}

class NetDomainsWidget extends StatefulWidget {
  final NetClient netClient;

  NetDomainsWidget(this.netClient);

  @override
  State createState() {
    return new NetDomainsState(netClient);
  }
}

class NetDomainsState extends State<NetDomainsWidget> {
  final NetClient netClient;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  NetDomainsState(this.netClient);

  Widget _buildDomainsList() {
    final Client client = new Client();
    final serverUrl = "http://${Config.getInstance().hostName}:"
        "${Config.getInstance().port}/domains/${netClient.id}";
    print(serverUrl);
    final Future<Response> response = client.get(serverUrl, headers: {
      'authorization': 'bearer ${Config.getInstance().token}',
      'content-type': 'application/json'
    });

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
                      NetDomain netDomain =
                          NetDomain.fromJson(responseJson[index]);
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
  int _block;

  NetDomainState._default(this.domain);

  factory NetDomainState(NetDomain netDomain) {
    NetDomainState domain = NetDomainState._default(netDomain);
    domain._block = netDomain.block;
    return domain;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        domain.name,
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
          final Client client = new Client();
          final serverUrl = "http://${Config.getInstance().hostName}:"
              "${Config.getInstance().port}/domains/${domain.id}/${_block}";
          print(serverUrl);
          client.post(serverUrl, headers: {
            'authorization': 'bearer ${Config.getInstance().token}',
            'content-type': 'application/json'
          });
        });
      },
    );
  }
}

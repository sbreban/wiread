import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/net_domain.dart';
import 'package:wiread/util/rest_data_source.dart';

class NetDomainsWidget extends StatefulWidget {

  final int clientId;

  NetDomainsWidget(this.clientId);

  @override
  State createState() {
    return new NetDomainsState(clientId);
  }
}

class NetDomainsState extends State<NetDomainsWidget> {

  final int clientId;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  NetDomainsState(this.clientId);

  Widget _buildDomainsList() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("domains");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Domains response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("Domain $index: ${responseJson[index]}");
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
          RestDataSource restDataSource = new RestDataSource();
          restDataSource.post("domains/${domain.id}/$_block", "");
        });
      },
    );
  }
}

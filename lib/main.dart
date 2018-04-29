import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiread/config.dart';
import 'package:wiread/net_clients.dart';
import 'dart:convert';

void main() {
  rootBundle.loadString('assets/config.json').then((String configString) {
    var configJson = json.decode(configString);
    new Config(configJson['hostName'], configJson['port'], configJson['token']);
    print("${Config.getInstance().hostName}:${Config.getInstance().port} ${Config.getInstance().token}");
    return runApp(new WireAd());
  }, onError: (error) => print(error));
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

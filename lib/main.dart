import 'package:flutter/material.dart';
import 'package:wiread/net_clients.dart';

void main() => runApp(new WireAd());

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



import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiread/util/config.dart';

import 'util/routes.dart';

void main() {
  rootBundle.loadString('assets/config.json').then((String configString) {
    var configJson = json.decode(configString);
    final router = new Router();
    Routes.configureRoutes(router);
    print("Init router: $router");
    new Config(configJson['hostName'], configJson['port'], configJson['token'], router);
    print("${Config.getInstance().hostName}:${Config.getInstance().port} ${Config.getInstance().token}");
    return runApp(new WireAd());
  }, onError: (error) => print(error));
}

class WireAd extends StatefulWidget {

  @override
  State createState() {
    return new WireAdState();
  }
}

class WireAdState extends State<WireAd> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Clients',
      onGenerateRoute: Config.getInstance().router.generator,
    );
  }
}

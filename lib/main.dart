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
    var hostName = configJson['hostName'];
    var port = configJson['port'];
    var token = configJson['token'];
    var quizUrl = configJson['quizUrl'];

    new Config(hostName, port, token, router, quizUrl);
    print("Configuration: ${Config.getInstance().hostName}:${Config.getInstance().port} ${Config.getInstance().token}");
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
      debugShowCheckedModeBanner: false,
      title: 'WireAd',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        accentColor: Colors.cyan,
        buttonColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey
      ),
      onGenerateRoute: Config.getInstance().router.generator,
    );
  }
}

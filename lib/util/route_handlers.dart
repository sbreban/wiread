import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wiread/screens/login_screen.dart';
import 'package:wiread/screens/net_clients_screen.dart';
import 'package:wiread/screens/net_domains_screen.dart';


var rootHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LoginScreen();
});


var clientsRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Clients route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new NetClientsWidget(userId);
});

var domainsRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Domains route params: $params");
  int clientId = int.parse(params["clientId"]?.first);
  return new NetDomainsWidget(clientId);
});
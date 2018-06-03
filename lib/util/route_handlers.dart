import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wiread/screens/admin_screen.dart';
import 'package:wiread/screens/login_screen.dart';
import 'package:wiread/screens/net_clients_screen.dart';
import 'package:wiread/screens/net_domains_screen.dart';
import 'package:wiread/screens/users_screen.dart';


var rootHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LoginScreen();
});

var adminRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Home route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new AdminWidget(userId);
});

var usersRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Users route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new UsersWidget(userId);
});

var clientsRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Clients route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new NetClientsWidget(userId);
});

var domainsRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Domains route params: $params");
  return new NetDomainsWidget(0);
});
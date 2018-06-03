import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wiread/screens/add_domain_form.dart';
import 'package:wiread/screens/admin_screen.dart';
import 'package:wiread/screens/login_screen.dart';
import 'package:wiread/screens/devices_screen.dart';
import 'package:wiread/screens/domains_screen.dart';
import 'package:wiread/screens/add_user_form.dart';
import 'package:wiread/screens/register_device_form.dart';
import 'package:wiread/screens/user_home_screen.dart';
import 'package:wiread/screens/users_screen.dart';


var rootHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new LoginScreen();
});

var adminRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Home route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new AdminWidget(userId);
});

var userHomeRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("User home route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new UserHomeWidget(userId);
});

var registerDeviceRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Register device route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new RegisterDeviceForm(userId);
});

var usersRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Users route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new UsersWidget(userId);
});

var addUserRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("New user route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new AddUserForm(userId);
});

var devicesRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Devices route params: $params");
  int userId = int.parse(params["userId"]?.first);
  return new DevicesWidget(userId);
});

var domainsRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Domains route params: $params");
  return new DomainsWidget();
});

var addDomainRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print("Add domain route params: $params");
  return new AddDomainForm();
});
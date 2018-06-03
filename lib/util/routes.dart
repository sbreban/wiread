import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import './route_handlers.dart';

class Routes {

  static String root = "/";
  static String adminRoute = "/admin";
  static String usersRoute = "/users";
  static String clientsRoute = "/clients";
  static String domainsRoute = "/domains";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(adminRoute, handler: adminRouteHandler);
    router.define(usersRoute, handler: usersRouteHandler);
    router.define(clientsRoute, handler: clientsRouteHandler);
    router.define(domainsRoute, handler: domainsRouteHandler);
  }

}

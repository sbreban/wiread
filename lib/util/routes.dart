import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import './route_handlers.dart';

class Routes {

  static String root = "/";
  static String adminRoute = "/admin";
  static String userHomeRoute = "/userHome";
  static String registerDeviceRoute = "/registerDevice";
  static String usersRoute = "/users";
  static String newUserRoute = "/new_user";
  static String devicesRoute = "/devices";
  static String domainsRoute = "/domains";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(adminRoute, handler: adminRouteHandler);
    router.define(userHomeRoute, handler: userHomeRouteHandler);
    router.define(registerDeviceRoute, handler: registerDeviceRouteHandler);
    router.define(usersRoute, handler: usersRouteHandler);
    router.define(newUserRoute, handler: newUserRouteHandler);
    router.define(devicesRoute, handler: devicesRouteHandler);
    router.define(domainsRoute, handler: domainsRouteHandler);
  }

}

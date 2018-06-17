import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import './route_handlers.dart';

class Routes {

  static String root = "/";
  static String adminRoute = "admin";
  static String userHomeRoute = "userHome";
  static String registerDeviceRoute = "register_device";
  static String usersRoute = "users";
  static String addUserRoute = "add_user";
  static String devicesRoute = "devices";
  static String deleteDeviceRoute = "delete_device";
  static String addDeviceRoute = "add_device";
  static String domainsRoute = "domains";
  static String addDomainRoute = "add_domain";
  static String editDomainRoute = "edit_domain";
  static String deleteDomainRoute = "delete_domain";
  static String topDevicesRoute = "top_devices";
  static String topDomainsRoute = "top_domains";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(adminRoute, handler: adminRouteHandler);
    router.define(userHomeRoute, handler: userHomeRouteHandler);
    router.define(registerDeviceRoute, handler: registerDeviceRouteHandler);
    router.define(usersRoute, handler: usersRouteHandler);
    router.define(addUserRoute, handler: addUserRouteHandler);
    router.define(devicesRoute, handler: devicesRouteHandler);
    router.define(addDeviceRoute, handler: addDeviceRouteHandler);
    router.define(domainsRoute, handler: domainsRouteHandler);
    router.define(addDomainRoute, handler: addDomainRouteHandler);
    router.define(topDevicesRoute, handler: topDevicesRouteHandler);
    router.define(topDomainsRoute, handler: topDomainsRouteHandler);
  }

}

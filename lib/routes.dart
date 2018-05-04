import 'package:flutter/material.dart';
import 'package:wiread/net_clients.dart';
import 'package:wiread/screens/login_screen.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new NetClientsWidget(),
  '/' :          (BuildContext context) => new LoginScreen(),
};
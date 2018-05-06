import 'package:fluro/fluro.dart';

class Config {
  final String hostName;
  final String port;
  final String token;
  final Router router;

  static Config _instance;

  Config._internal(this.hostName, this.port, this.token, this.router);

  factory Config(String hostName, String port, String token, Router router) {
    if (_instance == null) {
      _instance = Config._internal(hostName, port, token, router);
    }
    return _instance;
  }

  static Config getInstance() {
    return _instance;
  }
}
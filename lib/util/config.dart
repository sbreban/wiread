import 'package:fluro/fluro.dart';

class Config {
  final String hostName;
  final String port;
  final String token;
  final Router router;

  final String quizUrl;
  final String userToken;

  static Config _instance;

  Config._internal(this.hostName, this.port, this.token, this.router, this.quizUrl, this.userToken);

  factory Config(String hostName, String port, String token, Router router, String quizUrl, String userToken) {
    if (_instance == null) {
      _instance = Config._internal(hostName, port, token, router, quizUrl, userToken);
    }
    return _instance;
  }

  static Config getInstance() {
    return _instance;
  }
}
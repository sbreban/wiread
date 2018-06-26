import 'package:fluro/fluro.dart';
import 'package:wiread/models/user.dart';

class Config {
  final String hostName;
  final String port;
  final String token;
  final Router router;

  final String quizUrl;

  User user;

  static Config _instance;

  Config._internal(this.hostName, this.port, this.token, this.router, this.quizUrl);

  factory Config(String hostName, String port, String token, Router router, String quizUrl) {
    if (_instance == null) {
      _instance = Config._internal(hostName, port, token, router, quizUrl);
    }
    return _instance;
  }

  static Config getInstance() {
    return _instance;
  }
}
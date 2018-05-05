class Config {
  final String hostName;
  final String port;
  final String token;

  static Config _instance;

  Config._internal(this.hostName, this.port, this.token);

  factory Config(String hostName, String port, String token) {
    if (_instance == null) {
      _instance = Config._internal(hostName, port, token);
    }
    return _instance;
  }

  static Config getInstance() {
    return _instance;
  }
}
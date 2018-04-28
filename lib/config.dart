class Config {
  final String hostName;
  final String port;

  static Config _instance;

  Config._internal(this.hostName, this.port);

  factory Config(String hostName, String port) {
    if (_instance == null) {
      _instance = Config._internal(hostName, port);
    }
    return _instance;
  }

  static Config getInstance() {
    return _instance;
  }
}
class NetClient {
  final int id;
  final String name;
  final String macAddr;
  final String ipAddr;

  NetClient({this.id, this.name, this.macAddr, this.ipAddr});

  factory NetClient.fromJson(Map<String, dynamic> json) {
    return new NetClient(
        id: json['Id'],
        name: json['Name'],
        macAddr: json['MacAddr'],
        ipAddr: json['IpAddr']);
  }
}
class Device {
  final int id;
  final String name;
  final String macAddr;
  final String ipAddr;
  final int block;

  Device({this.id, this.name, this.macAddr, this.ipAddr, this.block});

  factory Device.fromJson(Map<String, dynamic> json) {
    return new Device(
        id: json['Id'],
        name: json['Name'],
        macAddr: json['MacAddr'],
        ipAddr: json['IpAddr'],
        block: json['Block']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Id"] = id;
    map["Name"] = name;
    map["MacAddr"] = macAddr;
    map["IpAddr"] = ipAddr;
    map["Block"] = block;

    return map;
  }
}
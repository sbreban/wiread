class DeviceQueryStatistic {
  final int position;
  final int queries;
  final String ip;
  final String name;

  DeviceQueryStatistic({this.position, this.queries, this.ip, this.name});

  factory DeviceQueryStatistic.fromJson(Map<String, dynamic> json) {
    return new DeviceQueryStatistic(
        position: json['Position'],
        queries: json['Queries'],
        ip: json['Ip'],
        name: json['Name']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Position"] = position;
    map["Queries"] = queries;
    map["Ip"] = ip;
    map["Name"] = name;

    return map;
  }
}
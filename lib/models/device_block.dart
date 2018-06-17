class DeviceBlock {
  final int deviceId;
  final String fromTime;
  final String toTime;
  final int block;

  DeviceBlock({this.deviceId, this.fromTime, this.toTime, this.block});

  factory DeviceBlock.fromJson(Map<String, dynamic> json) {
    return new DeviceBlock(
        deviceId: json['DeviceId'],
        fromTime: json['FromTime'],
        toTime: json['ToTime'],
        block: json['Block']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["DeviceId"] = deviceId;
    map["FromTime"] = fromTime;
    map["ToTime"] = toTime;
    map["Block"] = block;

    return map;
  }

  @override
  String toString() {
    return 'DeviceBlock{deviceId: $deviceId, fromTime: $fromTime, toTime: $toTime, block: $block}';
  }
}
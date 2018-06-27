class UserReward {
  String deviceMAC;
  int rewardMinutes;

  UserReward({this.deviceMAC, this.rewardMinutes});

  factory UserReward.fromJson(Map<String, dynamic> json) {
    return new UserReward(
        deviceMAC: json['DeviceMAC'],
        rewardMinutes: json['RewardMinutes']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["DeviceMAC"] = deviceMAC;
    map["RewardMinutes"] = rewardMinutes;

    return map;
  }
}
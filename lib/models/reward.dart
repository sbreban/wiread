class Reward {
  int id;
  String name;
  String description;
  int cost;

  Reward({this.id, this.name, this.cost, this.description});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return new Reward(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        cost: json['cost']);
  }
}

class Redemption {
  int id;
  String name;
  int cost;
  String created_at;

  Redemption({this.id, this.name, this.cost, this.created_at});

  factory Redemption.fromJson(Map<String, dynamic> json) {
    return new Redemption(
        id: json['id'],
        name: json['name'],
        cost: json['cost'],
        created_at: json['created_at']);
  }
}

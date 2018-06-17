class DomainQueryStatistic {
  final int position;
  final int queries;
  final String name;

  DomainQueryStatistic({this.position, this.queries, this.name});

  factory DomainQueryStatistic.fromJson(Map<String, dynamic> json) {
    return new DomainQueryStatistic(
        position: json['Position'],
        queries: json['Queries'],
        name: json['Name']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Position"] = position;
    map["Queries"] = queries;
    map["Name"] = name;

    return map;
  }
}
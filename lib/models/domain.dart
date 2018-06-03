class Domain {
  final int id;
  final String name;
  final String domain;
  final int block;

  Domain({this.id, this.name, this.domain, this.block});

  factory Domain.fromJson(Map<String, dynamic> json) {
    return new Domain(
        id: json['Id'],
        name: json['Name'],
        domain: json['Domain'],
        block: json['Block']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['Id'] = id;
    map['Name'] = name;
    map['Domain'] = domain;
    map['Block'] = block;

    return map;
  }
}
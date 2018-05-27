class NetDomain {
  final int id;
  final String name;
  final String domain;
  final int block;

  NetDomain({this.id, this.name, this.domain, this.block});

  factory NetDomain.fromJson(Map<String, dynamic> json) {
    return new NetDomain(
        id: json['Id'],
        name: json['Name'],
        domain: json['Domain'],
        block: json['Block']);
  }
}
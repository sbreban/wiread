class Subject {
  int id;
  String name;
  String description;
  int numquizzes;

  Subject({this.id, this.name, this.description, this.numquizzes});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return new Subject(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        numquizzes: json['numquizzes']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["numquizzes"] = numquizzes;

    return map;
  }

  @override
  String toString() {
    return 'Subject{id: $id, name: $name, description: $description, numquizzes: $numquizzes}';
  }
}

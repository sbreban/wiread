class Quiz {
  int id;
  String name;
  String description;
  int numquestions;
  List<int> unattempted;
  int points;

  Quiz({this.id, this.name, this.description, this.numquestions, this.points});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return new Quiz(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        numquestions: json['numquestions'],
        points: json['points']);
  }
}

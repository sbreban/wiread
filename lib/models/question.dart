class Question {
  int id;
  String name;
  int answer_id;
  String imageurl;

  Question({this.id, this.name, this.answer_id, this.imageurl});

  factory Question.fromJson(Map<String, dynamic> json) {
    return new Question(
        id: json['id'],
        name: json['name'],
        answer_id: json['answer_id'],
        imageurl: json['imageurl']);
  }
}
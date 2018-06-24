class Attempt {
  int id;
  bool result;
  int answer_id;

  Attempt({this.id, this.result, this.answer_id});

  factory Attempt.fromJson(Map<String, dynamic> json) {
    return new Attempt(
        id: json['id'],
        result: json['result'],
        answer_id: json['answer_id']);
  }
}

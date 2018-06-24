import 'package:flutter/material.dart';

class Answer {
  int id;
  String name;
  MaterialColor color;

  Answer({this.id, this.name, this.color});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return new Answer(
        id: json['id'],
        name: json['name'],
        color: Colors.blue);
  }

}
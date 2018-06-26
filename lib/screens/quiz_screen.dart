import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/quiz.dart';
import 'package:wiread/screens/question_screen.dart';
import 'package:wiread/screens/rewards_screen.dart';
import 'package:wiread/util/rest_data_source.dart';

class QuizWidget extends StatefulWidget {
  QuizWidget(this.quiz);

  final Quiz quiz;

  @override
  QuizWidgetState createState() => new QuizWidgetState();
}

class QuizWidgetState extends State<QuizWidget> {
  Quiz quiz;

  int _hearts;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.getQuiz(widget.quiz.id);
    response.then((Response response) {
      this.setState(() {
        Map map = json.decode(response.body);
        Quiz quiz = Quiz.fromJson(map);
        quiz.unattempted = new List<int>();
        map["unattempted"].forEach((n) {
          quiz.unattempted.add(n);
        });
        _hearts = map["hearts"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quiz.numquestions > 0) {
      return new Scaffold(
          appBar:
              new AppBar(title: new Text(widget.quiz.name), actions: <Widget>[
            new FlatButton(
              child: new Row(children: <Widget>[
                new Icon(Icons.favorite, color: Colors.red),
                new Text("${_hearts}",
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
              onPressed: (() {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new RewardsWidget(),
                    ));
              }),
            ),
          ]),
          body: new Container(
              child: new Center(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                new Text("Ready...",
                    style: new TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                new Text("Set...",
                    style: new TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                new Text("Go!",
                    style: new TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                new IconButton(
                    icon: new Icon(Icons.directions_run),
                    tooltip: 'Start',
                    iconSize: 70.0,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new QuestionWidget(widget.quiz),
                          ));
                    }),
                new Text("${widget.quiz.unattempted.length}/${widget.quiz
                                .numquestions} questions left"),
                new Text("Click icon to start the quiz!"),
              ]))));
    } else {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.quiz.name),
          ),
          body: new Container(
              child: new Center(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                new Icon(Icons.favorite),
                new Text("Sorry, no questions!"),
              ]))));
    }
  }
}

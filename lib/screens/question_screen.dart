import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiread/models/answer.dart';
import 'package:wiread/models/attempt.dart';
import 'package:wiread/models/question.dart';
import 'package:wiread/models/quiz.dart';
import 'package:wiread/screens/rewards_screen.dart';
import 'package:wiread/util/config.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget(this.quiz);

  final Quiz quiz;

  @override
  QuestionWidgetState createState() => new QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  Question question;
  List answers;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;
  bool visibility = false;
  Answer guess = null;
  Attempt _attempt = null;
  int _hearts;

  @override
  void initState() {
    this.getSharedPreferences();
  }

  getSharedPreferences() async {
    this.setState(() {
      _url = Config.getInstance().quizUrl;
      _accessToken = Config.getInstance().userToken;
    });
    this.getData();
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
        Uri.encodeFull(
            "${_url}/api/questions/${widget.quiz.unattempted[0]}.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
    this.setState(() {
      Map map = json.decode(response.body);
      question = Question.fromJson(map);
      answers = new List();
      map["answers"].forEach((answer) {
        answers.add(Answer.fromJson(answer));
      });
      _hearts = map["hearts"];
    });
  }

  Future<Null> _makeAttempt() async {
    http.Response response =
        await http.post(Uri.encodeFull("${_url}/api/attempts.json"), body: {
      "access_token": _accessToken,
      "quiz_id": widget.quiz.id.toString(),
      "question_id": question.id.toString(),
      "answer_id": guess.id.toString()
    }, headers: {
      "Accept": "application/json"
    });
    this.setState(() {
      Map map = json.decode(response.body);
      _attempt = Attempt.fromJson(map);
      answers.forEach((a) {
        if (a.id == question.answer_id) {
          a.color = Colors.green;
        } else if (a.id == guess.id) {
          a.color = Colors.red;
        }
      });
      _hearts = map["hearts"];
    });
  }

  _handleAnswered(Answer answer) {
    if (_attempt == null) {
      setState(() {
        guess = answer;
        answers.forEach((a) {
          a.color = Colors.grey;
        });
        answer.color = Colors.purple;
      });
    }
    visibility = true;
  }

  @override
  Widget build(BuildContext context) {
    if (question != null) {
      List<Widget> answerButtons = new List<Widget>();

      int i = 0;
      answers.forEach((answer) {
        answerButtons.add(new Container(
            margin: const EdgeInsets.all(4.0),
            child: new RaisedButton(
                child: new Text(answer.name,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                color: answer.color,
                onPressed: () {
                  _handleAnswered(answer);
                })));
        i = i + 1;
      });

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
                new FlatButton(
                  child: new Text("skip this question",
                      style: new TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  onPressed: (() {
                    int skipMe = widget.quiz.unattempted.removeAt(0);
                    widget.quiz.unattempted.add(skipMe);
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new QuestionWidget(widget.quiz),
                        ));
                  }),
                ),
                new Container(
                  margin: const EdgeInsets.all(50.0),
                  child: new Text(
                    question.name,
                    style: new TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                ),
                new Column(
                  children: answerButtons,
                ),
                visibility && _attempt != null && _attempt.result
                    ? new Column(children: <Widget>[
                        new IconButton(
                            icon: new Icon(Icons.sentiment_very_satisfied),
                            tooltip: 'Correct answer!',
                            iconSize: 70.0,
                            onPressed: () {
                              widget.quiz.unattempted.removeAt(0);
                              if (widget.quiz.unattempted.length > 0) {
                                Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new QuestionWidget(widget.quiz),
                                    ));
                              } else {
//                                  Navigator.pushReplacement(
//                                      context,
//                                      new MaterialPageRoute(
//                                        builder: (BuildContext context) =>
//                                        new Congrats(
//                                            widget.quiz, widget.home),
//                                      ));
                              }
                            }),
                        new Text("Correct answer!"),
                        new Text("(click to go to the next question)")
                      ])
                    : visibility && _attempt != null
                        ? new Column(children: <Widget>[
                            new IconButton(
                                icon:
                                    new Icon(Icons.sentiment_very_dissatisfied),
                                tooltip: 'Sorry, wrong answer',
                                iconSize: 70.0,
                                onPressed: () {
                                  widget.quiz.unattempted.removeAt(0);
                                  if (widget.quiz.unattempted.length > 0) {
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new QuestionWidget(widget.quiz),
                                        ));
                                  } else {
//                                  Navigator.pushReplacement(
//                                      context,
//                                      new MaterialPageRoute(
//                                        builder: (BuildContext context) =>
//                                        new Congrats(
//                                            widget.quiz, widget.home),
//                                      ));
                                  }
                                }),
                            new Text("Sorry, wrong answer!"),
                            new Text("(click to go to the next question)")
                          ])
                        : visibility
                            ? new Column(children: <Widget>[
                                new IconButton(
                                    icon: new Icon(Icons.check_circle),
                                    tooltip: 'Check my answer, please',
                                    iconSize: 70.0,
                                    onPressed: () {
                                      _makeAttempt();
                                    }),
                                new Text("Click to check your answer"),
                                new Text("   ")
                              ])
                            : new Column(children: <Widget>[
                                new IconButton(
                                  icon: new Icon(Icons.help),
                                  tooltip: 'Answer the question, please',
                                  iconSize: 70.0,
                                  onPressed: () {},
                                ),
                                new Text("   "),
                                new Text("   ")
                              ])
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
                new Icon(Icons.access_time),
                new Text("loading ..."),
              ]))));
    }
  }
}

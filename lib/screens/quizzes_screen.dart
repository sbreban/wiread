import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiread/models/quiz.dart';
import 'package:wiread/screens/quiz_list_item.dart';
import 'package:wiread/screens/rewards_screen.dart';
import 'package:wiread/util/config.dart';

class QuizzesWidget extends StatefulWidget {
  QuizzesWidget(this.title);

  final String title;

  @override
  QuizzesWidgetState createState() => new QuizzesWidgetState();
}

class QuizzesWidgetState extends State<QuizzesWidget> {
  List<Quiz> quizzes = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;
  int _hearts;

  @override
  void initState() {
    this.getSharedPreferences();
  }

  Future<Null> getSharedPreferences() async {
    this.setState(() {
      _url = Config.getInstance().quizUrl;
      _accessToken = Config.getInstance().user.token;
    });
    this.getData();
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
        Uri.encodeFull("${_url}/api/quizzes.json"),
        body: widget.title == "All Quizzes"
            ? {"access_token": _accessToken}
            : {"access_token": _accessToken, "subject": widget.title},
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      this.setState(() {
        quizzes.clear();
        Map map = json.decode(response.body);
        List l = map["quizzes"];
        l.forEach((m) {
          Quiz q = Quiz.fromJson(m);
          q.unattempted = new List<int>();
          m["unattempted"].forEach((n) {
            q.unattempted.add(n);
          });
          quizzes.add(q);
        });
        _hearts = map["hearts"];
      });
    }
  }

  addHearts(int points) {
    this.setState(() {
      _hearts += points;
    });
  }

  setHearts(int points) {
    this.setState(() {
      _hearts = points;
    });
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () {
      completer.complete(null);
    });
    return completer.future.then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    if (quizzes.length > 0) {
      return new Scaffold(
          appBar: new AppBar(title: new Text(widget.title), actions: <Widget>[
            new FlatButton(
              child: new Row(children: <Widget>[
                new Icon(Icons.favorite, color: Colors.red),
                new Text("${_hearts}",
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
              onPressed: (() {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new RewardsWidget(),
                    ));
              }),
            ),
          ]),
          body: new RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: new ListView(
                  children: quizzes.map((Quiz quiz) {
                return new QuizListItem(quiz);
              }).toList())));
    } else {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
          ),
          body: new Container(
              child: new Center(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                new Icon(Icons.favorite),
                new Text("Sorry, no '${widget.title}' quizzes!"),
              ]))));
    }
  }
}

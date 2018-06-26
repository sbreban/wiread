import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiread/models/subject.dart';
import 'package:wiread/screens/rewards_screen.dart';
import 'package:wiread/screens/subject_list_item.dart';
import 'package:wiread/util/config.dart';

class SubjectsWidget extends StatefulWidget {
  @override
  SubjectsWidgetState createState() => new SubjectsWidgetState();
}

class SubjectsWidgetState extends State<SubjectsWidget> {
  List<Subject> subjects = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;
  int _hearts;

  @override
  void initState() {
    this.getData();
  }

  getSharedPreferences() async {
    this.setState(() {
      _url = Config.getInstance().quizUrl;
      _accessToken = Config.getInstance().user.token;
    });
  }

  Future<Null> getData() async {
    await this.getSharedPreferences();
    this.setState(() {
      subjects.clear();
    });
    if (_url != null && _accessToken != null) {
      http.Response response = await http.post(
          Uri.encodeFull("${_url}/api/subjects.json"),
          body: {"access_token": _accessToken},
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        this.setState(() {
          Map map = json.decode(response.body);
          List l = map["subjects"];
          _hearts = map["hearts"];
          l.forEach((m) {
            subjects.add(Subject.fromJson(m));
          });
        });
      }
    }
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () {
      completer.complete(null);
    });
    return completer.future.then((_) {});
  }

  setHearts(int points) {
    this.setState(() {
      _hearts = points;
    });
  }

  int getHearts() {
    return _hearts;
  }

  @override
  Widget build(BuildContext context) {
    if (subjects != null && subjects.length > 0) {
      return new Scaffold(
          appBar: new AppBar(title: new Text("Subjects"), actions: <Widget>[
            new FlatButton(
              child: new Row(children: <Widget>[
                new Icon(Icons.favorite, color: Colors.red),
                new Text("${_hearts}",
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
              onPressed: _reward,
            ),
          ]),
          body: new RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: new ListView(
                  children: subjects.map((Subject subject) {
                return new SubjectListItem(subject);
              }).toList())));
    } else {
      return new Scaffold(
          appBar: new AppBar(title: new Text("Subjects")),
          body: new Container(
              child: new Center(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.favorite, color: Colors.red),
                    iconSize: 70.0,
                    onPressed: () {

                    }),
                new Text("Welcome!"),
                new Text("  "),
                new Text('(no server found ... click the \u2764 to continue)'),
              ]))));
    }
  }

  void _reward() {
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new RewardsWidget(),
        ));
  }
}

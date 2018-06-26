import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/subject.dart';
import 'package:wiread/screens/rewards_screen.dart';
import 'package:wiread/screens/subject_list_item.dart';
import 'package:wiread/util/rest_data_source.dart';

class SubjectsWidget extends StatefulWidget {
  @override
  SubjectsWidgetState createState() => new SubjectsWidgetState();
}

class SubjectsWidgetState extends State<SubjectsWidget> {
  List<Subject> subjects = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  int _hearts;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.getSubjects();
    response.then((Response response) {
      if (response.statusCode == 200) {
        this.setState(() {
          subjects.clear();
          Map map = json.decode(response.body);
          List l = map["subjects"];
          _hearts = map["hearts"];
          l.forEach((m) {
            subjects.add(Subject.fromJson(m));
          });
        });
      }
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

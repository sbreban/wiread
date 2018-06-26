import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiread/models/quiz.dart';
import 'package:wiread/util/config.dart';

class CongratsWidget extends StatefulWidget {

  CongratsWidget(this.quiz);

  final Quiz quiz;

  @override
  CongratsWidgetState createState() => new CongratsWidgetState();
}

class CongratsWidgetState extends State<CongratsWidget> {
  String _accessToken;
  String _url;

  @override
  void initState() {
    this._getSharedPreferences();
  }

  _getSharedPreferences() async {
    this.setState(() {
      _url = Config.getInstance().quizUrl;
      _accessToken = Config.getInstance().user.token;
    });
  }

  Future<Null> _collectBonus() async {
    http.Response response = await http
        .post(Uri.encodeFull("${_url}/api/bonuses.json"), body: {
      "access_token": _accessToken,
      "quiz_id": widget.quiz.id.toString()
    }, headers: {
      "Accept": "application/json"
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Congrats!")),
        body: new Container(
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.favorite, color: Colors.red),
                  iconSize: 70.0,
                  onPressed: () {
                    _collectBonus();
                    Navigator.pop(context);
                  }),
              new Text("Congrats on the ${widget.quiz.name} quiz!"),
              new Text("You've earned ${widget.quiz.points} bonus points!"),
            ]))));
  }
}

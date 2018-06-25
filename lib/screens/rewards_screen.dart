import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiread/models/reward.dart';
import 'package:wiread/screens/reward_list_item.dart';
import 'package:wiread/util/config.dart';

class RewardsWidget extends StatefulWidget {
  RewardsWidget();

  @override
  RewardsWidgetState createState() => new RewardsWidgetState();
}

class RewardsWidgetState extends State<RewardsWidget> {
  List<Reward> rewards = new List();
  String _accessToken;
  String _url;
  int _hearts;

  @override
  void initState() {
    if (mounted) {
      this.getSharedPreferences();
    }
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
        Uri.encodeFull("${_url}/api/rewards.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
    this.setState(() {
      rewards.clear();
      Map map = json.decode(response.body);
      List l = map["rewards"];
      this.setHearts(map["hearts"]);
      l.forEach((m) {
        rewards.add(Reward.fromJson(m));
      });
    });
  }

  setHearts(int points) {
    this.setState(() {
      _hearts = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (rewards.length > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Rewards"),
          actions: <Widget>[
            new FlatButton(
              child: new Row(children: <Widget>[
                new Icon(Icons.favorite, color: Colors.red),
                new Text("${_hearts}",
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
              onPressed: () {},
            ),
          ],
        ),
        body: new ListView(
            children: rewards.map((Reward reward) {
          return new RewardListItem(reward);
        }).toList()),
      );
    } else {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text("Rewards"),
          ),
          body: new Container(
              child: new Center(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                new Icon(Icons.favorite),
                new Text("Sorry, no rewards yet!"),
              ]))));
    }
  }
}

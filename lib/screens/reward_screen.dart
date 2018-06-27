import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wifistate/wifistate.dart';
import 'package:wiread/models/redemption.dart';
import 'package:wiread/models/reward.dart';
import 'package:wiread/models/user_reward.dart';
import 'package:wiread/util/rest_data_source.dart';

class RewardWidget extends StatefulWidget {

  RewardWidget(this.reward);

  final Reward reward;

  @override
  RewardWidgetState createState() => new RewardWidgetState();
}

class RewardWidgetState extends State<RewardWidget> {
  Reward reward;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  int _hearts;
  Redemption redemption;
  bool _confirm = false;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.getReward(widget.reward.id);
    response.then((Response response) {
      this.setState(() {
        Map map = json.decode(response.body);
        reward = Reward.fromJson(map);
        _hearts = map["hearts"].toInt();
      });
    });
  }

  Future<Null> _redeem() async {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.redeem(widget.reward.id);
    response.then((Response response) {
      if (response.statusCode == 201) {
        Map map = json.decode(response.body);
        redemption = Redemption.fromJson(map);
        print("Reward give: $redemption");

        final Wifistate connectivity = new Wifistate();

        connectivity.checkConnectivity().then((ConnectivityResult result) {
          print("Mac address ${result.mac}");

          var userReward = new UserReward(deviceMAC: result.mac, rewardMinutes: int.parse(reward.name));
          var userRewardJson = json.encode(userReward.toMap());
          print("User reward JSON: $userRewardJson");
          restDataSource.post("reward", userRewardJson);
        });

      } else {
        Map map = json.decode(response.body);
        print("${map['message']}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reward != null) {
      return new Scaffold(
          appBar:
              new AppBar(title: new Text(widget.reward.name), actions: <Widget>[
            new FlatButton(
              child: new Row(children: <Widget>[
                new Icon(Icons.favorite, color: Colors.red),
                new Text("${_hearts}",
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
              onPressed: () {},
            ),
          ]),
          body: new Container(
              child: new Center(
                  child: _confirm
                      ? new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              new Container(
                                  margin: const EdgeInsets.all(50.0),
                                  child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new IconButton(
                                            icon: new Icon(Icons.check_circle,
                                                color: Colors.green),
                                            iconSize: 70.0,
                                            onPressed: (() {
                                              _redeem();
                                              Navigator.of(context).pop();
                                            })),
                                        new IconButton(
                                            icon: new Icon(Icons.backspace,
                                                color: Colors.red),
                                            iconSize: 70.0,
                                            onPressed: (() {
                                              Navigator.of(context).pop();
                                            })),
                                      ])),
                              new Text("Confirm?",
                                  style: new TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0)),
                            ])
                      : new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              new Container(
                                  margin: const EdgeInsets.all(50.0),
                                  child: new Stack(
                                      alignment: const Alignment(0.0, 0.0),
                                      children: <Widget>[
                                        new IconButton(
                                          icon: new Icon(Icons.favorite,
                                              color: Colors.red),
                                          iconSize: 70.0,
                                          onPressed: () {},
                                        ),
                                        new FlatButton(
                                            child: new Text("${reward.cost}",
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.0)),
                                            onPressed: (() {
                                              if (_hearts >= reward.cost) {
                                                this.setState(() {
                                                  _confirm = true;
                                                });
                                              } else {
                                                print("not enough hearts");
                                              }
                                            })),
                                      ])),
                              new Text(
                                  _hearts >= reward.cost
                                      ? reward.name
                                      : "Not enough hearts",
                                  style: new TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0)),
                            ]))));
    } else {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.reward.name),
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

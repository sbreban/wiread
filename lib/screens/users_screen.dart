import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/user.dart';
import 'package:wiread/screens/user_card.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/rest_data_source.dart';

class UsersWidget extends StatefulWidget {

  final int userId;

  UsersWidget(this.userId);

  @override
  State createState() {
    return new UsersWidgetState(userId);
  }
}

class UsersWidgetState extends State<UsersWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final int userId;

  UsersWidgetState(this.userId);

  Widget _buildUsersList() {
    print("_buildUsersList");

    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("users/$userId");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Users response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("User $index : ${responseJson[index]}");
                    if (responseJson[index] != null) {
                      User user =
                      User.fromJson(responseJson[index]);
                      return _buildRow(user);
                    }
                  }
                });
          } catch (e) {
            return new Text("Error loading: " + e.toString());
          }
        } else {
          return new CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildRow(User value) {
    return new UserCard(value);
  }

  @override
  Widget build(BuildContext context) {
    print("Build UsersWidgetState");
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Users'),
          actions: [
            new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () => _showNewUserForm(),
            ),
          ],
      ),
      body: _buildUsersList(),
    );
  }

  _showNewUserForm() {
    Config.getInstance().router.navigateTo(context, "/new_user?userId=$userId");
  }
}

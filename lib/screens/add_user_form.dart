import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/user.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class AddUserForm extends StatefulWidget {
  final int userId;

  AddUserForm(this.userId);

  @override
  AddUserFormState createState() => new AddUserFormState(userId);
}

class AddUserFormState extends State<AddUserForm> {
  final int userId;

  AddUserFormState(this.userId);

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordRepeatController = new TextEditingController();

  void submit(context) {
    if (usernameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
            new SnackBar(
              backgroundColor: Colors.redAccent,
              content: new Text('Username cannot be empty!'),
            ),
          );
    } else {
      var newUser = new User(
          id: 0,
          username: usernameController.text,
          password: passwordController.text,
          admin: userId);

      var userJson = json.encode(newUser.toMap());
      print("New user JSON: $userJson");

      RestDataSource restDataSource = new RestDataSource();
      final Future<Response> response = restDataSource.post("${Routes.addUserRoute}", userJson);
      response.then((Response response) {
        if (response.body != null && response.body.isNotEmpty) {
          print("Response: ${response.body}");
        }
      });

      Navigator.of(context).pop(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add a new user'),
        backgroundColor: Colors.black87,
      ),
      body: new Container(
        color: Colors.black54,
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                    controller: usernameController,
                    decoration: new InputDecoration(
                      labelText: 'Name the user',
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                  controller: passwordController,
                  decoration: new InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                  controller: passwordRepeatController,
                  decoration: new InputDecoration(
                    labelText: 'Re-enter password',
                  ),
                  obscureText: true,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Builder(
                  builder: (context) {
                    return new RaisedButton(
                      color: Colors.indigoAccent,
                      child: new Text('Submit'),
                      onPressed: () => submit(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

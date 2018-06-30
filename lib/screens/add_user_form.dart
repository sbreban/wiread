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

  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordRepeatController = new TextEditingController();

  String ageBracket;

  void submit(context) {
    if (usernameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
            new SnackBar(
              backgroundColor: Colors.redAccent,
              content: new Text('Username cannot be empty!'),
            ),
          );
    } else if (passwordController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Password cannot be empty!'),
        ),
      );
    } else if (passwordController.text != passwordRepeatController.text) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Passwords do not match!'),
        ),
      );
    } else {
      var newUser = new User(
          id: 0,
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          admin: userId,
          ageBracket: ageBracket);

      var userJson = json.encode(newUser.toMap());
      print("New user JSON: $userJson");

      RestDataSource restDataSource = new RestDataSource();
      final Future<Response> response =
          restDataSource.post("${Routes.addUserRoute}", userJson);
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
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("age_brackets");

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add a new user'),
      ),
      body: new Container(
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 32.0,
          ),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: new TextFormField(
                    controller: nameController,
                    decoration: new InputDecoration(
                      labelText: 'Name the user',
                    )),
              ),
              new Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: new Row(children: <Widget>[
                    new Text("Age bracket:"),
                    new Padding(padding: EdgeInsets.only(left: 8.0)),
                    new FutureBuilder(
                        future: response,
                        builder: (BuildContext context,
                            AsyncSnapshot<Response> snapshot) {
                          if (snapshot.data != null) {
                            final responseJson = json.decode(snapshot.data.body);
                            print("Age bracket response: $responseJson");
                            List<String> ageBrackets = new List();
                            for (var value in responseJson) {
                              ageBrackets.add(value);
                            }
                            return new DropdownButton<String>(
                              value: ageBracket,
                              items: ageBrackets.map((
                                  String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (changedValue) {
                                setState(() {
                                  ageBracket = changedValue;
                                });
                              },
                            );
                          } else {
                            return new CircularProgressIndicator();
                          }
                        }),
                  ],)
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: new TextFormField(
                    controller: usernameController,
                    decoration: new InputDecoration(
                      labelText: 'Username',
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: new TextFormField(
                  controller: passwordController,
                  decoration: new InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: new TextFormField(
                  controller: passwordRepeatController,
                  decoration: new InputDecoration(
                    labelText: 'Re-enter password',
                  ),
                  obscureText: true,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
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

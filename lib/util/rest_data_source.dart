import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/models/user.dart';

class RestDataSource {

  Future<User> login(User user) {
    var userJson = json.encode(user.toMap());
    print("User JSON: $userJson");

    return post("login", userJson).then((Response response) {
      if (response.body != null && response.body.isNotEmpty) {
        print("Response: ${response.body}");
        User user;
        try {
          user = User.fromJson(json.decode(response.body));
        } catch (e) {
          print("Error decoding user: $e");
        }
        return user;
      } else {
        return null;
      }
    }).catchError((Object error) {
      print("Error on login post: ${error.toString()}");
    });
  }

  Future<Response> get(String path) {
    final Client client = new Client();

    var serverUrl = "http://${Config.getInstance().hostName}:${Config.getInstance().port}/$path";
    print("GET: $serverUrl");

    return client.get(serverUrl, headers: {
      'authorization': 'bearer ${Config.getInstance().token}',
      'content-type': 'application/json'
    });
  }

  Future<Response> post(String path, String body) {
    final Client client = new Client();

    var serverUrl = "http://${Config.getInstance().hostName}:${Config.getInstance().port}/$path";
    print("POST: $serverUrl");

    return client.post(serverUrl, headers: {
      'authorization': 'bearer ${Config.getInstance().token}',
      'content-type': 'application/json'
    }, body: body);
  }
}
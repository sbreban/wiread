import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/models/user.dart';

class RestDataSource {

  Future<User> login(User user) {
    final Client client = new Client();

    var serverUrl = "http://${Config.getInstance().hostName}:${Config.getInstance().port}/login";

    var userJson = json.encode(user.toMap());
    print("USer JSON: $userJson");

    return client.post(serverUrl,
        headers: {
          'authorization': 'bearer ${Config.getInstance().token}',
          'content-type': 'application/json',
        }, body: userJson).then((Response response) {
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
}
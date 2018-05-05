import 'dart:async';

import 'package:http/http.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/models/user.dart';

class RestDataSource {

  Future<User> login(String username, String password) {
    final Client client = new Client();

    var serverUrl = "http://${Config.getInstance().hostName}:"
        "${Config.getInstance().port}/login";

    return client.post(serverUrl, headers: {
      'authorization': 'bearer ${Config.getInstance().token}',
      'content-type': 'application/json'
    }).then((Response response) {
      print("Response: ${response.body}");
      return new User("ali", "sesame");
    });
  }
}
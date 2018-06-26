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

  Future<Response> getSubjects() {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull("$_url/api/subjects.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
  }

  Future<Response> getQuizzes(String subject) {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull("$_url/api/quizzes.json"),
        body:  {"access_token": _accessToken, "subject": subject},
        headers: {"Accept": "application/json"});
  }

  Future<Response> getQuiz(int quizId) {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull("$_url/api/quizzes/$quizId.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
  }

  Future<Response> getQuestion(int unattempted) {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull(
            "${_url}/api/questions/$unattempted.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
  }


  Future<Response> makeAttempt(int quizId, int questionId, int guessId) {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(Uri.encodeFull("$_url/api/attempts.json"), body: {
      "access_token": _accessToken,
      "quiz_id": quizId.toString(),
      "question_id": questionId.toString(),
      "answer_id": guessId.toString()
    }, headers: {
      "Accept": "application/json"
    });
  }

  Future<Response> getRewards() {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull("$_url/api/rewards.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
  }

  Future<Response> getReward(int rewardId) {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull("$_url/api/rewards/$rewardId.json"),
        body: {"access_token": _accessToken},
        headers: {"Accept": "application/json"});
  }

  Future<Response> redeem(int rewardId) {
    String _url = Config.getInstance().quizUrl;
    String _accessToken = Config.getInstance().user.token;

    final Client client = new Client();

    return client.post(
        Uri.encodeFull("$_url/api/redemptions.json"),
        body: {"access_token": _accessToken, "reward_id": rewardId.toString()},
        headers: {"Accept": "application/json"});
  }
}
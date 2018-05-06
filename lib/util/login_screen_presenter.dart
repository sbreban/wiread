import 'package:wiread/models/user.dart';
import 'package:wiread/util/rest_ds.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDataSource api = new RestDataSource();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(new User(id: 0, username: username, password: password)).then((User user) {
      if (user != null) {
        _view.onLoginSuccess(user);
      } else {
        _view.onLoginError("Login failed! Wrong username or password");
      }
    }).catchError((Object error) {
      print("Error on doLogin : ${error.toString()}");
      _view.onLoginError(error.toString());
    });
  }
}

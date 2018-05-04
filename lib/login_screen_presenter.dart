import 'package:wiread/models/user.dart';
import 'package:wiread/rest_ds.dart';


abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDataSource api = new RestDataSource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}
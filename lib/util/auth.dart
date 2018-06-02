import 'package:wiread/models/user.dart';
import 'package:wiread/util/database_helper.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state, User user);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;

  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    var db = new DatabaseHelper();
    User user = await db.isLoggedIn();
    if (user != null)
      notify(AuthState.LOGGED_IN, user);
    else
      notify(AuthState.LOGGED_OUT, user);
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    _subscribers.remove(listener);
    print("Dispose ${_subscribers.length}");
  }

  void clear() {
    _subscribers.clear();
    print("Dispose ${_subscribers.length}");
  }

  void notify(AuthState state, User user) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state, user));
  }
}

import 'package:wiread/util/database_helper.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state, int userId);
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
    var userId = await db.isLoggedIn();
    if (userId != 0)
      notify(AuthState.LOGGED_IN, userId);
    else
      notify(AuthState.LOGGED_OUT, userId);
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

  void notify(AuthState state, int userId) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state, userId));
  }
}

import 'dart:async';

class BurgerMenuBloc {
  final _loginController = StreamController<LoginState>();

  Stream<LoginState> get loginState => _loginController.stream;

  set setLoginState(LoginState state) => _loginController.sink.add(state);

  dispose() {
    _loginController.close();
  }
}

enum LoginState { LOGGED_IN, NOT_LOGGED_IN }

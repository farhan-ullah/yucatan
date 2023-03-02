import 'package:yucatan/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _togglePasswordController = PublishSubject<bool>();
  final _loginProcessController = PublishSubject<bool>();
  final _loginResponseController = PublishSubject<LoginResponse>();

  Stream<bool> get togglePassword => _togglePasswordController.stream;

  Stream<bool> get loginProcess => _loginProcessController.stream;

  Stream<LoginResponse> get loginResponse => _loginResponseController.stream;

  toggle(bool state) {
    _togglePasswordController.sink.add(state);
  }

  onSubmit(String email, String password) async {
    _loginProcessController.sink.add(true);
    var response = LoginResponse();
    var result = await UserProvider.login(email, password);
    if (result != null) {
      _loginProcessController.sink.add(false);
      response.status = false;
      response.message = result.message!;
      _loginResponseController.sink.add(response);
    } else {
      response.status = true;
      response.message.isEmpty;
      _loginResponseController.sink.add(response);
    }
  }

  void dispose() {
    _togglePasswordController.close();
    _loginProcessController.close();
    _loginResponseController.close();
  }
}

class LoginResponse {
  late bool status;
  late String message;
}

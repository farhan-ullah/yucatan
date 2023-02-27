import 'dart:async';

class PasswordBloc {
  final _toggle1Controller = StreamController<bool>();

  Stream<bool> get toggleStream => _toggle1Controller.stream;

  set setToggle(bool value) => _toggle1Controller.sink.add(value);

  final _toggle2Controller = StreamController<bool>();

  Stream<bool> get toggle2Stream => _toggle2Controller.stream;

  set setToggle2(bool value) => _toggle2Controller.sink.add(value);

  dispose() {
    _toggle2Controller.close();
    _toggle1Controller.close();
  }
}

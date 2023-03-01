import 'dart:async';

enum RegisterValidationAction { IsButtonPressed }

class RegisterValidationBloc {
  //This StreamController is used to update the state of widgets
  final _stateStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _registerValidationSink => _stateStreamController.sink;
  Stream<bool> get registerValidationStream => _stateStreamController.stream;

  //user input event StreamController
  final _eventStreamController = StreamController<RegisterValidationAction>();
  StreamSink<RegisterValidationAction> get eventSink =>
      _eventStreamController.sink;
  Stream<RegisterValidationAction> get _eventStream =>
      _eventStreamController.stream;

  RegisterValidationBloc() {
    _eventStream.listen((event) async {
      if (event == RegisterValidationAction.IsButtonPressed) {
        _registerValidationSink.add(isRegisterSubmitButtonPressed);
      }
    });
  }

  late bool isRegisterSubmitButtonPressed;
  void registerSubmitButtonPressed(bool isRegisterSubmitButtonPressed) {
    this.isRegisterSubmitButtonPressed = isRegisterSubmitButtonPressed;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

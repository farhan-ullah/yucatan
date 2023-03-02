import 'dart:async';

import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

enum UserLoginAction { FetchLoggedInUser }

class UserLoginModelBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<UserLoginModel> _stateStreamController = new PublishSubject();
  StreamSink<UserLoginModel> get _userModelSink => _stateStreamController.sink;
  Stream<UserLoginModel> get userModelStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<UserLoginAction> _eventStreamController = new PublishSubject();
  StreamSink<UserLoginAction> get eventSink => _eventStreamController.sink;
  Stream<UserLoginAction> get _eventStream => _eventStreamController.stream;

  UserLoginModelBloc() {
    _eventStream.listen((event) async {
      if (event == UserLoginAction.FetchLoggedInUser) {
        UserLoginModel? userLoginModel = await UserProvider.getUser();
        _userModelSink.add(userLoginModel!);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

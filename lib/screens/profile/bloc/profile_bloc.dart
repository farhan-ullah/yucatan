import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final _showProgressController = PublishSubject<bool>();
  final _showButtonController = PublishSubject<bool>();
  final _resultController = PublishSubject<ApiError>();
  final _userController = PublishSubject<UserLoginModel>();

  Stream<bool> get showButtonStream => _showButtonController.stream;

  set _setShowButton(bool value) => _showButtonController.sink.add(value);

  Stream<bool> get showProgressStream => _showProgressController.stream;

  set _setshowProgress(bool value) => _showProgressController.sink.add(value);

  Stream<ApiError> get resultStream => _resultController.stream;

  set _setResult(ApiError error) => _resultController.sink.add(error);

  Stream<UserLoginModel> get userStream => _userController.stream;

  set setUserStream(UserLoginModel user) => _userController.sink.add(user);

  updateProfile(UserLoginModel model) async {
    _setShowButton = false;
    _setshowProgress = true;
    var result = await UserProvider.update(model);
    _setShowButton = true;
    _setshowProgress = false;
    _setResult = result!;
  }

  dispose() {
    _showButtonController.close();
    _showProgressController.close();
    _resultController.close();
    _userController.close();
  }
}

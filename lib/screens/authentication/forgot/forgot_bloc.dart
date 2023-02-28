import 'package:yucatan/services/forogt_password_service.dart';
import 'package:yucatan/services/response/ForgotPasswordModel.dart';
import 'package:yucatan/utils/regex_utils.dart';
import 'package:rxdart/rxdart.dart';

enum ValidationState { INVALID, EMPTY }

class ForgotBloc {
  final _responseController = PublishSubject<ForgotPasswordModel>();
  final _validationController = PublishSubject<ValidationState>();
  final _loadingController = PublishSubject<bool>();

  Stream<ForgotPasswordModel> get getForgotResponse =>
      _responseController.stream;

  set _setForgotResponse(ForgotPasswordModel forgotRequestState) =>
      _responseController.sink.add(forgotRequestState);

  Stream<ValidationState> get getValidation => _validationController.stream;

  set _setValidation(ValidationState validationState) =>
      _validationController.sink.add(validationState);

  Stream<bool> get getLoading => _loadingController.stream;

  set _setLoading(bool isLoading) => _loadingController.sink.add(isLoading);

  Future<void> requestPassword(String email) async {
    if (!_validateEmail(email)) {
      return;
    }

    _setLoading = true;
    var result = await ForgotPassword.forgotPassword(email);
    _setLoading = false;
    _setForgotResponse = result;
  }

  bool _validateEmail(String email) {
    if (email.trim().isEmpty) {
      _setValidation = ValidationState.EMPTY;
      return false;
    }

    if (!RegexUtils.emailId.hasMatch(email)) {
      _setValidation = ValidationState.INVALID;
      return false;
    }

    return true;
  }

  dispose() {
    _responseController.close();
    _validationController.close();
    _loadingController.close();
  }
}

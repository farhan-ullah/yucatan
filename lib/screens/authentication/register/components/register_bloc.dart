import 'dart:async';

import 'package:yucatan/screens/authentication/register/models/country_model.dart';
import 'package:yucatan/screens/authentication/register/models/details_email.dart';
import 'package:yucatan/screens/authentication/register/models/details_model.dart';
import 'package:yucatan/screens/authentication/register/models/password_model.dart';
import 'package:yucatan/screens/authentication/register/models/policy_model.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_single_response_entity.dart';
import 'package:yucatan/services/user_service.dart';

enum LoadingState { START, STOP }

class RegisterBloc {
  final _registerController = StreamController<UserSingleResponseEntity>();
  final _loadingController = StreamController<LoadingState>();

  Stream<UserSingleResponseEntity> get getRegisterResponse =>
      _registerController.stream;

  set _setRegisterResponse(UserSingleResponseEntity response) =>
      _registerController.sink.add(response);

  Stream<LoadingState> get getLoadingState => _loadingController.stream;

  set _setLoadingState(LoadingState response) =>
      _loadingController.sink.add(response);

  dispose() {
    _registerController.close();
    _loadingController.close();
  }

  Future<void> register(
      RegisterDetailModel detailModel,
      RegisterEmailModel emailModel,
      RegisterPasswordModel passwordModel,
      RegisterPolicyModel policyModel,
      CountryPhoneModel countryPhoneModel) async {
    if (detailModel == null ||
        passwordModel == null ||
        emailModel == null ||
        policyModel == null ||
        countryPhoneModel == null) {
      return;
    }

    if (!detailModel.isValid) {
      print("Username is not valid");
      return;
    }

    if (!emailModel.isValid) {
      print("emailModel is not valid");
      return;
    }

    if (!policyModel.isValid) {
      print("policyModel is not valid");
      return;
    }

    if (!countryPhoneModel.isValid) {
      print("countryPhoneModel is not valid");
      return;
    }

    if (passwordModel != null) {
      if (passwordModel.password == passwordModel.passwordRepeat) {
        passwordModel.isValid = true;
      }
    }
    if (!passwordModel.isValid) {
      print("passwordModel is not valid");
      return;
    }

    var loginModel = UserLoginModel();
    loginModel.email = emailModel.email!;
    loginModel.username = detailModel.username;
    loginModel.phone = countryPhoneModel.phone!;
    loginModel.areaCode = countryPhoneModel.areaCode!;
    loginModel.countryISO2 = countryPhoneModel.countryISO2Code!;

    _setLoadingState = LoadingState.START;
    var response = await UserService.createUser(
        loginModel, passwordModel.password!, passwordModel.passwordRepeat!);
    _setLoadingState = LoadingState.STOP;
    _setRegisterResponse = response;
  }
}

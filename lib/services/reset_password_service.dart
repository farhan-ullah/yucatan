import 'dart:convert';

import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/ForgotPasswordModel.dart';

class ResetPasswordService extends BaseService {
  // this class is static only
  ResetPasswordService._() : super(BaseService.defaultURL + '/users');

  static Future<ForgotPasswordModel> resetPassword(
      String token, String password) async {
    dynamic body = json.encode({
      'password': password,
      'passwordConfirmation': '$password',
    });
    var response = await new ResetPasswordService._()
        .post('/resetPassword?token=$token', body);
    if (response?.body != null) {
      var result = ForgotPasswordModel.fromJson(json.decode(response!.body));
      result.statusCode = result.statusCode;
      return result;
    } else
      return ForgotPasswordModel.fromJson(
          {'message': 'A network error occurred'});
  }
}

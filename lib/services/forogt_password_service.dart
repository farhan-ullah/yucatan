import 'dart:convert';

import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/ForgotPasswordModel.dart';
import 'package:yucatan/services/response/api_error.dart';

class ForgotPassword extends BaseService {
  // this class is static only
  ForgotPassword._() : super(BaseService.defaultURL + '/users');

  /// returns an [ApiError] if an error occurs, otherwise null
  static Future<ForgotPasswordModel> forgotPassword(String email) async {
    dynamic body = json.encode({
      'email': email,
    });
    var response = await new ForgotPassword._().post('forgotPassword', body);
    if (response!.body != null) {
      var result = ForgotPasswordModel.fromJson(json.decode(response.body));
      result.statusCode = response.statusCode;
      return result;
    } else
      return ForgotPasswordModel.fromJson(
          {'message': 'A network error occurred'});
  }
}

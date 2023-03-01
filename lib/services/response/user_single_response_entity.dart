import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/user_login_response.dart';

class UserSingleResponseEntity with JsonConvert<UserSingleResponseEntity> {
  int? status;
  UserLoginModel? data;
  ApiError? errors;
}

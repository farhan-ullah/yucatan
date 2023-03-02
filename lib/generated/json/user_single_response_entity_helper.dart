import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_single_response_entity.dart';

userSingleResponseEntityFromJson(
    UserSingleResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status']?.toInt();
  }
  if (json['data'] != null) {
    data.data = new UserLoginModel().fromJson(json['data']);
  }
  if (json['errors'] != null) {
    data.errors = new ApiError().fromJson(json['errors']);
  }
  return data;
}

Map<String, dynamic> userSingleResponseEntityToJson(
    UserSingleResponseEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  if (entity.data != null) {
    data['data'] = entity.data!.toJson();
  }
  if (entity.errors != null) {
    data['errors'] = entity.errors!.toJson();
  }
  return data;
}

import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_multi_response_entity.dart';

userMultiResponseEntityFromJson(
    UserMultiResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status']?.toInt();
  }
  if (json['data'] != null) {
    data.data = <UserLoginModel>[];
    (json['data'] as List).forEach((v) {
      data.data!.add(new UserLoginModel().fromJson(v));
    });
  }
  if (json['errors'] != null) {
    data.errors = new ApiError().fromJson(json['errors']);
  }
  return data;
}

Map<String, dynamic> userMultiResponseEntityToJson(
    UserMultiResponseEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  if (entity.data != null) {
    data['data'] = entity.data!.map((v) => v.toJson()).toList();
  }
  if (entity.errors != null) {
    data['errors'] = entity.errors!.toJson();
  }
  return data;
}

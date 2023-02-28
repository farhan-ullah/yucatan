import 'package:yucatan/services/response/api_error.dart';

apiErrorFromJson(ApiError data, Map<String, dynamic> json) {
  if (json['message'] != null) {
    data.message = json['message'].toString();
  }
  return data;
}

Map<String, dynamic> apiErrorToJson(ApiError entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['message'] = entity.message;
  return data;
}

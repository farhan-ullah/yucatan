import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/services/response/api_error.dart';

activitySingleResponseFromJson(
    ActivitySingleResponse data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status']?.toInt();
  }
  if (json['data'] != null) {
    data.data = new ActivityModel().fromJson(json['data']);
  }
  if (json['errors'] != null) {
    data.errors = new ApiError().fromJson(json['errors']);
  }
  return data;
}

Map<String, dynamic> activitySingleResponseToJson(
    ActivitySingleResponse entity) {
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

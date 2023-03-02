import 'package:yucatan/services/response/activity_multi_response.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/services/response/api_error.dart';

activityMultiResponseFromJson(
    ActivityMultiResponse data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status']?.toInt();
  }
  if (json['data'] != null) {
    data.data = <ActivityModel>[];
    (json['data'] as List).forEach((v) {
      data.data!.add(new ActivityModel().fromJson(v));
    });
  }
  if (json['errors'] != null) {
    data.errors = new ApiError().fromJson(json['errors']);
  }
  return data;
}

Map<String, dynamic> activityMultiResponseToJson(ActivityMultiResponse entity) {
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

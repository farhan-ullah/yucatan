import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class ActivitySingleResponse with JsonConvert<ActivitySingleResponse> {
  int? status;
  ActivityModel? data;
  ApiError? errors;
}

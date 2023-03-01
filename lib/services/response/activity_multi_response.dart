import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class ActivityMultiResponse with JsonConvert<ActivityMultiResponse> {
  int? status;
  List<ActivityModel>? data;
  ApiError? errors;
}

import 'package:yucatan/models/webpage_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class WebPageSingleResponseEntity {
  late int status;
  late WebPageModel data;
  late ApiError errors;

  WebPageSingleResponseEntity();

  factory WebPageSingleResponseEntity.fromJson(json) {
    WebPageSingleResponseEntity data = WebPageSingleResponseEntity();
    if (json['status'] != null) {
      data.status = json['status']?.toInt();
    }
    if (json['data'] != null) {
      data.data = WebPageModel(url: json['data']);
    }
    if (json['errors'] != null) {
      data.errors = new ApiError().fromJson(json['errors']);
    }
    return data;
  }
}

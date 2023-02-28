import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/booking_single_response_entity.dart';

bookingSingleResponseEntityFromJson(
    BookingSingleResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status']?.toInt();
  }
  if (json['data'] != null) {
    data.data = new BookingModel.fromJson(json['data']);
  }
  if (json['errors'] != null) {
    data.error = new ApiError().fromJson(json['errors']);
  }
  return data;
}

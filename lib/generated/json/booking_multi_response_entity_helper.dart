import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/booking_multi_response_entity.dart';

bookingMultiResponseEntityFromJson(
    BookingMultiResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status']?.toInt();
  }
  if (json['data'] != null) {
    data.data = <BookingModel>[];
    (json['data'] as List).forEach((v) {
      data.data!.add(new BookingModel.fromJson(v));
    });
  }
  if (json['error'] != null) {
    data.error = new ApiError().fromJson(json['error']);
  }
  return data;
}

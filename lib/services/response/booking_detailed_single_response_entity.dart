import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class BookingDetailedSingleResponseEntity {
  int? status;
  BookingDetailedModel? data;
  ApiError? errors;

  BookingDetailedSingleResponseEntity({this.status, this.data, this.errors});

  factory BookingDetailedSingleResponseEntity.fromJson(
      Map<String, dynamic> json) {
    return BookingDetailedSingleResponseEntity(
        status: json['status'] != null ? json['status']?.toInt() : null,
        data: json['data'] != null
            ? BookingDetailedModel.fromJson(json['data'])
            : null,
        errors: json['errors'] != null
            ? new ApiError().fromJson(json['errors'])
            : null);
  }
}

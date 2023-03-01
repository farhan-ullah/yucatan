import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class BookingDetailedMultiResponseEntity {
  int? status;
  List<BookingDetailedModel>? data;
  ApiError? errors;

  setError(error) {
    errors = error;
  }

  static fromJson(json) {
    BookingDetailedMultiResponseEntity data =
        BookingDetailedMultiResponseEntity();
    if (json['status'] != null) {
      data.status = json['status']?.toInt();
    }
    if (json['data'] != null) {
      data.data = <BookingDetailedModel>[];
      (json['data'] as List).forEach((v) {
        data.data!.add(new BookingDetailedModel.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      data.errors = new ApiError().fromJson(json['errors']);
    }
    return data;
  }
}

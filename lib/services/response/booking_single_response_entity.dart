import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class BookingSingleResponseEntity
    with JsonConvert<BookingSingleResponseEntity> {
  int? status;
  BookingModel? data;
  ApiError? error;
}

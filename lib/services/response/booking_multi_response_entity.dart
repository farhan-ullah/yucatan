import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/models/booking_model.dart';

import 'api_error.dart';

class BookingMultiResponseEntity with JsonConvert<BookingMultiResponseEntity> {
  int? status;
  List<BookingModel>? data;
  ApiError? error;
}

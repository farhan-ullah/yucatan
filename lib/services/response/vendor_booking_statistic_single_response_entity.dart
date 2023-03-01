import 'package:yucatan/models/vendor_booking_statistic_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class VendorBookingStatisticSingleResponseEntity {
  int? status;
  VendorBookingStatisticModel? data;
  ApiError? errors;
  List<DailyRevenueItem>? fullItemsList = [];
  double maxRevenue = 100;

  VendorBookingStatisticSingleResponseEntity({
    this.status,
    this.data,
    this.errors,
  });

  factory VendorBookingStatisticSingleResponseEntity.fromJson(dynamic json) {
    return VendorBookingStatisticSingleResponseEntity(
      data: json["data"] != null
          ? VendorBookingStatisticModel.fromJson(json["data"])
          : null,
      errors:
          json['errors'] != null ? ApiError().fromJson(json['errors']) : null,
      status: json['status']?.toInt(),
    );
  }
}

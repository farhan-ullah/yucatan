// To parse this JSON data, do
//
//     final vendorActivtyObject = vendorActivtyObjectFromJson(jsonString);

import 'dart:convert';

import 'package:yucatan/services/response/vendor_activty_overview_response.dart';

import '../vendor_activity_overview.dart';

VendorActivtyObject vendorActivtyObjectFromJson(String str) =>
    VendorActivtyObject.fromJson(json.decode(str));

String vendorActivtyObjectToJson(VendorActivtyObject data) =>
    json.encode(data.toJson());

class VendorActivtyObject {
  VendorActivtyObject({
    this.status,
    this.data,
  });

  int ? status;
  VendorActivityOverviewData? data;
  ErrorResponse? errorResponse;
  int? statusCode;

  factory VendorActivtyObject.fromJson(Map<String, dynamic> json) =>
      VendorActivtyObject(
        status: json["status"],
        data: VendorActivityOverviewData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
      };
}

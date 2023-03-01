// To parse this JSON data, do
//
//     final vendorNextPayoutResponse = vendorNextPayoutResponseFromJson(jsonString);

import 'dart:convert';

import 'package:yucatan/services/response/vendor_payouts_response.dart';

VendorNextPayoutResponse vendorNextPayoutResponseFromJson(String str) =>
    VendorNextPayoutResponse.fromJson(json.decode(str));

String vendorNextPayoutResponseToJson(VendorNextPayoutResponse data) =>
    json.encode(data.toJson());

class VendorNextPayoutResponse {
  VendorNextPayoutResponse({
    this.status,
    this.data,
  });

  int? status;
  PayoutData? data;

  factory VendorNextPayoutResponse.fromJson(Map<String, dynamic> json) =>
      VendorNextPayoutResponse(
        status: json["status"],
        data: PayoutData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
      };
}

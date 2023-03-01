// To parse this JSON data, do
//
//     final vendorDashboardResponse = vendorDashboardResponseFromJson(jsonString);

import 'dart:convert';

VendorDashboardResponse vendorDashboardResponseFromJson(String str) => VendorDashboardResponse.fromJson(json.decode(str));

String vendorDashboardResponseToJson(VendorDashboardResponse data) => json.encode(data.toJson());

class VendorDashboardResponse {
  VendorDashboardResponse({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory VendorDashboardResponse.fromJson(Map<String, dynamic> json) => VendorDashboardResponse(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.numberOfActivities,
    this.numberOfBookingRequests,
    this.demandForToday,
    this.accountBalance,
    this.openBookingsForToday,
    this.openBookingsForTomorrow,
    this.openBookingsForWeek,
  });

  int? numberOfActivities;
  int? numberOfBookingRequests;
  int? demandForToday;
  double? accountBalance;
  int? openBookingsForToday;
  int? openBookingsForTomorrow;
  int? openBookingsForWeek;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    numberOfActivities: json["numberOfActivities"],
    numberOfBookingRequests: json["numberOfBookingRequests"],
    demandForToday: json["demandForToday"],
    accountBalance: json["accountBalance"].toDouble(),
    openBookingsForToday: json["openBookingsForToday"],
    openBookingsForTomorrow: json["openBookingsForTomorrow"],
    openBookingsForWeek: json["openBookingsForWeek"],
  );

  Map<String, dynamic> toJson() => {
    "numberOfActivities": numberOfActivities,
    "numberOfBookingRequests": numberOfBookingRequests,
    "demandForToday": demandForToday,
    "accountBalance": accountBalance,
    "openBookingsForToday": openBookingsForToday,
    "openBookingsForTomorrow": openBookingsForTomorrow,
    "openBookingsForWeek": openBookingsForWeek,
  };
}

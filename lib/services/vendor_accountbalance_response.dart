// To parse this JSON data, do
//
//     final vendorAccountBalanceResponse = vendorAccountBalanceResponseFromJson(jsonString);

import 'dart:convert';

VendorAccountBalanceResponse vendorAccountBalanceResponseFromJson(String str) => VendorAccountBalanceResponse.fromJson(json.decode(str));

String vendorAccountBalanceResponseToJson(VendorAccountBalanceResponse data) => json.encode(data.toJson());

class VendorAccountBalanceResponse {
  VendorAccountBalanceResponse({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory VendorAccountBalanceResponse.fromJson(Map<String, dynamic> json) => VendorAccountBalanceResponse(
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
    this.accountBalance,
  });

  int? accountBalance;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accountBalance: json["accountBalance"],
  );

  Map<String, dynamic> toJson() => {
    "accountBalance": accountBalance,
  };
}

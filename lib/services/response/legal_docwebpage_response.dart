// To parse this JSON data, do
//
//     final legalDocWebPageResponse = legalDocWebPageResponseFromJson(jsonString);

import 'dart:convert';

LegalDocWebPageResponse legalDocWebPageResponseFromJson(String str) => LegalDocWebPageResponse.fromJson(json.decode(str));

String legalDocWebPageResponseToJson(LegalDocWebPageResponse data) => json.encode(data.toJson());

class LegalDocWebPageResponse {
  LegalDocWebPageResponse({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory LegalDocWebPageResponse.fromJson(Map<String, dynamic> json) => LegalDocWebPageResponse(
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
    this.tos,
    this.privacy,
    this.imprint,
    this.rightOfWithdrawal,
  });

  String? tos;
  String? privacy;
  String? imprint;
  String? rightOfWithdrawal;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tos: json["tos"],
    privacy: json["privacy"],
    imprint: json["imprint"],
    rightOfWithdrawal: json["rightOfWithdrawal"],
  );

  Map<String, dynamic> toJson() => {
    "tos": tos,
    "privacy": privacy,
    "imprint": imprint,
    "rightOfWithdrawal": rightOfWithdrawal,
  };
}

// To parse this JSON data, do
//
//     final contactResponse = contactResponseFromJson(jsonString);

import 'dart:convert';

ContactResponse contactResponseFromJson(String str) => ContactResponse.fromJson(json.decode(str));

String contactResponseToJson(ContactResponse data) => json.encode(data.toJson());

class ContactResponse {
  ContactResponse({
    this.status,
  });

  int? status;
  int? statusCodeApiRequest;

  factory ContactResponse.fromJson(Map<String, dynamic> json) => ContactResponse(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}

// To parse this JSON data, do
//
//     final vendorPayoutsResponse = vendorPayoutsResponseFromJson(jsonString);

import 'dart:convert';

VendorPayoutsResponse vendorPayoutsResponseFromJson(String str) =>
    VendorPayoutsResponse.fromJson(json.decode(str));

String vendorPayoutsResponseToJson(VendorPayoutsResponse data) =>
    json.encode(data.toJson());

class VendorPayoutsResponse {
  VendorPayoutsResponse({
    this.status,
    this.data,
  });

  int? status;
  List<PayoutData>? data;

  factory VendorPayoutsResponse.fromJson(Map<String, dynamic> json) =>
      VendorPayoutsResponse(
        status: json["status"],
        data: List<PayoutData>.from(
            json["data"].map((x) => PayoutData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PayoutData {
  PayoutData({
    this.id,
    this.gross,
    this.refunds,
    this.adjustments,
    this.fees,
    this.net,
    //this.vendor,
    this.status,
    this.payoutDate,
    this.currency,
    this.stripeDestination,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.datumId,
  });

  String? id;
  double? gross;
  double? refunds;
  double? adjustments;
  double? fees;
  double? net;
  //Vendor vendor;
  String? status;
  DateTime? payoutDate;
  String? currency;
  String? stripeDestination;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? datumId;

  factory PayoutData.fromJson(Map<String, dynamic> json) => PayoutData(
        id: json["_id"],
        gross: double.tryParse(json["gross"].toString()) ?? 0,
        refunds: double.tryParse(json["refunds"].toString()) ?? 0,
        adjustments: double.tryParse(json["adjustments"].toString()) ?? 0,
        fees: double.tryParse(json["fees"].toString()) ?? 0,
        net: double.tryParse(json["net"].toString()) ?? 0,
        //vendor: Vendor.fromJson(json["vendor"]),
        status: json["status"],
        payoutDate: DateTime.parse(json["payoutDate"]),
        currency: json["currency"],
        stripeDestination: json["stripeDestination"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        datumId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "gross": gross,
        "refunds": refunds,
        "adjustments": adjustments,
        "fees": fees,
        "net": net,
        //"vendor": vendor.toJson(),
        "status": status,
        "payoutDate": payoutDate!.toIso8601String(),
        "currency": currency,
        "stripeDestination": stripeDestination,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "id": datumId,
      };
}

class Vendor {
  Vendor({
    this.id,
    this.name,
    this.email,
    this.location,
    this.contacts,
    this.createdAt,
    this.updatedAt,
    this.internalCode,
    this.v,
    this.users,
    this.code,
    this.vendorId,
  });

  String? id;
  String? name;
  String? email;
  Location? location;
  List<dynamic>? contacts;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? internalCode;
  int? v;
  List<String>? users;
  String? code;
  String? vendorId;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        location: Location.fromJson(json["location"]),
        contacts: List<dynamic>.from(json["contacts"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        internalCode: json["internalCode"],
        v: json["__v"],
        users: List<String>.from(json["users"].map((x) => x)),
        code: json["code"],
        vendorId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "location": location!.toJson(),
        "contacts": List<dynamic>.from(contacts!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "internalCode": internalCode,
        "__v": v,
        "users": List<dynamic>.from(users!.map((x) => x)),
        "code": code,
        "id": vendorId,
      };
}

class Location {
  Location({
    this.city,
    this.country,
    this.housenumber,
    this.state,
    this.street,
    this.zipcode,
  });

  String? city;
  String? country;
  String? housenumber;
  String? state;
  String? street;
  int? zipcode;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        city: json["city"],
        country: json["country"],
        housenumber: json["housenumber"],
        state: json["state"],
        street: json["street"],
        zipcode: json["zipcode"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "housenumber": housenumber,
        "state": state,
        "street": street,
        "zipcode": zipcode,
      };
}

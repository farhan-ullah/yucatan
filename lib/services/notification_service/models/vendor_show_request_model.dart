import 'package:flutter/material.dart';

class VendorShowRequestModel {
  String bookingId;
  DateTime bookingDate;

  VendorShowRequestModel({
    required this.bookingId,
    required this.bookingDate,
  });

  factory VendorShowRequestModel.fromJson(Map<String, dynamic> json) {
    return VendorShowRequestModel(
      bookingId: json['bookingId'],
      bookingDate: DateTime.tryParse(json['bookingDate'])!,
    );
  }
}

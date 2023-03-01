import 'package:flutter/material.dart';

class VendorShowRefundedBookindModel {
  String bookingId;
  DateTime bookingDate;

  VendorShowRefundedBookindModel({
    required this.bookingId,
    required this.bookingDate,
  });

  factory VendorShowRefundedBookindModel.fromJson(Map<String, dynamic> json) {
    return VendorShowRefundedBookindModel(
      bookingId: json['bookingId'],
      bookingDate: DateTime.tryParse(json['bookingDate'])!,
    );
  }
}

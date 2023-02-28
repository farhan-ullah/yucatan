import 'package:flutter/material.dart';

class BookingScreenTimeSlotItemModel {
  DateTime dateTime;
  String timeString;
  int remainingQuota;

  BookingScreenTimeSlotItemModel({
    required this.dateTime,
    required this.timeString,
    required this.remainingQuota,
  });
}

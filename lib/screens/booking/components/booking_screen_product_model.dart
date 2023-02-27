import 'package:appventure/models/activity_model.dart';
import 'package:appventure/screens/booking/components/booking_screen_time_slot_item_model.dart';
import 'package:flutter/material.dart';

class BookingScreenProductModel {
  Product product;
  BookingScreenTimeSlotItemModel bookingScreenTimeSlotItemModel;

  BookingScreenProductModel({
    @required this.product,
    @required this.bookingScreenTimeSlotItemModel,
  });
}

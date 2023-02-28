import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:flutter/material.dart';

class InquiryScreenParameter {
  ActivityModel activity;
  OrderModel order;
  String selectedPaymentRoute;

  InquiryScreenParameter({
    required this.activity,
    required this.order,
    required this.selectedPaymentRoute,
  });
}

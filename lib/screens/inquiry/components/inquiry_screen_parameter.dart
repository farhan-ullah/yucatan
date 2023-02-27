import 'package:appventure/models/activity_model.dart';
import 'package:appventure/models/order_model.dart';
import 'package:flutter/material.dart';

class InquiryScreenParameter {
  ActivityModel activity;
  OrderModel order;
  String selectedPaymentRoute;

  InquiryScreenParameter({
    @required this.activity,
    @required this.order,
    @required this.selectedPaymentRoute,
  });
}

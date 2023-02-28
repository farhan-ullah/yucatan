import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:flutter/material.dart';

class PaymentCreditCardScreenParameter {
  ActivityModel activity;
  OrderModel order;

  PaymentCreditCardScreenParameter({
    required this.activity,
    required this.order,
  });
}

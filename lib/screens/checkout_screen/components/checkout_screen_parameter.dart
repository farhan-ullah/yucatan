import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:flutter/material.dart';

class CheckoutScreenParameter {
  ActivityModel activity;
  OrderModel order;

  CheckoutScreenParameter({required this.activity, required this.order});
}

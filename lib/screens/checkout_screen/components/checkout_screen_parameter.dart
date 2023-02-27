import 'package:appventure/models/activity_model.dart';
import 'package:appventure/models/order_model.dart';
import 'package:flutter/material.dart';

class CheckoutScreenParameter {
  ActivityModel activity;
  OrderModel order;

  CheckoutScreenParameter({@required this.activity, @required this.order});
}

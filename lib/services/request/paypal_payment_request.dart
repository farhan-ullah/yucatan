import 'dart:convert';

import 'package:yucatan/models/order_model.dart';
import 'package:flutter/material.dart';

class PaypalPaymentRequest {
  OrderModel order;

  PaypalPaymentRequest({required this.order});

  static String toJson(PaypalPaymentRequest paypalPaymentRequest) {
    return json.encode(
      <String, dynamic>{
        'order': OrderModel.toJson(paypalPaymentRequest.order),
      },
    );
  }
}

import 'dart:convert';

import 'package:yucatan/models/credit_card_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:flutter/material.dart';

class CreditCardPaymentRequest {
  CreditCardModel creditCard;
  OrderModel order;

  CreditCardPaymentRequest({required this.creditCard, required this.order});

  static String toJson(CreditCardPaymentRequest creditCardPaymentRequest) {
    return json.encode(
      <String, dynamic>{
        'creditCard':
            CreditCardModel.toJson(creditCardPaymentRequest.creditCard),
        'order': OrderModel.toJson(creditCardPaymentRequest.order),
      },
    );
  }
}

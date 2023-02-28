import 'package:flutter/material.dart';

class CreditCardModel {
  String number;
  int expMonth;
  int expYear;
  String cvc;

  CreditCardModel({
    required this.number,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
  });

  static Map<String, dynamic> toJson(CreditCardModel creditCardModel) {
    return {
      "number": creditCardModel.number,
      "expMonth": creditCardModel.expMonth,
      "expYear": creditCardModel.expYear,
      "cvc": creditCardModel.cvc,
    };
  }
}

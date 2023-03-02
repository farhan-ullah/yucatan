import 'dart:async';

import 'package:yucatan/models/credit_card_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/services/payment_service.dart';
import 'package:yucatan/services/response/payment_response.dart';

class PaymentCreditCardBloc {
  final _tooltipController = StreamController<bool>();
  final _paymentController = StreamController<Future<PaymentResponse>>();
  final _emptyValidationController = StreamController<bool>();
  final _invalidValidationController = StreamController<bool>();
  final _cardScanningController = StreamController<bool>();

  Stream<bool> get getToolTip => _tooltipController.stream;

  set setToolTip(bool value) => _tooltipController.sink.add(value);

  Stream<bool> get getScanning => _cardScanningController.stream;

  set setScanning(bool value) => _cardScanningController.sink.add(value);

  Stream<bool> get getEmptyValidation => _emptyValidationController.stream;

  set _setValidation(bool value) => _emptyValidationController.sink.add(value);

  Stream<bool> get getInvalidValidation => _invalidValidationController.stream;

  set setInvalidValidation(bool value) =>
      _invalidValidationController.sink.add(value);

  Stream<Future<PaymentResponse>> get getPaymentResponse =>
      _paymentController.stream;

  set setPaymentResponse(Future<PaymentResponse> response) =>
      _paymentController.sink.add((response));

  payment(String name, String cardNumber, String expireDate, String cvv,
      OrderModel order) {
    if (!_validate(cardNumber, expireDate, cvv)) {
      return;
    }

    cardNumber = cardNumber.replaceAll(' ', '');
    List<String> expDates = expireDate.split('/');

    CreditCardModel creditCard = CreditCardModel(
      number: cardNumber,
      expMonth: int.parse(expDates[0]),
      expYear: int.parse(expDates[1]),
      cvc: cvv,
    );

    Future<PaymentResponse> future =
        PaymentService.payWithCreditCard(creditCard, order);
    setPaymentResponse = future;
  }

  bool _validate(String cardNumber, String expireDate, String cvv) {
    if (cardNumber.isEmpty || expireDate.isEmpty || cvv.isEmpty) {
      _setValidation = false;
      return false;
    }

    _setValidation = true;
    return true;
  }

  dispose() {
    _tooltipController.close();
    _paymentController.close();
    _emptyValidationController.close();
    _invalidValidationController.close();
    _cardScanningController.close();
  }
}

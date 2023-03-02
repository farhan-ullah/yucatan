import 'dart:async';
import 'dart:convert';

import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/services/payment_service.dart';
import 'package:yucatan/services/response/payment_response.dart';
import 'package:yucatan/services/response/paypal_payment_purchase_response.dart';

class PaymentPaypalBloc {
  final _paypalController = StreamController<PaypalPaymentPurchaseResponse>();
  final _paymentSuccessController = StreamController<Future<PaymentResponse>>();

  Stream<PaypalPaymentPurchaseResponse> get paypalResponseStream =>
      _paypalController.stream;

  set _setPaypalResponse(PaypalPaymentPurchaseResponse response) =>
      _paypalController.sink.add(response);

  Stream<Future<PaymentResponse>> get getPaymentResponse =>
      _paymentSuccessController.stream;

  set _setPaymentResponse(Future<PaymentResponse> response) =>
      _paymentSuccessController.sink.add(response);

  requestPayment(OrderModel orderModel) async {
    PaypalPaymentPurchaseResponse? response =
        await PaymentService.payWithPaypal(orderModel);
    _setPaypalResponse = response!;
  }

  proceedPaymentResponse(String data) {
    BookingModel? bookingModel;
    try {
      var parsedData = _parseData(data);
      bookingModel = BookingModel.fromJson(jsonDecode(parsedData)['data']);
    } catch (e) {}

    Future<PaymentResponse> future = Future<PaymentResponse>.sync(() {
      return PaymentResponse(
          status: bookingModel == null ? 500 : 200,
          success: bookingModel == null ? false : true,
          booking: bookingModel!);
    });

    _setPaymentResponse = future;
  }

  String _parseData(String data) {
    return data.split(';">')[1].split('</pre>')[0];
  }

  dispose() {
    _paypalController.close();
    _paymentSuccessController.close();
  }
}

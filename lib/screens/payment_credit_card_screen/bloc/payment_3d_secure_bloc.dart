import 'dart:async';
import 'dart:convert';

import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/response/payment_response.dart';

class Payment3DSecureBloc {
  final _webviewController = StreamController<bool>();
  final _paymentSuccessController = StreamController<Future<PaymentResponse>>();

  Stream<bool> get webviewStream => _webviewController.stream;

  set setWebview(bool value) => _webviewController.sink.add(value);

  Stream<Future<PaymentResponse>> get getPaymentResponse =>
      _paymentSuccessController.stream;

  set _setPaymentResponse(Future<PaymentResponse> response) =>
      _paymentSuccessController.sink.add(response);

  proceedPaymentResponse(String data) {
    BookingModel? bookingModel;
    try {
      var parsedData = _parseData(data);
      bookingModel = BookingModel.fromJson(jsonDecode(parsedData)['data']);
    } catch (e) {}
    if (_checkPaymentResponseBooking(bookingModel!)) {
      HiveService.updateDatabase();
    }
    Future<PaymentResponse> future = Future<PaymentResponse>.sync(() {
      return PaymentResponse(
        status: bookingModel == null
            ? 500
            : bookingModel.status == 'ERROR'
                ? 500
                : 200,
        success: bookingModel == null
            ? false
            : bookingModel.status == 'ERROR'
                ? false
                : true,
        booking: bookingModel,
      );
    });

    _setPaymentResponse = future;
  }

  bool _checkPaymentResponseBooking(BookingModel bookingModel) {
    return bookingModel != null && bookingModel.status != "ERROR";
  }

  String _parseData(String data) {
    return data.split(';">')[1].split('</pre>')[0];
  }

  dispose() {
    _webviewController.close();
    _paymentSuccessController.close();
  }
}

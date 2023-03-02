import 'dart:convert';

import 'package:yucatan/models/credit_card_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/request/credit_card_payment_request.dart';
import 'package:yucatan/services/request/paypal_payment_request.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/booking_single_response_entity.dart';
import 'package:yucatan/services/response/payment_response.dart';
import 'package:yucatan/services/response/paypal_payment_purchase_response.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class PaymentService extends BaseService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // this class is static only
  PaymentService._() : super(BaseService.defaultURL + '/payments');

  static Future<PaymentResponse> payWithCreditCard(
      CreditCardModel creditCard, OrderModel order) async {
    CreditCardPaymentRequest creditCardPaymentRequest =
        CreditCardPaymentRequest(creditCard: creditCard, order: order);

    //Log firebase event
    AnalyticsService.logRequestPurchase(order, 'credit_card');

    var requestBody = CreditCardPaymentRequest.toJson(creditCardPaymentRequest);

    var httpData =
        (await new PaymentService._().post('/paywithcreditcard', requestBody))!
            .body;
    if (httpData != null) {
      return PaymentResponse.fromJson(json.decode(httpData));
    }
    return null!;
  }

  static Future<PaypalPaymentPurchaseResponse?> payWithPaypal(
      OrderModel order) async {
    //Log firebase event
    AnalyticsService.logRequestPurchase(order, 'paypal');

    var requestBody =
        PaypalPaymentRequest.toJson(PaypalPaymentRequest(order: order));

    var httpData = (await new PaymentService._()
            .post('/create-paypal-payment', requestBody))!
        .body;
    if (httpData != null) {
      return new PaypalPaymentPurchaseResponse.fromJson(json.decode(httpData));
    } else
      return null;
  }

  static Future<String?> payWithApplePay(String id) async {
    //TODO implement Apple Pay
    return null;
  }

  static Future<String?> payWithGooglePay(String id) async {
    //TODO implement Google Pay
    return null;
  }

  //Refund entire booking
  static Future<BookingSingleResponseEntity?> refundBooking(
      String bookingId) async {
    var requestBody = jsonEncode({
      'booking': bookingId,
    });

    var httpData =
        (await new PaymentService._().post('/refund/booking', requestBody))!
            .body;
    if (httpData != null) {
      var result;
      try {
        result = BookingSingleResponseEntity().fromJson(json.decode(httpData));
      } catch (e) {
        var data = jsonDecode(httpData)["data"];
        var status = jsonDecode(httpData)["status"];
        var result = BookingSingleResponseEntity();
        result.status = status;
        var apiError = ApiError();
        apiError.message = data;
        result.error = apiError;
        return result;
      }

      if (result.status == 200) {
        //Log firebase event
        if (kReleaseMode) {
          analytics.logEvent(
            name: 'refund_booking',
            parameters: <String, dynamic>{
              'booking_id': result.data.id,
              'value': result.data.totalPrice,
              'currency': result.data.currency,
              'time': DateTime.now().toIso8601String(),
            },
          );
        }
      }

      return result;
    } else
      return null;
  }

  //Refund single ticket
  static Future<BookingSingleResponseEntity?> refundSingleTicket(
      String bookingId, String ticketId) async {
    var requestBody = jsonEncode({
      'booking': bookingId,
      'ticket': ticketId,
    });

    var httpData =
        (await new PaymentService._().post('/refund/ticket', requestBody))
            ?.body;
    if (httpData != null) {
      var result;
      try {
        result = BookingSingleResponseEntity().fromJson(json.decode(httpData));
      } catch (e) {
        var data = jsonDecode(httpData)["data"];
        var status = jsonDecode(httpData)["status"];
        var result = BookingSingleResponseEntity();
        result.status = status;
        var apiError = ApiError();
        apiError.message = data;
        result.error = apiError;
        return result;
      }

      if (result.status == 200) {
        //Log firebase event
        if (kReleaseMode) {
          analytics.logEvent(
            name: 'refund_ticket',
            parameters: <String, dynamic>{
              'booking_id': result.data.id,
              'ticket_id': ticketId,
              'value': result.data.tickets
                  .firstWhere((element) => element.id == ticketId,
                      orElse: () => null)
                  ?.price,
              'currency': result.data.currency,
              'time': DateTime.now().toIso8601String(),
            },
          );
        }
      }

      return result;
    } else
      return null;
  }

  //Refund entire booking as vendor
  static Future<BookingSingleResponseEntity?> refundBookingAsVendor(
      String bookingId) async {
    var requestBody = jsonEncode({
      'booking': bookingId,
    });

    var httpData =
        (await new PaymentService._().post('/refund/vendor', requestBody))
            ?.body;
    if (httpData != null) {
      var result;
      try {
        result = BookingSingleResponseEntity().fromJson(json.decode(httpData));
      } catch (e) {
        var data = jsonDecode(httpData)["data"];
        var status = jsonDecode(httpData)["status"];
        var result = BookingSingleResponseEntity();
        result.status = status;
        var apiError = ApiError();
        apiError.message = data;
        result.error = apiError;
        return result;
      }

      if (result.status == 200) {
        //Log firebase event
        if (kReleaseMode) {
          analytics.logEvent(
            name: 'refund_booking_vendor',
            parameters: <String, dynamic>{
              'booking_id': result.data.id,
              'value': result.data.totalPrice,
              'currency': result.data.currency,
              'time': DateTime.now().toIso8601String(),
            },
          );
        }
      }

      return result;
    } else
      return null;
  }
}

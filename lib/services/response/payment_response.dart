import 'package:yucatan/models/booking_model.dart';

class PaymentResponse {
  int? status;
  bool? success;
  BookingModel? booking;
  PaymentThreeDSecure? threeDSecurePayment;

  PaymentResponse({
    this.status,
    this.success,
    this.booking,
    this.threeDSecurePayment,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['status'],
      success: json['data'] != null,
      booking: json['data'] != null && json['data']['_id'] != null
          ? BookingModel.fromJson(json['data'])
          : null,
      threeDSecurePayment: json['data'] != null && json['data']['_id'] == null
          ? PaymentThreeDSecure.fromJson(json['data'])
          : null,
    );
  }
}

class PaymentThreeDSecure {
  String? status;
  String? url;

  PaymentThreeDSecure({
    this.status,
    this.url,
  });

  factory PaymentThreeDSecure.fromJson(Map<String, dynamic> json) {
    return PaymentThreeDSecure(
      status: json['status'],
      url: json['url'],
    );
  }
}

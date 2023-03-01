class PaypalPaymentPurchaseResponse {
  int? status;
  String? url;

  PaypalPaymentPurchaseResponse({
    this.status,
    this.url,
  });

  factory PaypalPaymentPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return PaypalPaymentPurchaseResponse(
      status: json['status'],
      url: json['data'],
    );
  }
}

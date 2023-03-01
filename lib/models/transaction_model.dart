import 'package:yucatan/services/response/vendor_payouts_response.dart';

class TransactionModel {
  String? bookingId;
  String? bookingState;
  DateTime? dateTime;
  String? buyer;
  double? totalPrice;
  List<TransactionTicket>? tickets;
  bool isPayoutObject = false;
  PayoutData? payoutData;
  List<TransactionProduct>? products;

  TransactionModel({
    this.bookingId,
    this.bookingState,
    this.dateTime,
    this.buyer,
    this.totalPrice,
    this.tickets,
    this.products,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      bookingId: json["bookingId"],
      bookingState: json["bookingState"],
      dateTime: DateTime.tryParse(json["date"]),
      buyer: json["buyer"],
      totalPrice: double.parse(json["totalPrice"].toString()),
      tickets: json["tickets"] != null
          ? json["tickets"]
              .map<TransactionTicket>(
                  (value) => TransactionTicket.fromJson(value))
              .toList()
          : null,
      products: json['products'] != null
          ? json["products"]
              .map<TransactionProduct>(
                  (value) => TransactionProduct.fromJson(value))
              .toList()
          : null,
    );
  }
}

class TransactionTicket {
  String? id;
  String? state;
  double? price;

  TransactionTicket({this.id, this.state, this.price});

  factory TransactionTicket.fromJson(Map<String, dynamic> json) {
    return TransactionTicket(
        id: json["id"].toString(),
        state: json["state"].toString(),
        price: double.parse(json["price"].toString()));
  }
}

class TransactionProduct {
  String? id;
  String? title;
  int? quantity;
  String? bookingTimeString;

  TransactionProduct({
    this.id,
    this.title,
    this.quantity,
    this.bookingTimeString,
  });

  factory TransactionProduct.fromJson(Map<String, dynamic> json) {
    return TransactionProduct(
      id: json["id"].toString(),
      title: json["title"],
      quantity: json["quantity"],
      bookingTimeString: json['bookingTimeString'],
    );
  }
}

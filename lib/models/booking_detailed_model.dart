import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:hive/hive.dart';

import 'file_model.dart';
import 'invoice_address_model.dart';
import 'user_model.dart';

part 'booking_detailed_model.g.dart';

@HiveType(typeId: 17)
class BookingDetailedModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? vendor;
  @HiveField(2)
  UserModel? user;
  @HiveField(3)
  ActivityModel? activity;
  @HiveField(4)
  String? status;
  @HiveField(5)
  String? paymentProvider;
  @HiveField(6)
  String? currency;
  @HiveField(7)
  String? paypalPaymentId;
  @HiveField(8)
  double? totalPrice;
  @HiveField(9)
  DateTime? bookingDate;
  @HiveField(10)
  String? reference;
  @HiveField(11)
  List<BookingTicket>? tickets;
  @HiveField(12)
  List<BookingProduct>? products;
  @HiveField(13)
  String? requestNote;
  @HiveField(14)
  InvoiceAddressModel? invoiceAddress;

  BookingDetailedModel({
    this.id,
    this.vendor,
    this.user,
    this.activity,
    this.status,
    this.paymentProvider,
    this.currency,
    this.paypalPaymentId,
    this.totalPrice,
    this.bookingDate,
    this.reference,
    this.tickets,
    this.products,
    this.requestNote,
    this.invoiceAddress,
  });

  factory BookingDetailedModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailedModel(
      id: json['_id'],
      vendor: json['vendor']['_id'],
      user: UserModel().fromJson(json['user']),
      activity: json['activity'] == null
          ? null
          : activityModelFromJsonCustom(json['activity']),
      status: json['status'],
      paymentProvider: json['paymentProvider'],
      currency: json['currency'],
      paypalPaymentId: json['paypalPaymentId'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      bookingDate: DateTime.tryParse(json['bookingDate']),
      reference: json['reference'],
      requestNote: json['requestNote'],
      tickets: json['tickets'] != null
          ? json['tickets']
              .map<BookingTicket>(
                (value) => BookingTicket.fromJson(value),
              )
              .toList()
          : null,
      products: json['products'] != null
          ? json['products']
              .map<BookingProduct>(
                (value) => BookingProduct.fromJson(value),
              )
              .toList()
          : null,
      invoiceAddress: InvoiceAddressModel.fromJson(json['invoiceAddress']),
    );
  }

  BookingModel toBookingModel() {
    BookingModel data = BookingModel(
        activity: activity!.sId!,
        currency: currency!,
        bookingDate: bookingDate!,
        paymentProvider: paymentProvider!,
        paypalPaymentId: paypalPaymentId!,
        id: id!,
        products: products!,
        reference: reference!,
        vendor: vendor!,
        requestNote: requestNote!,
        status: status!,
        tickets: tickets!,
        totalPrice: totalPrice!,
        user: user!.sId,
        invoiceAddress: invoiceAddress!);

    return data;
  }
}

ActivityModel activityModelFromJsonCustom(Map<String, dynamic> json) {
  ActivityModel data = ActivityModel();
  if (json['location'] != null) {
    data.location = new ActivityModelLocation().fromJson(json['location']);
  }
  if (json['activityDetails'] != null) {
    data.activityDetails =
        new ActivityModelActivityDetails().fromJson(json['activityDetails']);
  }
  if (json['openingHours'] != null) {
    data.openingHours =
        ActivityModelOpeningHours.fromJson(json['openingHours']);
  }
  if (json['bookingDetails'] != null) {
    data.bookingDetails =
        new ActivityBookingDetails().fromJson(json['bookingDetails']);
  }
  if (json['tags'] != null) {
    data.tags =
        json['tags']?.map((v) => v?.toString())?.toList()?.cast<String>();
  }
  if (json['categories'] != null) {
    data.categories = <ActivityCategory>[];
    (json['categories'] as List).forEach((v) {
      data.categories!.add(new ActivityCategory().fromJson(v));
    });
  }
  if (json['_id'] != null) {
    data.sId = json['_id']?.toString();
  }
  if (json['title'] != null) {
    data.title = json['title']?.toString();
  }
  if (json['description'] != null) {
    data.description = json['description']?.toString();
  }
  if (json['bookings'] != null) {
    data.bookings = json['bookings']?.toInt();
  }
  if (json['thumbnail'] != null) {
    data.thumbnail = FileModel.fromJson(json['thumbnail']);
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt']?.toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt']?.toString();
  }
  if (json['__v'] != null) {
    data.iV = json['__v']?.toInt();
  }
  if (json['reviewCount'] != null) {
    data.reviewCount = json['reviewCount']?.toInt();
  }
  if (json['reviewAverageRating'] != null) {
    data.reviewAverageRating =
        double.tryParse(json['reviewAverageRating']!.toString());
  }
  if (json['priceFrom'] != null) {
    data.priceFrom = double.tryParse(json['priceFrom'].toString());
  }
  if (json['vendor'] != null) {
    data.vendor = new ActivityVendor().fromJson(json['vendor']);
  }
  if (json['privacy'] != null) {
    data.privacy = json['privacy']?.toString();
  }
  return data;
}

import 'package:yucatan/models/file_model.dart';
import 'package:yucatan/models/invoice_address_model.dart';
import 'package:hive/hive.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 16)
class BookingModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? vendor;
  @HiveField(2)
  String? user;
  @HiveField(3)
  String? activity;
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

  BookingModel(
      {this.id,
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
      this.invoiceAddress});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      vendor: json['vendor'],
      user: json['user'],
      activity: json['activity'],
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
}

@HiveType(typeId: 15)
class BookingTicket {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? productId;
  @HiveField(2)
  String? ticket;
  @HiveField(3)
  String? qr;
  @HiveField(4)
  String? status;
  @HiveField(5)
  double? price;
  @HiveField(6)
  List<AdditionalServiceInfoTicket>? additionalServiceInfo;
  @HiveField(7)
  String? bookingTimeString;

  BookingTicket({
    this.id,
    this.productId,
    this.ticket,
    this.qr,
    this.status,
    this.price,
    this.additionalServiceInfo,
    this.bookingTimeString,
  });

  factory BookingTicket.fromJson(Map<String, dynamic> json) {
    return BookingTicket(
      id: json['_id'],
      productId: json['productId'],
      ticket: json['ticket'],
      qr: json['qr'],
      status: json['status'],
      price: double.parse(json['price'].toString()),
      additionalServiceInfo: json['additionalServiceInfo'] != null
          ? json['additionalServiceInfo']
              .map<AdditionalServiceInfoTicket>(
                (value) => AdditionalServiceInfoTicket.fromJson(value),
              )
              .toList()
          : null,
      bookingTimeString: json['bookingTimeString'],
    );
  }
}

@HiveType(typeId: 14)
class AdditionalServiceInfoTicket {
  @HiveField(0)
  String? additionalServiceId;
  @HiveField(1)
  int? quantity;

  AdditionalServiceInfoTicket({
    this.additionalServiceId,
    this.quantity,
  });

  factory AdditionalServiceInfoTicket.fromJson(Map<String, dynamic> json) {
    return AdditionalServiceInfoTicket(
      additionalServiceId: json['additionalServiceId'],
      quantity: json['quantity'],
    );
  }
}

@HiveType(typeId: 13)
class BookingProduct {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  //@HiveField(0)
  FileModel? image;
  @HiveField(2)
  String? description;
  @HiveField(3)
  double? price;
  @HiveField(4)
  int? quantity;
  @HiveField(5)
  String? categoryTitle;
  @HiveField(6)
  String? subCategoryTitle;
  @HiveField(7)
  List<BookingProductProperty>? properties;
  @HiveField(8)
  String? additionalServicesDescription;
  @HiveField(9)
  List<ProductAdditionalService>? additionalServices;

  BookingProduct({
    this.id,
    this.title,
    this.image,
    this.description,
    this.price,
    this.quantity,
    this.categoryTitle,
    this.subCategoryTitle,
    this.properties,
    this.additionalServicesDescription,
    this.additionalServices,
  });

  factory BookingProduct.fromJson(Map<String, dynamic> json) {
    return BookingProduct(
      id: json['_id'],
      title: json['title'],
      image: json['image'] != null ? FileModel.fromJson(json['image']) : null,
      description: json['description'],
      price: double.parse(json['price']['\$numberDecimal'].toString()),
      categoryTitle: json['categoryTitle'],
      subCategoryTitle: json['subCategoryTitle'],
      properties: json['properties'] != null
          ? json['properties']
              .map<BookingProductProperty>(
                (value) => BookingProductProperty.fromJson(value),
              )
              .toList()
          : null,
      additionalServicesDescription: json['additionalServicesDescription'],
      additionalServices: json['additionalServices'] != null
          ? json['additionalServices']
              .map<ProductAdditionalService>(
                (value) => ProductAdditionalService.fromJson(value),
              )
              .toList()
          : null,
      quantity: json['quantity'],
    );
  }
}

@HiveType(typeId: 12)
class ProductAdditionalService {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  // @HiveField(2)
  FileModel? image;
  @HiveField(3)
  String? description;
  @HiveField(4)
  double? price;
  @HiveField(5)
  int? quantity;
  @HiveField(6)
  List<BookingProductProperty>? properties;

  ProductAdditionalService({
    this.id,
    this.title,
    this.image,
    this.description,
    this.price,
    this.quantity,
    this.properties,
  });

  factory ProductAdditionalService.fromJson(Map<String, dynamic> json) {
    return ProductAdditionalService(
      id: json['_id'],
      title: json['title'],
      image: json['image'] != null ? FileModel.fromJson(json['image']) : null,
      description: json['description'],
      price: double.parse(json['price']['\$numberDecimal'].toString()),
      properties: json['properties'] != null
          ? json['properties']
              .map<BookingProductProperty>(
                (value) => BookingProductProperty.fromJson(value),
              )
              .toList()
          : null,
      quantity: json['quantity'],
    );
  }
}

@HiveType(typeId: 11)
class BookingProductProperty {
  @HiveField(0)
  String? id;
  @HiveField(1)
  bool? isRequired;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? info;
  @HiveField(4)
  BookingProductPropertyType? type;
  @HiveField(5)
  String? value;

  BookingProductProperty({
    this.id,
    this.isRequired,
    this.title,
    this.info,
    this.type,
    this.value,
  });

  factory BookingProductProperty.fromJson(Map<String, dynamic> json) {
    return BookingProductProperty(
      id: json['_id'],
      isRequired: json['required'],
      title: json['title'],
      info: json['info'],
      type: json['type'] == "DROPDOWN"
          ? BookingProductPropertyType.DROPDOWN
          : json['type'] == "TEXT"
              ? BookingProductPropertyType.TEXT
              : json['type'] == "NUMBER"
                  ? BookingProductPropertyType.NUMBER
                  : null,
      value: json['value'],
    );
  }
}

@HiveType(typeId: 10)
enum BookingProductPropertyType {
  @HiveField(0)
  DROPDOWN,
  @HiveField(1)
  TEXT,
  @HiveField(2)
  NUMBER,
}

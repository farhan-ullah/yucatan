import 'package:hive/hive.dart';

part 'invoice_address_model.g.dart';

@HiveType(typeId: 60)
class InvoiceAddressModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? houseNumber;
  @HiveField(2)
  String? street;
  @HiveField(3)
  String? city;
  @HiveField(4)
  int? zip;
  @HiveField(5)
  String? phone;

  InvoiceAddressModel({
    this.name,
    this.houseNumber,
    this.street,
    this.city,
    this.zip,
    this.phone,
  });

  factory InvoiceAddressModel.fromJson(Map<String, dynamic> json) {
    return InvoiceAddressModel(
        city: json['city'],
        houseNumber: json['houseNumber'],
        name: json['name'],
        phone: json['phone'],
        street: json['street'],
        zip: json['zip']);
  }
}

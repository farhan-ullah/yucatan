import 'package:yucatan/screens/booking/components/booking_screen_time_slot_item_model.dart';
import 'package:flutter/material.dart';

class OrderModel {
  String? activityId;
  String? userId;
  DateTime? bookingDate;
  List<OrderProduct>? products;
  AddressModel? address;

  OrderModel({
    this.activityId,
    this.userId,
    this.bookingDate,
    this.products,
    this.address,
  });

  static Map<String, dynamic> toJson(OrderModel orderModel) {
    return {
      "activityId": orderModel.activityId,
      "userId": orderModel.userId,
      "bookingDate": orderModel.bookingDate!.toIso8601String(),
      "products": orderModel.products != null && orderModel.products!.length > 0
          ? orderModel.products!
              .map(
                (product) => OrderProduct.toJson(product),
              )
              .toList()
          : [],
      "invoiceAddress": AddressModel.toJson(orderModel.address!),
    };
  }
}

class OrderProduct {
  String? id;
  int? amount;
  List<OrderProductProperty>? properties;
  List<OrderProductAdditionalService>? additionalServices;
  String? bookingTimeString;
  BookingScreenTimeSlotItemModel?
      bookingScreenTimeSlotItemModel; //Does not need to be parsed to json

  OrderProduct({
    this.id,
    this.amount,
    this.properties,
    this.additionalServices,
    this.bookingTimeString,
    this.bookingScreenTimeSlotItemModel,
  });

  static Map<String, dynamic> toJson(OrderProduct orderProduct) {
    return {
      "id": orderProduct.id,
      "quantity": orderProduct.amount,
      "properties":
          orderProduct.properties != null && orderProduct.properties!.length > 0
              ? orderProduct.properties!
                  .map(
                    (property) => OrderProductProperty.toJson(property),
                  )
                  .toList()
              : [],
      "additionalServices": orderProduct.additionalServices != null &&
              orderProduct.additionalServices!.length > 0
          ? orderProduct.additionalServices!
              .map(
                (additionalService) =>
                    OrderProductAdditionalService.toJson(additionalService),
              )
              .toList()
          : [],
      "bookingTimeString": orderProduct.bookingTimeString,
    };
  }
}

class OrderProductProperty {
  String? id;
  String? value;

  OrderProductProperty({
    this.id,
    this.value,
  });

  static Map<String, dynamic> toJson(
      OrderProductProperty orderProductProperty) {
    return {
      "id": orderProductProperty.id,
      "value": orderProductProperty.value,
    };
  }
}

class OrderProductAdditionalService {
  String? id;
  int? amount;
  List<OrderProductProperty>? properties;

  OrderProductAdditionalService({
    this.id,
    this.amount,
    this.properties,
  });

  static Map<String, dynamic> toJson(
      OrderProductAdditionalService orderProductAdditionalService) {
    return {
      "id": orderProductAdditionalService.id,
      "quantity": orderProductAdditionalService.amount,
      "properties": orderProductAdditionalService.properties != null &&
              orderProductAdditionalService.properties!.length > 0
          ? orderProductAdditionalService.properties!
              .map(
                (property) => OrderProductProperty.toJson(property),
              )
              .toList()
          : [],
    };
  }
}

class AddressModel {
  String name;
  String email;
  String street;
  String houseNumber;
  String zipCode;
  String city;
  String? phone;
  String countryISO2;
  String areaCode;

  AddressModel({
    required this.name,
    required this.email,
    required this.street,
    required this.houseNumber,
    required this.zipCode,
    required this.city,
    required this.countryISO2,
    required this.areaCode,
    this.phone,
  });

  static Map<String, dynamic> toJson(AddressModel addressModel) {
    var parsedData = {
      "name": addressModel.name,
      "email": addressModel.email,
      "street": addressModel.street,
      "houseNumber": addressModel.houseNumber,
      "zipCode": addressModel.zipCode,
      "city": addressModel.city,
      "countryISO2": addressModel.countryISO2,
      "areaCode": addressModel.areaCode,
    };

    if (addressModel.phone != null && addressModel.phone != "") {
      parsedData["phone"] = addressModel.phone!;
    }

    return parsedData;
  }
}

// To parse this JSON data, do
//
//     final productDemandResponse = productDemandResponseFromJson(jsonString);

import 'dart:convert';

ProductDemandResponse productsResponseFromJson(String str) =>
    ProductDemandResponse.fromJson(json.decode(str));

String productsResponseToJson(ProductDemandResponse data) =>
    json.encode(data.toJson());

class ProductDemandResponse {
  ProductDemandResponse({
    this.status,
    this.data,
  });

  int? status;
  List<ProductDemandData>? data;
  List<ProductDemand>? productsList = [];

  factory ProductDemandResponse.fromJson(Map<String, dynamic> json) =>
      ProductDemandResponse(
        status: json["status"],
        data: json['data'] != null
            ? List<ProductDemandData>.from(
                json["data"].map(
                  (x) => ProductDemandData.fromJson(x),
                ),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data != null
            ? List<dynamic>.from(
                data!.map(
                  (x) => x.toJson(),
                ),
              )
            : null,
      };
}

class ProductDemandData {
  ProductDemandData({
    this.id,
    this.activity,
    this.products,
  });

  String? id;
  String? activity;
  List<ProductDemand>? products;

  factory ProductDemandData.fromJson(Map<String, dynamic> json) =>
      ProductDemandData(
        id: json["_id"],
        activity: json["activity"],
        products: json['products'] != null
            ? List<ProductDemand>.from(
                json["products"].map(
                  (x) => ProductDemand.fromJson(x),
                ),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "activity": activity,
        "products": products != null
            ? List<dynamic>.from(
                products!.map(
                  (x) => x.toJson(),
                ),
              )
            : null,
      };
}

class ProductDemand {
  ProductDemand({
    this.id,
    this.quantity,
    this.properties,
    this.additionalServices,
    this.title,
  });

  String? id;
  int? quantity;
  List<dynamic>? properties;
  List<dynamic>? additionalServices;
  String? title;

  factory ProductDemand.fromJson(Map<String, dynamic> json) => ProductDemand(
        id: json["_id"],
        quantity: json["quantity"],
        properties: json['properties'] != null
            ? List<dynamic>.from(
                json["properties"].map((x) => x),
              )
            : null,
        additionalServices: json['additionalServices'] != null
            ? List<dynamic>.from(
                json["additionalServices"].map((x) => x),
              )
            : null,
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "quantity": quantity,
        "properties": properties != null
            ? List<dynamic>.from(
                properties!.map((x) => x),
              )
            : null,
        "additionalServices": additionalServices != null
            ? List<dynamic>.from(
                additionalServices!.map((x) => x),
              )
            : null,
        "title": title,
      };
}

// To parse this JSON data, do
//
//     final vendorActivtyOverviewResponse = vendorActivtyOverviewResponseFromJson(jsonString);

import 'dart:convert';

VendorActivtyOverviewResponse vendorActivtyOverviewResponseFromJson(
        String str) =>
    VendorActivtyOverviewResponse.fromJson(json.decode(str));

String vendorActivtyOverviewResponseToJson(
        VendorActivtyOverviewResponse data) =>
    json.encode(data.toJson());

class VendorActivtyOverviewResponse {
  VendorActivtyOverviewResponse({
    this.status,
    this.data,
  });

  int? status;
  List<VendorActivityOverviewData>? data;

  factory VendorActivtyOverviewResponse.fromJson(Map<String, dynamic> json) =>
      VendorActivtyOverviewResponse(
        status: json["status"],
        data: List<VendorActivityOverviewData>.from(
            json["data"].map((x) => VendorActivityOverviewData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class VendorActivityOverviewData {
  VendorActivityOverviewData({
    this.id,
    this.title,
    this.publishingStatus,
    this.thumbnail,
    this.vendor,
    this.createdAt,
    this.updatedAt,
    this.numberOfBookings,
    this.priceFrom,
    this.reviewAverageRating,
    this.reviewCount,
    this.code,
  });

  String? id;
  String? title;
  String? publishingStatus;
  Thumbnail? thumbnail;
  String? vendor;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? numberOfBookings;
  double? priceFrom;
  int? reviewAverageRating;
  int? reviewCount;
  String? code;

  factory VendorActivityOverviewData.fromJson(Map<String, dynamic> json) =>
      VendorActivityOverviewData(
        id: json["_id"],
        title: json["title"],
        publishingStatus: json["publishingStatus"],
        thumbnail: json["thumbnail"] == null
            ? null
            : Thumbnail.fromJson(json["thumbnail"]),
        vendor: json["vendor"],
        numberOfBookings: json["numberOfBookings"],
        priceFrom: json["priceFrom"] == null
            ? 0
            : double.parse(json["priceFrom"].toString()),
        reviewAverageRating: json["reviewAverageRating"],
        reviewCount: json["reviewCount"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "publishingStatus": publishingStatus,
        "thumbnail": thumbnail!.toJson(),
        "vendor": vendor,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "numberOfBookings": numberOfBookings,
        "priceFrom": priceFrom,
        "reviewAverageRating": reviewAverageRating,
        "reviewCount": reviewCount,
        "code": code
      };
}

class ActivityDetails {
  ActivityDetails({
    this.media,
    this.title,
    this.shortDescription,
    this.longDescription,
    this.descriptionItems,
    this.cancellation,
    this.reviews,
  });

  Media? media;
  String? title;
  String? shortDescription;
  String? longDescription;
  List<DescriptionItem>? descriptionItems;
  int? cancellation;
  List<dynamic>? reviews;

  factory ActivityDetails.fromJson(Map<String, dynamic> json) =>
      ActivityDetails(
        media: Media.fromJson(json["media"]),
        title: json["title"],
        shortDescription: json["shortDescription"],
        longDescription: json["longDescription"],
        descriptionItems: List<DescriptionItem>.from(
            json["descriptionItems"].map((x) => DescriptionItem.fromJson(x))),
        cancellation: json["cancellation"],
        reviews: json["reviews"] == null
            ? null
            : List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "media": media!.toJson(),
        "title": title,
        "shortDescription": shortDescription,
        "longDescription": longDescription,
        "descriptionItems":
            List<dynamic>.from(descriptionItems!.map((x) => x.toJson())),
        "cancellation": cancellation,
        "reviews": List<dynamic>.from(reviews!.map((x) => x)),
      };
}

class DescriptionItem {
  DescriptionItem({
    this.id,
    this.iconId,
    this.shortDescription,
    this.longDescription,
  });

  String? id;
  int? iconId;
  String? shortDescription;
  String? longDescription;

  factory DescriptionItem.fromJson(Map<String, dynamic> json) =>
      DescriptionItem(
        id: json["_id"],
        iconId: json["iconId"],
        shortDescription: json["shortDescription"],
        longDescription: json["longDescription"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "iconId": iconId,
        "shortDescription": shortDescription,
        "longDescription": longDescription,
      };
}

class Media {
  Media({
    this.photos,
    this.videos,
    this.previewVideoThumbnail,
    this.cover,
    this.previewVideo,
  });

  List<Thumbnail>? photos;
  List<dynamic>? videos;
  dynamic previewVideoThumbnail;
  Thumbnail? cover;
  dynamic previewVideo;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        photos: json["photos"] == null
            ? null
            : List<Thumbnail>.from(
                json["photos"].map((x) => Thumbnail.fromJson(x))),
        videos: json["videos"] == null
            ? null
            : List<dynamic>.from(json["videos"].map((x) => x)),
        previewVideoThumbnail: json["previewVideoThumbnail"],
        cover: json["cover"] == null
            ? Thumbnail()
            : Thumbnail.fromJson(json["cover"]),
        previewVideo: json["previewVideo"],
      );

  Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos!.map((x) => x.toJson())),
        "videos": List<dynamic>.from(videos!.map((x) => x)),
        "previewVideoThumbnail": previewVideoThumbnail,
        "cover": cover!.toJson(),
        "previewVideo": previewVideo,
      };
}

class Thumbnail {
  Thumbnail({
    this.id,
    this.name,
    this.path,
    this.originalName,
    this.publicUrl,
    this.extension,
    this.sizeInMb,
    this.v,
    this.virtualPath,
  });

  String? id = "";
  String? name = "";
  String? path = "";
  String? originalName = "";
  String? publicUrl = "";
  Extension? extension;
  double? sizeInMb = 0.0;
  int? v = 0;
  String? virtualPath = "";

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        id: json["_id"] == null ? '' : json["_id"],
        name: json["name"],
        path: json["path"],
        originalName: json["originalName"],
        publicUrl: json["publicUrl"],
        // extension: extensionValues.map[json["extension"]],
        sizeInMb: json["sizeInMb"].toDouble(),
        v: json["__v"],
        virtualPath: json["virtualPath"] == null ? null : json["virtualPath"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "path": path,
        "originalName": originalName,
        "publicUrl": publicUrl,
        // "extension": extensionValues.reverse[extension],
        "sizeInMb": sizeInMb,
        "__v": v,
        "virtualPath": virtualPath == null ? null : virtualPath,
      };
}

enum Extension { JPG }

// final extensionValues = EnumValues({".jpg": Extension.JPG});

class BookingDetails {
  BookingDetails({
    this.currency,
    this.productCategories,
  });

  String? currency;
  List<ProductCategory>? productCategories;

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        currency: json["currency"],
        productCategories: List<ProductCategory>.from(
            json["productCategories"].map((x) => ProductCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "productCategories":
            List<dynamic>.from(productCategories!.map((x) => x.toJson())),
      };
}

class ProductCategory {
  ProductCategory({
    this.id,
    this.title,
    this.products,
    this.subProductCategories,
  });

  String? id;
  String? title;
  List<Product>? products;
  List<dynamic>? subProductCategories;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json["_id"],
        title: json["title"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        subProductCategories:
            List<dynamic>.from(json["subProductCategories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "subProductCategories":
            List<dynamic>.from(subProductCategories!.map((x) => x)),
      };
}

class Product {
  Product({
    this.selectAsPriceFrom,
    this.requestRequired,
    this.id,
    this.title,
    this.image,
    this.description,
    this.price,
    this.properties,
    this.additionalServicesDescription,
    this.additionalServices,
  });

  bool? selectAsPriceFrom;
  bool? requestRequired;
  String? id;
  String? title;
  Thumbnail? image;
  String? description;
  Price? price;
  List<dynamic>? properties;
  String? additionalServicesDescription;
  List<dynamic>? additionalServices;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        selectAsPriceFrom: json["selectAsPriceFrom"],
        requestRequired: json["requestRequired"],
        id: json["_id"],
        title: json["title"],
        image: json["image"] == null
            ? Thumbnail()
            : Thumbnail.fromJson(json["image"]),
        description: json["description"],
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        properties: json["properties"] == null
            ? null
            : List<dynamic>.from(json["properties"].map((x) => x)),
        additionalServicesDescription: json["additionalServicesDescription"],
        additionalServices: json["additionalServices"] == null
            ? null
            : List<dynamic>.from(json["additionalServices"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "selectAsPriceFrom": selectAsPriceFrom,
        "requestRequired": requestRequired,
        "_id": id,
        "title": title,
        "image": image!.toJson(),
        "description": description,
        "price": price!.toJson(),
        "properties": List<dynamic>.from(properties!.map((x) => x)),
        "additionalServicesDescription": additionalServicesDescription,
        "additionalServices":
            List<dynamic>.from(additionalServices!.map((x) => x)),
      };
}

class Price {
  Price({
    this.numberDecimal,
  });

  String? numberDecimal;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        numberDecimal: json["\u0024numberDecimal"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024numberDecimal": numberDecimal,
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class Location {
  Location({
    this.city,
    this.country,
    this.housenumber,
    this.state,
    this.street,
    this.zipcode,
    this.lat,
    this.lon,
  });

  String? city;
  String? country;
  String? housenumber;
  String? state;
  String? street;
  int? zipcode;
  String? lat;
  String? lon;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        city: json["city"],
        country: json["country"],
        housenumber: json["housenumber"],
        state: json["state"],
        street: json["street"],
        zipcode: json["zipcode"],
        lat: json["lat"] == null ? null : json["lat"],
        lon: json["lon"] == null ? null : json["lon"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "housenumber": housenumber,
        "state": state,
        "street": street,
        "zipcode": zipcode,
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
      };
}

class OpeningHours {
  OpeningHours({
    this.timezone,
    this.regularOpeningHours,
    this.additionalOpeningHours,
    this.specialOpeningHours,
    this.seasonalOpeningHours,
  });

  int? timezone;
  List<RegularOpeningHour>? regularOpeningHours;
  List<dynamic>? additionalOpeningHours;
  List<dynamic>? specialOpeningHours;
  List<dynamic>? seasonalOpeningHours;

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        timezone: json["timezone"],
        regularOpeningHours: List<RegularOpeningHour>.from(
            json["regularOpeningHours"]
                .map((x) => RegularOpeningHour.fromJson(x))),
        additionalOpeningHours:
            List<dynamic>.from(json["additionalOpeningHours"].map((x) => x)),
        specialOpeningHours:
            List<dynamic>.from(json["specialOpeningHours"].map((x) => x)),
        seasonalOpeningHours:
            List<dynamic>.from(json["seasonalOpeningHours"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "timezone": timezone,
        "regularOpeningHours":
            List<dynamic>.from(regularOpeningHours!.map((x) => x.toJson())),
        "additionalOpeningHours":
            List<dynamic>.from(additionalOpeningHours!.map((x) => x)),
        "specialOpeningHours":
            List<dynamic>.from(specialOpeningHours!.map((x) => x)),
        "seasonalOpeningHours":
            List<dynamic>.from(seasonalOpeningHours!.map((x) => x)),
      };
}

class RegularOpeningHour {
  RegularOpeningHour({
    this.id,
    this.dayOfWeek,
    this.openingHours,
    this.open,
  });

  String? id;
  int? dayOfWeek;
  List<OpeningHour>? openingHours;
  bool? open;

  factory RegularOpeningHour.fromJson(Map<String, dynamic> json) =>
      RegularOpeningHour(
        id: json["_id"],
        dayOfWeek: json["dayOfWeek"],
        openingHours: List<OpeningHour>.from(
            json["openingHours"].map((x) => OpeningHour.fromJson(x))),
        open: json["open"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dayOfWeek": dayOfWeek,
        "openingHours": List<dynamic>.from(openingHours!.map((x) => x.toJson())),
        "open": open,
      };
}

class OpeningHour {
  OpeningHour({
    this.id,
    this.start,
    this.end,
  });

  String? id;
  String? start;
  String? end;

  factory OpeningHour.fromJson(Map<String, dynamic> json) => OpeningHour(
        id: json["_id"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "start": start,
        "end": end,
      };
}

class Vendor {
  Vendor({
    this.id,
    this.users,
    this.name,
    this.email,
    this.telephone,
    this.location,
    this.contacts,
    this.createdAt,
    this.updatedAt,
    this.internalCode,
    this.v,
  });

  String? id;
  List<String>? users;
  String? name;
  String? email;
  String? telephone;
  Location? location;
  List<dynamic>? contacts;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? internalCode;
  int? v;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["_id"],
        users: List<String>.from(json["users"].map((x) => x)),
        name: json["name"],
        email: json["email"],
        telephone: json["telephone"],
        location: Location.fromJson(json["location"]),
        contacts: List<dynamic>.from(json["contacts"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        internalCode: json["internalCode"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "users": List<dynamic>.from(users!.map((x) => x)),
        "name": name,
        "email": email,
        "telephone": telephone,
        "location": location!.toJson(),
        "contacts": List<dynamic>.from(contacts!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "internalCode": internalCode,
        "__v": v,
      };
}

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }

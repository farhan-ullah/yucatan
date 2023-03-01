import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/generated/json/base/json_filed.dart';
import 'package:yucatan/models/file_model.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 30)
class ActivityModel with JsonConvert<ActivityModel> {
  @HiveField(0)
  ActivityModelLocation? location;
  int? reviewCount;
  double? reviewAverageRating;
  double? priceFrom;
  @JSONField(name: "_id")
  String? sId;
  @HiveField(1)
  String? title;
  FileModel? thumbnail;
  String? createdAt;
  String? updatedAt;
  @JSONField(name: "__v")
  int? iV;

  ActivityModelOpeningHours? openingHours;
  ActivityBookingDetails? bookingDetails;
  List<ActivityCategory>? categories;
  List<String>? tags;
  @HiveField(2)
  String? description;
  @HiveField(3)
  ActivityModelActivityDetails? activityDetails;
  int? bookings;
  ActivityVendor? vendor;
  String? privacy;
}

class ActivityVendor with JsonConvert<ActivityVendor> {
  @JSONField(name: "_id")
  String? id;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;
  ActivityModelLocation? location;
}

class ActivityCategory with JsonConvert<ActivityCategory> {
  @JSONField(name: "_id")
  String? id;
  String? name;
}

class ActivityPersonGroup with JsonConvert<ActivityPersonGroup> {
  String? name;
  String? info;
}

class ActivityBookingDetails with JsonConvert<ActivityBookingDetails> {
  String? currency;
  ActivityBookingConcurrent? concurrentBookings;
  List<ProductCategory>? productCategories;
}

class ProductCategory {
  String? id;
  String? title;
  List<Product>? products;
  List<ProductSubCategory>? productSubCategories;
  int? quota;

  ProductCategory({
    this.id,
    this.title,
    this.products,
    this.productSubCategories,
    this.quota,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['_id'],
      title: json['title'],
      products: json['products'] != null
          ? json['products']
              .map<Product>(
                (value) => Product.fromJson(value),
              )
              .toList()
          : null,
      productSubCategories: json['subProductCategories'] != null
          ? json['subProductCategories']
              .map<ProductSubCategory>(
                (value) => ProductSubCategory.fromJson(value),
              )
              .toList()
          : null,
      quota: json['quota'],
    );
  }
}

class ProductSubCategory {
  String? id;
  String? title;
  FileModel? image;
  double? priceFrom;
  List<Product>? products;
  int? quota;

  ProductSubCategory({
    this.id,
    this.title,
    this.image,
    this.products,
    this.priceFrom,
    this.quota,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: json['_id'],
      title: json['title'],
      image: json['image'] != null ? FileModel.fromJson(json['image']) : null,
      priceFrom: json['priceFrom'] != null
          ? double.parse(json['priceFrom'].toString())
          : 0.0,
      products: json['products'] != null
          ? json['products']
              .map<Product>(
                (value) => Product.fromJson(value),
              )
              .toList()
          : null,
      quota: json['quota'],
    );
  }
}

class Product {
  String? id;
  String? title;
  FileModel? image;
  String? description;
  double? price;
  List<ProductProperty>? properties;
  String? additionalServicesDescription;
  List<ProductAdditionalService>? additionalServices;
  bool? requestRequired;
  ProductTimeSlots? timeSlots;
  String? subtitle;

  Product({
    this.id,
    this.title,
    this.image,
    this.description,
    this.price,
    this.properties,
    this.additionalServicesDescription,
    this.additionalServices,
    this.requestRequired,
    this.timeSlots,
    this.subtitle,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      image: json['image'] != null ? FileModel.fromJson(json['image']) : null,
      description: json['description'],
      price: double.parse(json['price']['\$numberDecimal'].toString()),
      properties: json['properties'] != null
          ? json['properties']
              .map<ProductProperty>(
                (value) => ProductProperty.fromJson(value),
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
      requestRequired: json['requestRequired'],
      timeSlots: json['availableTimeSlots'] != null
          ? ProductTimeSlots.fromJson(json['availableTimeSlots'])
          : null,
      subtitle: json['subtitle'],
    );
  }
}

class ProductAdditionalService {
  String? id;
  String? title;
  FileModel? image;
  String? description;
  double? price;
  List<ProductProperty>? properties;

  ProductAdditionalService({
    this.id,
    this.title,
    this.image,
    this.description,
    this.price,
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
              .map<ProductProperty>(
                (value) => ProductProperty.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class ProductProperty {
  String? id;
  bool? isRequired;
  String? title;
  String? info;
  ProductPropertyType? type;
  List<ProductPropertyDropDownValue>? dropdownValues;

  ProductProperty({
    this.id,
    this.isRequired,
    this.title,
    this.info,
    this.type,
    this.dropdownValues,
  });

  factory ProductProperty.fromJson(Map<String, dynamic> json) {
    return ProductProperty(
      id: json['_id'],
      isRequired: json['required'],
      title: json['title'],
      info: json['info'],
      type: json['type'] == "DROPDOWN"
          ? ProductPropertyType.DROPDOWN
          : json['type'] == "TEXT"
              ? ProductPropertyType.TEXT
              : json['type'] == "NUMBER"
                  ? ProductPropertyType.NUMBER
                  : null,
      dropdownValues: json['dropdownValues'] != null
          ? json['dropdownValues']
              .map<ProductPropertyDropDownValue>(
                (value) => ProductPropertyDropDownValue.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

enum ProductPropertyType {
  DROPDOWN,
  TEXT,
  NUMBER,
}

class ProductPropertyDropDownValue {
  String? id;
  String? text;
  String? value;

  ProductPropertyDropDownValue({
    this.id,
    this.text,
    this.value,
  });

  factory ProductPropertyDropDownValue.fromJson(Map<String, dynamic> json) {
    return ProductPropertyDropDownValue(
      id: json['_id'],
      text: json['text'],
      value: json['value'],
    );
  }
}

class ProductTimeSlots {
  bool? hasTimeSlots;
  List<ProductTimeSlotsRegular>? regular;
  List<ProductTimeSlotsSpecial>? special;
  int? dailyQuota;
  List<ProductTimeSlotsQuotaAvailability>? quotaAvailability;

  ProductTimeSlots({
    this.hasTimeSlots,
    this.regular,
    this.special,
    this.dailyQuota,
    this.quotaAvailability,
  });

  factory ProductTimeSlots.fromJson(Map<String, dynamic> json) {
    return ProductTimeSlots(
      hasTimeSlots: json['hasTimeSlots'],
      regular: json['regular'] != null
          ? json['regular']
              .map<ProductTimeSlotsRegular>(
                (value) => ProductTimeSlotsRegular.fromJson(value),
              )
              .toList()
          : null,
      special: json['special'] != null
          ? json['special']
              .map<ProductTimeSlotsSpecial>(
                (value) => ProductTimeSlotsSpecial.fromJson(value),
              )
              .toList()
          : null,
      dailyQuota: json['dailyQuota'],
      quotaAvailability: json['quotaAvailability'] != null
          ? json['quotaAvailability']
              .map<ProductTimeSlotsQuotaAvailability>(
                (value) => ProductTimeSlotsQuotaAvailability.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class ProductTimeSlotsRegular {
  String? id;
  ProductTImeSlotsRegularIntervalType? intervalType;
  int? intervalRepeat;
  List<ProductTimeSlotsRegularDay>? days;
  DateTime? startDate;
  DateTime? endDate;

  ProductTimeSlotsRegular({
    this.id,
    this.intervalType,
    this.intervalRepeat,
    this.days,
    this.startDate,
    this.endDate,
  });

  factory ProductTimeSlotsRegular.fromJson(Map<String, dynamic> json) {
    return ProductTimeSlotsRegular(
      id: json['_id'],
      intervalType: ProductTImeSlotsRegularIntervalType.values.firstWhere(
        (e) =>
            e.toString().split(".")[1].toLowerCase() ==
            json['intervalType'].toString().toLowerCase(),
        // orElse: () => null,
      ),
      intervalRepeat: json['intervalRepeat'],
      days: json['days'] != null
          ? json['days']
              .map<ProductTimeSlotsRegularDay>(
                (value) => ProductTimeSlotsRegularDay.fromJson(value),
              )
              .toList()
          : null,
      startDate: DateTime.tryParse(json['startDate']),
      endDate: DateTime.tryParse(json['endDate']),
    );
  }
}

enum ProductTImeSlotsRegularIntervalType {
  WEEK,
  MONTH,
}

class ProductTimeSlotsRegularDay {
  String? id;
  int? day;
  int? quota;
  List<ProductTimeSlotsDayHour>? hours;

  ProductTimeSlotsRegularDay({
    this.id,
    this.day,
    this.quota,
    this.hours,
  });

  factory ProductTimeSlotsRegularDay.fromJson(Map<String, dynamic> json) {
    return ProductTimeSlotsRegularDay(
      id: json['_id'],
      day: json['day'],
      quota: json['quota'],
      hours: json['hours'] != null
          ? json['hours']
              .map<ProductTimeSlotsDayHour>(
                (value) => ProductTimeSlotsDayHour.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class ProductTimeSlotsDayHour {
  String? id;
  String? time;
  int? quota;

  ProductTimeSlotsDayHour({
    this.id,
    this.time,
    this.quota,
  });

  factory ProductTimeSlotsDayHour.fromJson(Map<String, dynamic> json) {
    return ProductTimeSlotsDayHour(
      id: json['_id'],
      time: json['time'],
      quota: json['quota'],
    );
  }
}

class ProductTimeSlotsSpecial {
  String? id;
  DateTime? date;
  int? quota;
  List<ProductTimeSlotsDayHour>? hours;

  ProductTimeSlotsSpecial({
    this.id,
    this.date,
    this.quota,
    this.hours,
  });

  factory ProductTimeSlotsSpecial.fromJson(Map<String, dynamic> json) {
    return ProductTimeSlotsSpecial(
      id: json['_id'],
      date: DateTime.tryParse(json['date']),
      quota: json['quota'],
      hours: json['hours'] != null
          ? json['hours']
              .map<ProductTimeSlotsDayHour>(
                (value) => ProductTimeSlotsDayHour.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class ProductTimeSlotsQuotaAvailability {
  String? id;
  DateTime? date;
  int? available;

  ProductTimeSlotsQuotaAvailability({
    this.id,
    this.date,
    this.available,
  });

  factory ProductTimeSlotsQuotaAvailability.fromJson(
      Map<String, dynamic> json) {
    return ProductTimeSlotsQuotaAvailability(
      id: json['_id'],
      date: DateTime.tryParse(json['date']),
      available: json['available'],
    );
  }
}

class ActivityBookingConcurrent with JsonConvert<ActivityBookingConcurrent> {
  int? concurrent;
  int? hourly;
  int? daily;
}

@HiveType(typeId: 20)
class ActivityModelLocation with JsonConvert<ActivityModelLocation> {
  @HiveField(0)
  String? street;
  @HiveField(1)
  String? housenumber;
  @HiveField(2)
  int? zipcode;
  @HiveField(3)
  String? city;
  @HiveField(4)
  String? state;
  @HiveField(5)
  String? country;
  @HiveField(6)
  String? lat;
  @HiveField(7)
  String? lon;
}

class ActivityModelOpeningHours {
  int? timezone;
  List<RegularOpeningHours>? regularOpeningHours;
  List<AdditionalOpeningHours>? additionalOpeningHours;
  List<SeasonalOpeningHours>? seasonalOpeningHours;
  List<SpecialOpeningHours>? specialOpeningHours;

  ActivityModelOpeningHours({
    this.timezone,
    this.regularOpeningHours,
    this.additionalOpeningHours,
    this.seasonalOpeningHours,
    this.specialOpeningHours,
  });

  factory ActivityModelOpeningHours.fromJson(Map<String, dynamic> json) {
    return ActivityModelOpeningHours(
      timezone: json['timezone'],
      regularOpeningHours: json['regularOpeningHours'] != null
          ? json['regularOpeningHours']
              .map<RegularOpeningHours>(
                (value) => RegularOpeningHours.fromJson(value),
              )
              .toList()
          : null,
      additionalOpeningHours: json['additionalOpeningHours'] != null
          ? json['additionalOpeningHours']
              .map<AdditionalOpeningHours>(
                (value) => AdditionalOpeningHours.fromJson(value),
              )
              .toList()
          : null,
      seasonalOpeningHours: json['seasonalOpeningHours'] != null
          ? json['seasonalOpeningHours']
              .map<SeasonalOpeningHours>(
                (value) => SeasonalOpeningHours.fromJson(value),
              )
              .toList()
          : null,
      specialOpeningHours: json['specialOpeningHours'] != null
          ? json['specialOpeningHours']
              .map<SpecialOpeningHours>(
                (value) => SpecialOpeningHours.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class RegularOpeningHours {
  String? id;
  int? dayOfWeek;
  bool? open;
  List<OpeningHoursItem>? openingHours;

  RegularOpeningHours({
    this.id,
    this.dayOfWeek,
    this.open,
    this.openingHours,
  });

  factory RegularOpeningHours.fromJson(Map<String, dynamic> json) {
    return RegularOpeningHours(
      id: json['id'],
      dayOfWeek: json['dayOfWeek'],
      open: json['open'],
      openingHours: json['openingHours'] != null
          ? json['openingHours']
              .map<OpeningHoursItem>(
                (value) => OpeningHoursItem.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class AdditionalOpeningHours {
  String? id;
  String? title;
  List<OpeningHoursDay>? openingHourDays;

  AdditionalOpeningHours({this.id, this.title, this.openingHourDays});

  factory AdditionalOpeningHours.fromJson(Map<String, dynamic> json) {
    return AdditionalOpeningHours(
      id: json['id'],
      title: json['title'],
      openingHourDays: json['days'] != null
          ? json['days']
              .map<OpeningHoursDay>(
                (value) => OpeningHoursDay.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class SeasonalOpeningHours {
  String? id;
  String? title;
  List<SeasonalOpeningHoursPeriod>? periods;
  List<OpeningHoursDay>? openingHourDays;

  SeasonalOpeningHours({
    this.id,
    this.title,
    this.periods,
    this.openingHourDays,
  });

  factory SeasonalOpeningHours.fromJson(Map<String, dynamic> json) {
    return SeasonalOpeningHours(
      id: json['id'],
      title: json['title'],
      periods: json['periods'] != null
          ? json['periods']
              .map<SeasonalOpeningHoursPeriod>(
                (value) => SeasonalOpeningHoursPeriod.fromJson(value),
              )
              .toList()
          : null,
      openingHourDays: json['days'] != null
          ? json['days']
              .map<OpeningHoursDay>(
                (value) => OpeningHoursDay.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class SeasonalOpeningHoursPeriod {
  String? id;
  DateTime? startDate;
  DateTime? endDate;

  SeasonalOpeningHoursPeriod({
    this.id,
    this.startDate,
    this.endDate,
  });

  factory SeasonalOpeningHoursPeriod.fromJson(Map<String, dynamic> json) {
    return SeasonalOpeningHoursPeriod(
      id: json['id'],
      startDate: DateTime.tryParse(json['startDate']),
      endDate: DateTime.tryParse(json['endDate']),
    );
  }
}

class SpecialOpeningHours {
  String? id;
  String? title;
  DateTime? date;
  bool? open;
  List<OpeningHoursItem>? openingHours;

  SpecialOpeningHours({
    this.id,
    this.title,
    this.date,
    this.open,
    this.openingHours,
  });

  factory SpecialOpeningHours.fromJson(Map<String, dynamic> json) {
    return SpecialOpeningHours(
      id: json['id'],
      title: json['title'],
      date: DateTime.tryParse(json['date']),
      open: json['open'],
      openingHours: json['openingHours'] != null
          ? json['openingHours']
              .map<OpeningHoursItem>(
                (value) => OpeningHoursItem.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class OpeningHoursDay {
  String? id;
  int? dayOfWeek;
  bool? open;
  List<OpeningHoursItem>? openingHours;

  OpeningHoursDay({
    this.id,
    this.dayOfWeek,
    this.open,
    this.openingHours,
  });

  factory OpeningHoursDay.fromJson(Map<String, dynamic> json) {
    return OpeningHoursDay(
      id: json['id'],
      dayOfWeek: json['dayOfWeek'],
      open: json['open'],
      openingHours: json['openingHours'] != null
          ? json['openingHours']
              .map<OpeningHoursItem>(
                (value) => OpeningHoursItem.fromJson(value),
              )
              .toList()
          : null,
    );
  }
}

class OpeningHoursItem {
  String? id;
  String? start;
  String? end;

  OpeningHoursItem({
    this.id,
    this.start,
    this.end,
  });

  factory OpeningHoursItem.fromJson(Map<String, dynamic> json) {
    return OpeningHoursItem(
      id: json['_id'],
      start: json['start'],
      end: json['end'],
    );
  }
}

@HiveType(typeId: 21)
class ActivityModelActivityDetails
    with JsonConvert<ActivityModelActivityDetails> {
  ActivityModelActivityDetailsMedia? media;
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? shortDescription;
  @HiveField(2)
  String? longDescription;
  @HiveField(3)
  String? packageIncluded;
  @HiveField(4)
  String? packageNotIncluded;
  @HiveField(5)
  int? cancellation;

  ActivityDetailsCustomFields? customFields;
  List<ActivityModelActivityDetailsReview>? reviews;
  List<ActivityDetailDescriptionItemModel>? descriptionItems;
}

class ActivityDetailsCustomFields
    with JsonConvert<ActivityDetailsCustomFields> {
  List<ActivityDetailsCustomFieldStandard>? standard;
  List<ActivityDetailsCustomFieldSelect>? select;
}

class ActivityDetailsCustomFieldStandard
    with JsonConvert<ActivityDetailsCustomFieldStandard> {
  String? name;
  String? info;
  String? type;
  bool? required;
}

class ActivityDetailsCustomFieldSelect
    with JsonConvert<ActivityDetailsCustomFieldSelect> {
  String? name;
  String? info;
  bool? required;
  bool? multiselect;
  List<String>? options;
}

class ActivityModelActivityDetailsMedia
    with JsonConvert<ActivityModelActivityDetailsMedia> {
  List<FileModel>? photos;
  List<FileModel>? videos;
  FileModel? cover;
  FileModel? previewVideo;
  FileModel? previewVideoThumbnail;
}

class ActivityModelActivityDetailsReview
    with JsonConvert<ActivityModelActivityDetailsReview> {
  @JSONField(name: "_id")
  String? sId;
  String? user;
  UserLoginModel? userModel;
  int? rating;
  String? description;
  String? createdAt;
  String? updatedAt;
}

class ActivityDetailDescriptionItemModel
    with JsonConvert<ActivityDetailDescriptionItemModel> {
  int? iconId;
  String? iconName;
  String? shortDescription;
  String? longDescription;
}

class Location {
  Location({
    this.street,
    this.housenumber,
    this.zipcode,
    this.city,
    this.state,
    this.country,
    this.lat,
    this.lon,
  });

  String? street;
  String? housenumber;
  int? zipcode;
  String? city;
  String? state;
  String? country;
  String? lat;
  String? lon;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        street: json["street"],
        housenumber: json["housenumber"],
        zipcode: json["zipcode"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        lat: json["lat"],
        lon: json["lon"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "housenumber": housenumber,
        "zipcode": zipcode,
        "city": city,
        "state": state,
        "country": country,
        "lat": lat,
        "lon": lon,
      };
}

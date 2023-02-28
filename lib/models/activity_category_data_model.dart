import 'activity_model.dart';
import 'file_model.dart';

class ActivityCategoryDataModel {
  String? id;
  Location? location;
  int? reviewCount;
  double? reviewAverageRating;
  double? priceFrom;
  String? title;
  FileModel? thumbnail;

  ActivityCategoryDataModel({
    this.id,
    this.location,
    this.reviewCount,
    this.reviewAverageRating,
    this.priceFrom,
    this.title,
    this.thumbnail,
  });

  factory ActivityCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return ActivityCategoryDataModel(
      id: json["_id"],
      location:
          json["location"] != null ? Location.fromJson(json["location"]) : null,
      reviewCount: int.tryParse(json["reviewCount"].toString()),
      reviewAverageRating:
          double.tryParse(json["reviewAverageRating"].toString()),
      priceFrom: double.tryParse(json["priceFrom"].toString()),
      title: json["title"],
      thumbnail: json["thumbnail"] != null
          ? FileModel.fromJson(json["thumbnail"])
          : null,
    );
  }
}

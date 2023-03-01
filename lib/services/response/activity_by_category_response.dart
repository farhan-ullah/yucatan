import 'dart:convert';
import 'package:yucatan/models/activity_category_data_model.dart';

ActivityByCategoryResponse activityByCategoryResponseFromJson(String str) =>
    ActivityByCategoryResponse.fromJson(json.decode(str));

class ActivityByCategoryResponse {
  ActivityByCategoryResponse({
    this.status,
    this.data,
  });

  int? status;
  List<ActivityCategoryDataModel>? data;

  factory ActivityByCategoryResponse.fromJson(Map<String, dynamic> json) =>
      ActivityByCategoryResponse(
        status: json["status"],
        data: List<ActivityCategoryDataModel>.from(
            json["data"].map((x) => ActivityCategoryDataModel.fromJson(x))),
      );
}

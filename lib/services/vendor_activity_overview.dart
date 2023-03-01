import 'dart:convert';

import 'package:yucatan/services/response/vendor_activty_object.dart';
import 'package:yucatan/services/response/vendor_activty_overview_response.dart';
import 'base_service.dart';

class VendorActivityOverviewService extends BaseService {
  VendorActivityOverviewService._()
      : super(BaseService.defaultURL + '/activities');

  static Future<VendorActivtyOverviewResponse?>
      getVendorActivityOverview() async {
    var httpData =
        (await new VendorActivityOverviewService._().get('/vendoroverview'))
            ?.body;
    if (httpData != null) {
      return new VendorActivtyOverviewResponse.fromJson(json.decode(httpData));
    } else
      return null;
  }

  static Future<VendorActivtyObject?> updateActivityStatus(
      VendorActivityOverviewData activityOverviewData) async {
    String publishingStatus;
    if (activityOverviewData.publishingStatus == "Active") {
      publishingStatus = "Inactive";
    } else {
      publishingStatus = "Active";
    }
    dynamic body = json.encode({
      'publishingStatus': publishingStatus,
    });

    var httpData = (await new VendorActivityOverviewService._().post(
        '/${activityOverviewData.id}/status',
        body /*json.encode(activityOverviewData.toJson())*/));

    if (httpData != null) {
      if (httpData.statusCode == 200) {
        return new VendorActivtyObject.fromJson(json.decode(httpData.body));
      } else {
        ErrorResponse errorResponse =
            new ErrorResponse.fromJson(json.decode(httpData.body));
        VendorActivtyObject vendorActivtyObject = VendorActivtyObject();
        vendorActivtyObject.statusCode = httpData.statusCode;
        vendorActivtyObject.errorResponse = errorResponse;
        return vendorActivtyObject;
      }
    } else
      return null;
  }
}

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  ErrorResponse({
    this.errors,
  });

  Errors? errors;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        errors: Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "errors": errors!.toJson(),
      };
}

class Errors {
  Errors({
    this.message,
  });

  String? message;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

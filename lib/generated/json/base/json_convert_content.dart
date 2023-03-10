// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

import 'package:yucatan/generated/json/activity_model_helper.dart';
import 'package:yucatan/generated/json/activity_multi_response_helper.dart';
import 'package:yucatan/generated/json/activity_single_response_helper.dart';
import 'package:yucatan/generated/json/api_error_helper.dart';
// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:yucatan/generated/json/number_decimal_helper.dart';
import 'package:yucatan/generated/json/user_model_helper.dart';
import 'package:yucatan/generated/json/user_multi_response_entity_helper.dart';
import 'package:yucatan/generated/json/user_single_response_entity_helper.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/user_model.dart';
import 'package:yucatan/services/response/activity_multi_response.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/booking_multi_response_entity.dart';
import 'package:yucatan/services/response/booking_single_response_entity.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_multi_response_entity.dart';
import 'package:yucatan/services/response/user_single_response_entity.dart';

import '../booking_multi_response_entity_helper.dart';
import '../booking_single_response_entity_helper.dart';
import '../user_login_response_helper.dart';

class JsonConvert<T> {
  T fromJson(Map<String, dynamic> json) {
    return _getFromJson<T>(runtimeType, this, json);
  }

  Map<String, dynamic> toJson() {
    return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {
      case ActivityMultiResponse:
        return activityMultiResponseFromJson(
            data as ActivityMultiResponse, json) as T;
      case BookingSingleResponseEntity:
        return bookingSingleResponseEntityFromJson(
            data as BookingSingleResponseEntity, json) as T;
      case BookingMultiResponseEntity:
        return bookingMultiResponseEntityFromJson(
            data as BookingMultiResponseEntity, json) as T;
      case UserModel:
        return userModelFromJson(data as UserModel, json) as T;
      case ApiError:
        return apiErrorFromJson(data as ApiError, json) as T;
      case ActivitySingleResponse:
        return activitySingleResponseFromJson(
            data as ActivitySingleResponse, json) as T;
      case UserLoginResponse:
        return userLoginResponseFromJson(data as UserLoginResponse, json) as T;
      case UserLoginResponseData:
        return userLoginResponseDataFromJson(
            data as UserLoginResponseData, json) as T;
      case UserLoginModel:
        return userLoginModelFromJson(data as UserLoginModel, json) as T;
      case UserMultiResponseEntity:
        return userMultiResponseEntityFromJson(
            data as UserMultiResponseEntity, json) as T;
      case ActivityModel:
        return activityModelFromJson(data as ActivityModel, json) as T;
      case ActivityBookingDetails:
        return activityBookingDetailsFromJson(
            data as ActivityBookingDetails, json) as T;
      case ActivityBookingConcurrent:
        return activityBookingConcurrentFromJson(
            data as ActivityBookingConcurrent, json) as T;
      case ActivityModelLocation:
        return activityModelLocationFromJson(
            data as ActivityModelLocation, json) as T;
      case ActivityModelActivityDetails:
        return activityModelActivityDetailsFromJson(
            data as ActivityModelActivityDetails, json) as T;
      case ActivityDetailsCustomFields:
        return activityDetailsCustomFieldsFromJson(
            data as ActivityDetailsCustomFields, json) as T;
      case ActivityDetailsCustomFieldStandard:
        return activityDetailsCustomFieldStandardFromJson(
            data as ActivityDetailsCustomFieldStandard, json) as T;
      case ActivityDetailsCustomFieldSelect:
        return activityDetailsCustomFieldSelectFromJson(
            data as ActivityDetailsCustomFieldSelect, json) as T;
      case ActivityModelActivityDetailsMedia:
        return activityModelActivityDetailsMediaFromJson(
            data as ActivityModelActivityDetailsMedia, json) as T;
      case ActivityModelActivityDetailsReview:
        return activityModelActivityDetailsReviewFromJson(
            data as ActivityModelActivityDetailsReview, json) as T;
      case UserSingleResponseEntity:
        return userSingleResponseEntityFromJson(
            data as UserSingleResponseEntity, json) as T;
      case ActivityCategory:
        return activityModelActivityCategoryFromJson(
            data as ActivityCategory, json) as T;
      case ActivityDetailDescriptionItemModel:
        return activityModelActivityDetailDescriptionItemModelFromJson(
            data as ActivityDetailDescriptionItemModel, json) as T;
      case ActivityVendor:
        return activityVendorFromJson(data as ActivityVendor, json) as T;
      case NumberDecimal:
        numberDecimalFromJson(data as NumberDecimal, json) as T;
    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
    switch (type) {
      case ActivityMultiResponse:
        return activityMultiResponseToJson(data as ActivityMultiResponse);
      case UserModel:
        return userModelToJson(data as UserModel);
      case ApiError:
        return apiErrorToJson(data as ApiError);
      case ActivitySingleResponse:
        return activitySingleResponseToJson(data as ActivitySingleResponse);
      case UserLoginResponse:
        return userLoginResponseToJson(data as UserLoginResponse);
      case UserLoginResponseData:
        return userLoginResponseDataToJson(data as UserLoginResponseData);
      case UserLoginModel:
        return userLoginModelToJson(data as UserLoginModel);
      case UserMultiResponseEntity:
        return userMultiResponseEntityToJson(data as UserMultiResponseEntity);
      case ActivityModel:
        return activityModelToJson(data as ActivityModel);

      case ActivityPersonGroup:
        return activityBookingDetailsToJson(data as ActivityBookingDetails);
      case ActivityBookingConcurrent:
        return activityBookingConcurrentToJson(
            data as ActivityBookingConcurrent);
      case ActivityModelLocation:
        return activityModelLocationToJson(data as ActivityModelLocation);
      case ActivityModelActivityDetails:
        return activityModelActivityDetailsToJson(
            data as ActivityModelActivityDetails);
      case ActivityDetailsCustomFields:
        return activityDetailsCustomFieldsToJson(
            data as ActivityDetailsCustomFields);
      case ActivityDetailsCustomFieldStandard:
        return activityDetailsCustomFieldStandardToJson(
            data as ActivityDetailsCustomFieldStandard);
      case ActivityDetailsCustomFieldSelect:
        return activityDetailsCustomFieldSelectToJson(
            data as ActivityDetailsCustomFieldSelect);
      case ActivityModelActivityDetailsMedia:
        return activityModelActivityDetailsMediaToJson(
            data as ActivityModelActivityDetailsMedia);
      case ActivityModelActivityDetailsReview:
        return activityModelActivityDetailsReviewToJson(
            data as ActivityModelActivityDetailsReview);
      case UserSingleResponseEntity:
        return userSingleResponseEntityToJson(data as UserSingleResponseEntity);
      case ActivityCategory:
        return activityModelActivityCategoryToJson(data as ActivityCategory);
      case ActivityDetailDescriptionItemModel:
        return activityModelActivityDetailDescriptionItemModelToJson(
            data as ActivityDetailDescriptionItemModel);
      case ActivityVendor:
        return activityVendorToJson(data as ActivityVendor);
      case NumberDecimal:
        numberDecimalToJson(data as NumberDecimal);
    }
    return data as T;
  }

  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {
      case 'ActivityMultiResponse':
        return ActivityMultiResponse().fromJson(json);
      case 'BookingSingleResponseEntity':
        return BookingSingleResponseEntity().fromJson(json);
      case 'BookingMultiResponseEntity':
        return BookingMultiResponseEntity().fromJson(json);
      case 'UserModel':
        return UserModel().fromJson(json);
      case 'ApiError':
        return ApiError().fromJson(json);
      case 'ActivitySingleResponse':
        return ActivitySingleResponse().fromJson(json);
      case 'UserLoginResponse':
        return UserLoginResponse().fromJson(json);
      case 'UserLoginResponseData':
        return UserLoginResponseData().fromJson(json);
      case 'UserLoginModel':
        return UserLoginModel().fromJson(json);
      case 'UserMultiResponseEntity':
        return UserMultiResponseEntity().fromJson(json);
      case 'ActivityModel':
        return ActivityModel().fromJson(json);
      case 'ActivityPersonGroup':
        return ActivityPersonGroup().fromJson(json);
      case 'ActivityBookingDetails':
        return ActivityBookingDetails().fromJson(json);
      case 'ActivityBookingConcurrent':
        return ActivityBookingConcurrent().fromJson(json);
      case 'ActivityModelLocation':
        return ActivityModelLocation().fromJson(json);
      case 'ActivityModelActivityDetails':
        return ActivityModelActivityDetails().fromJson(json);
      case 'ActivityDetailsCustomFields':
        return ActivityDetailsCustomFields().fromJson(json);
      case 'ActivityDetailsCustomFieldStandard':
        return ActivityDetailsCustomFieldStandard().fromJson(json);
      case 'ActivityDetailsCustomFieldSelect':
        return ActivityDetailsCustomFieldSelect().fromJson(json);
      case 'ActivityModelActivityDetailsMedia':
        return ActivityModelActivityDetailsMedia().fromJson(json);
      case 'ActivityModelActivityDetailsReview':
        return ActivityModelActivityDetailsReview().fromJson(json);
      case 'UserSingleResponseEntity':
        return UserSingleResponseEntity().fromJson(json);
      case 'ActivityCategory':
        return ActivityCategory().fromJson(json);
      case 'ActivityDetailDescriptionItemModel':
        return ActivityDetailDescriptionItemModel().fromJson(json);
      case 'ActivityVendor':
        return ActivityVendor().fromJson(json);
      case 'NumberDecimal':
        return NumberDecimal().fromJson(json);
    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {
      case 'ActivityMultiResponse':
        return <ActivityMultiResponse>[];
      case 'BookingSingleResponseEntity':
        return <BookingSingleResponseEntity>[];
      case 'BookingMultiResponseEntity':
        return <BookingMultiResponseEntity>[];
      case 'BookingModelNew':
        return <BookingModel>[];
      case 'UserModel':
        return <UserModel>[];
      case 'ApiError':
        return <ApiError>[];
      case 'ActivitySingleResponse':
        return <ActivitySingleResponse>[];
      case 'UserLoginResponse':
        return <UserLoginResponse>[];
      case 'UserLoginResponseData':
        return <UserLoginResponseData>[];
      case 'UserLoginModel':
        return <UserLoginModel>[];
      case 'UserMultiResponseEntity':
        return <UserMultiResponseEntity>[];
      case 'ActivityModel':
        return <ActivityModel>[];
      case 'ActivityPersonGroup':
        return <ActivityPersonGroup>[];
      case 'ActivityBookingDetails':
        return <ActivityBookingDetails>[];
      case 'ActivityBookingConcurrent':
        return <ActivityBookingConcurrent>[];
      case 'ActivityModelLocation':
        return <ActivityModelLocation>[];
      case 'ActivityModelOpeningHours':
        return <ActivityModelOpeningHours>[];
      case 'ActivityModelActivityDetails':
        return <ActivityModelActivityDetails>[];
      case 'ActivityDetailsCustomFields':
        return <ActivityDetailsCustomFields>[];
      case 'ActivityDetailsCustomFieldStandard':
        return <ActivityDetailsCustomFieldStandard>[];
      case 'ActivityDetailsCustomFieldSelect':
        return <ActivityDetailsCustomFieldSelect>[];
      case 'ActivityModelActivityDetailsMedia':
        return <ActivityModelActivityDetailsMedia>[];
      case 'ActivityModelActivityDetailsReview':
        return <ActivityModelActivityDetailsReview>[];
      case 'UserSingleResponseEntity':
        return <UserSingleResponseEntity>[];
      case 'ActivityCategory':
        return <ActivityCategory>[];
      case 'ActivityDetailDescriptionItemModel':
        return <ActivityDetailDescriptionItemModel>[];
      case 'ActivityVendor':
        return <ActivityVendor>[];
      case 'NumberDecimal':
        return <NumberDecimal>[];
    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}

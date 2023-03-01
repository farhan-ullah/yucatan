import 'dart:convert';
import 'dart:math';

import 'package:yucatan/models/activity_category_data_model.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/activity_list_screen/components/activity_list_category_view.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/activity_by_category_response.dart';
import 'package:yucatan/services/response/activity_multi_response.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/bool_utils.dart';
import 'package:yucatan/utils/random_activity_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class ActivityService extends BaseService {
  // this class is static only
  ActivityService._()
      : super(
          BaseService.defaultURL + '/activities',
        );


  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// Queries all activities
  static Future<ActivityMultiResponse?> getAll() async {
    var httpData = (await new ActivityService._().get('/active'))?.body;
    if (httpData != null) {
      return new ActivityMultiResponse().fromJson(json.decode(httpData));
    } else
      return null;
  }

  /// Queries an Activity by the given [id]
  /// [id] internal (object-)ID of the activity (ActivityModel.sId)
  static Future<ActivitySingleResponse>? getActivity(String id) async {
    var httpData = (await new ActivityService._().get(id))?.body;

      return new ActivitySingleResponse().fromJson(json.decode(httpData!));

  }

  /// Queries all activities for a category
  static Future<ActivityByCategoryResponse?> getAllForCategory(
      String categoryId, String category) async {
    var httpData =
        (await new ActivityService._().get('/category/$categoryId/active'))
            ?.body;
    if (httpData != null) {
      ActivityByCategoryResponse activityMultiResponse =
          new ActivityByCategoryResponse.fromJson(json.decode(httpData));

      if (shuffelActivitysList) {
        RandomActivityData randomActivityData =
            getRandomNumbersWithoutRepetition(activityMultiResponse.data!.length,
                activityMultiResponse.data!, category);
        activityMultiResponse.data = randomActivityData.activityModelList!;
        RandomActivity.hashMap[category] = randomActivityData.randomNumbers;
      } else {
        if (RandomActivity.hashMap.isNotEmpty) {
          List<int> savedRandomNumbersList = RandomActivity.hashMap[category];
          if (savedRandomNumbersList != null) {
            if (savedRandomNumbersList.length ==
                activityMultiResponse.data!.length) {
              List<ActivityCategoryDataModel> activityList = [];
              for (int i = 0; i < activityMultiResponse.data!.length; i++) {
                activityList
                    .add(activityMultiResponse.data![savedRandomNumbersList[i]]);
              }
              activityMultiResponse.data = activityList;
            }
          }
        }
      }

      return activityMultiResponse;
    } else
      return null;
  }

  static RandomActivityData getRandomNumbersWithoutRepetition(int count,
      List<ActivityCategoryDataModel> activityModelList, String category) {
    Random random = new Random();
    RandomActivityData randomActivityData = RandomActivityData();
    List<int> randomNumbers = [];
    List<ActivityCategoryDataModel> activityList = [];
    for (int i = 0; i < count; i++) {
      int number;
      do {
        number = random.nextInt(count);
      } while (randomNumbers.contains(number));

      activityList.add(activityModelList[number]);
      randomNumbers.add(number);
    }
    randomActivityData.randomNumbers = randomNumbers;
    randomActivityData.activityModelList = activityList;
    return randomActivityData;
  }

  /// Add review to an activity
  static Future<ActivitySingleResponse>? addReview(
      String activityId, ActivityModelActivityDetailsReview review) async {
    AnalyticsService.logAddReview(review.rating!.toDouble());
    var httpData = (await new ActivityService._()
            .post('/$activityId/reviews', json.encode(review.toJson())))
        ?.body;
      return new ActivitySingleResponse().fromJson(json.decode(httpData!));

  }

  /// Add review to an activity
  static Future<ActivitySingleResponse>? editReview(
      String activityId, ActivityModelActivityDetailsReview review) async {
    var httpData = (await new ActivityService._().put(
            '/$activityId/reviews/${review.sId}', json.encode(review.toJson())))
        ?.body;
      return new ActivitySingleResponse().fromJson(json.decode(httpData!));

  }

  /// Get activities by search term
  static Future<ActivityMultiResponse>? getActivitiesBySearchTerm(
      {String? searchTerm, String? date, String? categoryId}) async {
    Map<String, String> queryParams = Map();

    //Log firebase event
    if (kReleaseMode) {
      analytics.logEvent(
        name: 'search',
        parameters: <String, dynamic>{
          'search_term': searchTerm,
          'time': DateTime.now().toIso8601String(),
        },
      );
    }

    if (isNotNullOrEmpty(date!)) {
      queryParams.putIfAbsent('selectedDate', () => date);
    }
    if (isNotNullOrEmpty(categoryId!)) {
      queryParams.putIfAbsent('category', () => categoryId);
    }
    if (isNotNullOrEmpty(searchTerm!)) {
      queryParams.putIfAbsent('searchTerm', () => searchTerm);
    }

    String query = Uri(queryParameters: queryParams).query;

    var httpData = (await new ActivityService._().get('/search?$query'))?.body;

      return new ActivityMultiResponse().fromJson(json.decode(httpData!));

  }

  /// Get autocomplete suggestions
  static Future<List>? getSuggestions({String? query, int? items}) async {
    Map<String, String> queryParams = Map();

    if (isNotNullOrEmpty(query!)) {
      queryParams.putIfAbsent('query', () => query);
    }
    if (items != null) {
      queryParams.putIfAbsent('items', () => items.toString());
    }

    String urlQuery = Uri(queryParameters: queryParams).query;

    var httpData =
        (await new ActivityService._().get('/autocomplete?$urlQuery'))?.body;

      return json.decode(httpData!)['data'].toList();

  }
}

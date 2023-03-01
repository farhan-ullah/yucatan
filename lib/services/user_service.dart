import 'dart:convert';

import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_multi_response_entity.dart';
import 'package:yucatan/services/response/user_single_response_entity.dart';

class UserService extends BaseService {
  // this class is static only
  UserService._() : super(BaseService.defaultURL + '/users');

  /// Queries all users
  static Future<UserMultiResponseEntity?> getAll() async {
    var httpData = (await new UserService._().get(''))?.body;
    if (httpData != null) {
      return new UserMultiResponseEntity().fromJson(json.decode(httpData));
    } else
      return null;
  }

  /// Queries an User by the given [id]
  /// [id] internal ID of the user (UserModel.sId)
  static Future<UserSingleResponseEntity?> getUser(String id) async {
    return _parseSingle((await new UserService._().get(id))!.body);
  }

  /// Creates a new User
  /// [email] User email (distinct)
  /// [password] User password
  /// [passwordConfirmation] must match [password]
  static Future<UserSingleResponseEntity> createUser(UserLoginModel model,
      String password, String passwordConfirmation) async {
    var map = model.toJson();
    map['password'] = password;
    map['passwordConfirmation'] = passwordConfirmation;

    ['_id', 'refreshToken', 'createdAt', 'updatedAt', '__v']
        .forEach((it) => map.remove(it));

    dynamic body = json.encode(map);
    var result = _parseSingle((await new UserService._().post('', body))!.body);

    print('Result After Registration : $result');
    if (result!.status == 200) {
      //Log firebase event
      AnalyticsService.logRegistration(result.data!.sId!, result.data!.email!);
    }

    return result;
  }

  /// Deletes an User by the given [id]
  /// [id] internal ID of the user (UserModel.sId)
  static Future<UserSingleResponseEntity?> deleteUser(String id) async {
    return _parseSingle((await new UserService._().delete(id))!.body);
  }

  //---------------------------------------------

  /// takes the response body and parses it to json
  /// [httpData] HTTP-Response body returned by remote server
  static UserSingleResponseEntity? _parseSingle(String httpData) {
    if (httpData != null) {
      return new UserSingleResponseEntity().fromJson(json.decode(httpData));
    } else
      return null;
  }

  // Get favorite activities by user
  static Future<List<String>?> getFavoriteActivitiesForUser(
      String userId) async {
    var httpData = (await new UserService._().get(userId + '/favorites'))!.body;
    if (httpData != null) {
      List<String> test = List.from(json.decode(httpData)["data"]);
      return test;
    } else
      return null;
  }

  // Delete favorite activity for user
  static Future<UserSingleResponseEntity?> deleteUserFavoriteActivity(
      {String? activityId, String? userId}) async {
    var httpData =
        (await new UserService._().delete(userId! + '/favorites/' + activityId!))!
            .body;
    if (httpData != null) {
      return new UserSingleResponseEntity().fromJson(json.decode(httpData));
    } else
      return null;
  }

  // Add favorite activity for user
  static Future<UserSingleResponseEntity?> addUserFavoriteActivity(
      {String? activityId, String? userId}) async {
    //Log firebase event
    AnalyticsService.logAddToWishlist(activityId!, userId!);

    var body = jsonEncode({
      'activityIds': [activityId]
    });
    var httpData =
        (await new UserService._().post(userId + '/favorites', body))!.body;
    if (httpData != null) {
      return new UserSingleResponseEntity().fromJson(json.decode(httpData));
    } else
      return null;
  }

  // Confirm User
  static Future<UserSingleResponseEntity?> confirmUser(
      {String? email, String? token}) async {
    var httpData = (await new UserService._()
            .get('/confirm?email=' + email! + '&token=' + token!))!
        .body;
    if (httpData != null) {
      return new UserSingleResponseEntity().fromJson(json.decode(httpData));
    } else
      return null;
  }

  // Save FCM token to user
  static Future<UserSingleResponseEntity?> saveFcmToken(
      {String? userId, String? fcmToken}) async {
    var requestBody = jsonEncode({'fcmToken': fcmToken});

    var httpData = (await new UserService._().post(
      '/' + userId! + '/fcmtoken',
      requestBody,
    ))!
        .body;
    if (httpData != null) {
      return new UserSingleResponseEntity().fromJson(json.decode(httpData));
    } else
      return null;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_single_response_entity.dart';
import 'package:yucatan/services/status_service.dart';
import 'package:yucatan/services/user_callback_handler.dart';
import 'package:yucatan/utils/StringUtils.dart' as str;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends BaseService {
  // this class is static only
  UserProvider._() : super(BaseService.defaultURL + '/users');
  static UserLoginModel? _loggedInUser;

  static Future<UserLoginModel> getOfflineUser() {
    return Future.value(_loggedInUser);
  }

  static UserLoginModel getUserSync() {
    return _loggedInUser!;
  }

  static Future<UserLoginModel>? getUser() async {
    if (_loggedInUser == null) {
      var tmpUser = await _readUserInfo();

      _loggedInUser = tmpUser;
      return _loggedInUser!;

      //if(await refreshToken() != null) return null;
      //else return (_loggedInUser = await _readUserInfo());
    } else
      return _loggedInUser!;
  }

  // checks online status and gets user based on it (online => getUser(), offline => _loggedInUser)
  static Future<Future<UserLoginModel?>> getUserChecked() async {
    Future<UserLoginModel>? response;
    try {
      var status = await StatusService.getStatus();
      if (status == null) throw SocketException("Network error");
      response = getUser();
    } on SocketException catch (_) {
      response = getOfflineUser();
    }
    return response!;
  }

  static Future<Future<String?>> getJwtToken() async {
    return await _readJWTToken();
  }

  //---------------------------------------------

  /// returns an [ApiError] if an error occurs, otherwise null
  static Future<ApiError?> login(String email, String password) async {
    dynamic body = json.encode({
      'email': email,
      'password': password,
    });

    var response = await new UserProvider._().post('login', body);

    print('login=${response}');
    if (response!.body != null) {
      // print('login=${response.body}');
      var user = UserLoginResponse().fromJson(json.decode(response.body));
      var result = await _validateLogin(user);
      UserCallbackHandler().userChanged();
      HiveService.updateDatabase();

      if (result == null) {
        //Log firebase event

        await AnalyticsService.setUser(user.data!.user);
      }

      return result;
    } else
      return ApiError().fromJson({'message': 'A network error occurred'});
  }

  /// returns an [ApiError] if an error occurs, otherwise null
  static Future<ApiError?> refreshToken() async {
    var userInfo = await _readUserInfo();

    if (userInfo == null || str.isNotNullOrEmpty(userInfo.refreshToken!)) {
      return ApiError().fromJson(
          {'message': 'Can not refresh jwt token, no stored user info found'});
    }

    dynamic body = json
        .encode({'id': userInfo.sId, 'refreshToken': userInfo.refreshToken});

    var response =
        await new UserProvider._().internalRefreshToken('refresh-token', body);
    if (response?.body != null) {
      return await _validateLogin(
          UserLoginResponse().fromJson(json.decode(response!.body)));
    } else
      return ApiError().fromJson({'message': 'A network error occurred'});
  }

  /// returns an [ApiError] if an error occurs, otherwise null
  static Future<ApiError?> _validateLogin(UserLoginResponse response) async {
    var data = response.data;

    // validate all fields not empty or null
    if (data != null) {
      await _storeAll(data.token!, data.user);
      return null;
    } else
      return response.errors;
  }

  static Future<void> logout() async {
    _loggedInUser = null;
    await AnalyticsService.logout();
    await _deleteAll();
    UserCallbackHandler().userChanged();
  }

  /// Updates the current logged in user with the given model
  /// [model] Model containing fields to update
  /// returns an [ApiError] only if an error occurs, otherwise [null]
  static Future<ApiError?> update(UserLoginModel model) async {
    if (model == null)
      return ApiError().fromJson({'message': 'No model provided'});
    if (_loggedInUser == null)
      return ApiError()
          .fromJson({'message': 'Nobody is logged in, nothing to update'});

    var map = model.toJson();
    dynamic body = json.encode(map);

    var intermediate =
        await new UserProvider._().put('/${_loggedInUser!.sId}', body);

    var result =
        UserSingleResponseEntity().fromJson(json.decode(intermediate!.body));

    if (intermediate.statusCode == 200 && result.data != null) {
      _loggedInUser = result.data;
      _storeUser(result.data!);
      return null; // null == no error
    } else {
      return result.errors;
    }
  }

  //---------------------------------------------

  static const _storageKeyToken = 'jwtToken';
  static const _storageKeyUser = 'userInfo';

  static Future<Future<String?>> _readJWTToken() async {
    return new FlutterSecureStorage().read(key: _storageKeyToken);
  }

  static Future<UserLoginModel?> _readUserInfo() async {
    var data = await new FlutterSecureStorage().read(key: _storageKeyUser);
    if (data == null)
      return null;
    else
      return new UserLoginModel().fromJson(json.decode(data));
  }

  static Future<void> _storeUser(UserLoginModel user) async {
    var storage = new FlutterSecureStorage();
    await storage.write(
        key: _storageKeyUser, value: json.encode(user.toJson()));
  }

  static Future<void> _storeAll(String jwtToken, UserLoginModel user) async {
    var storage = new FlutterSecureStorage();
    await storage.write(key: _storageKeyToken, value: jwtToken);
    await _storeUser(user);
  }

  static const _storageKeynotification = 'notificationData';

  static Future<void> _deleteAll() async {
    var storage = new FlutterSecureStorage();
    await storage.delete(key: _storageKeyToken);
    await storage.delete(key: _storageKeyUser);
    await storage.delete(key: _storageKeynotification);
  }
}

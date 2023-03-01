import 'dart:collection';
import 'dart:convert';

import 'package:yucatan/models/notification_model.dart';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/user_notification_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'notifications_to_read_response.dart';

class UserNotificationService extends BaseService {
  // this class is static only
  UserNotificationService._()
      : super(BaseService.defaultURL + '/notifications');

  static Future<UserNotificationResponse>? getNotificationsForUser() async {
    var httpData = (await new UserNotificationService._().get('/user/'))!.body;

      return new UserNotificationResponse.fromJson(json.decode(httpData));

  }

  /// Set a notification to read after confirming user matches
  static Future<NotificationsToReadResponse?> setNotificationsToRead(
      String notificationId) async {
    var httpData = (await new UserNotificationService._()
        .post('/$notificationId/setToRead', null));
    //print(httpData.body);
    if (httpData!.body != null) {
      var result =
          NotificationsToReadResponse.fromJson(json.decode(httpData.body));
      return result;
    } else
      return null;
  }

  static const _storageKeynotification = 'notificationData';

  static Future<HashMap>
      getSavedNotificationReadFlagData() async {
    HashMap hashMap = new HashMap<String, SavedNotificationData>();
    String? value =
        await new FlutterSecureStorage().read(key: _storageKeynotification);
    List<SavedNotificationData> notificationList = [];
    if (value == null) {
      return hashMap;
    } else {
      notificationList = SavedNotificationData.decode(value);
      for (var i = 0; i < notificationList.length; i++) {
        hashMap['${notificationList[i].notificationId}'] = notificationList[i];
      }
      return hashMap;
    }
  }

  static Future<void> storeNotificationReadFlagList(
      String notificationJson) async {
    var storage = new FlutterSecureStorage();
    await storage.write(key: _storageKeynotification, value: notificationJson);
  }
}

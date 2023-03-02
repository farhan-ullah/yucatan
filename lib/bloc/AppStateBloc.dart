import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import '../models/notification_model.dart';
import '../services/notification_service/notification_actions.dart';
import '../services/user_notification_service.dart';
import '../services/user_provider.dart';

class AppStateBloc {
  final _vendorNotificationsCount = BehaviorSubject<int>();
  final _userNotificationsCount = BehaviorSubject<int>();

  get getUserNotificationsCount => _userNotificationsCount.stream;

  get getVendorNotificationsCount => _vendorNotificationsCount.stream;

  NotificationActions getNotificationAction(NotificationModel model) {
    // When notifications data is null return None, needs to be checked

    if (model.data == null) return NotificationActions.NONE;
    var notifcationData = NotificationData.fromJson(jsonDecode(model.data!));
    return NotificationActions.values.firstWhere(
        (element) =>
            element.toString().split('.')[1].toLowerCase() ==
            notifcationData.action!.toLowerCase(),
        orElse: () => NotificationActions.NONE);
  }

  getNotifications() async {
    var user = await UserProvider.getUser();
    if (user == null) return;
    int currentVendorCount = 0;
    int currentUserCount = 0;

    var notificationsRespone =
        await UserNotificationService.getNotificationsForUser();
    var savedNotifications =
        await UserNotificationService.getSavedNotificationReadFlagData();
    savedNotifications.forEach((key, value) {
      SavedNotificationData savedNotificationData = value;
      if (savedNotificationData.userId!.trim() == user.sId!.trim() &&
          !savedNotificationData.read!) {
        currentUserCount += 1;
        currentVendorCount += 1;
      }
    });
    if (notificationsRespone != null &&
        notificationsRespone.status == 200 &&
        notificationsRespone.notifications != null) {
      for (int i = 0; i < notificationsRespone.notifications!.length; i += 1) {
        var notification = notificationsRespone.notifications!.elementAt(i);
        for (int j = 0; j < notification.target!.userIds!.length; j += 1) {
          if (user.sId!.trim() ==
                  notification.target!.userIds!.elementAt(j).userId!.trim() &&
              !notification.target!.userIds!.elementAt(j).read!) {
            try {
              if (notification.type == NotificationType.SYSTEM) {
                currentVendorCount += 1;
                currentUserCount += 1;
              } else
                switch (getNotificationAction(notification)) {
                  case NotificationActions.USER_SHOW_USABLE_BOOKING:
                  case NotificationActions.USER_SHOW_DENIED_REQUEST:
                  case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
                    currentUserCount += 1;
                    break;
                  case NotificationActions.VENDOR_SHOW_REQUEST:
                  case NotificationActions.VENDOR_SHOW_REFUNDED_BOOKING:
                    currentVendorCount += 1;
                    break;
                  case NotificationActions.NONE:
                    currentVendorCount += 1;
                    currentUserCount += 1;
                    break;
                }
              break;
            } on Exception catch (_) {
              break;
            }
          }
        }
      }
    }
    _userNotificationsCount.sink.add(currentUserCount);
    _vendorNotificationsCount.sink.add(currentVendorCount);
  }

  dispose() {
    _vendorNotificationsCount.close();
    _userNotificationsCount.close();
  }
}

final AppStateBloc appStateBloc = AppStateBloc();

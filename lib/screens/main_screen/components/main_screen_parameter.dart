import 'package:yucatan/services/notification_service/notification_actions.dart';

class MainScreenParameter {
  int? bottomNavigationBarIndex;
  NotificationActions? notificationAction;
  dynamic? notificationData;
  String? activityId = "0";
  bool? isBookingRequestType;

  MainScreenParameter(
      {this.bottomNavigationBarIndex,
      this.notificationAction,
      this.notificationData,
      this.activityId,
      this.isBookingRequestType = false});
}

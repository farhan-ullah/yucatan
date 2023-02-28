import 'package:yucatan/services/notification_service/notification_actions.dart';

abstract class NavigatableByNotifcation {
  void handleNavigation(
      NotificationActions notificationAction, dynamic notificationData);
}

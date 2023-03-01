import 'package:yucatan/models/notification_model.dart';

class UserNotificationResponse {
  int? status;
  bool? success;
  List<NotificationModel>? notifications;

  UserNotificationResponse({
    this.status,
    this.success,
    this.notifications,
  });

  factory UserNotificationResponse.fromJson(Map<String, dynamic> json) {
    return UserNotificationResponse(
      status: json['status'],
      success: json['data'] != null,
      notifications: json['data'] != null
          ? json['data']
              .map<NotificationModel>(
                (value) => NotificationModel.fromJson(value),
              )
              .toList()
          : [],
    );
  }
}

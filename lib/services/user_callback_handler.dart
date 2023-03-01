import 'package:yucatan/services/notification_service/notification_service.dart';

class UserCallbackHandler {
  static UserCallbackHandler? _instance;
  factory UserCallbackHandler() => _instance ?? UserCallbackHandler._();
  UserCallbackHandler._();

  List<dynamic> callbacks = [];

  userChanged() {
    NotificationService.updateBadge();

    callbacks.forEach(
      (callback) {
        callback.call();
      },
    );
  }
}

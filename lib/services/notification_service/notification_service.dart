import 'dart:convert';

import 'package:yucatan/bloc/AppStateBloc.dart';
import 'package:yucatan/models/notification_model.dart';
import 'package:yucatan/models/schedule_notification.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/notifications/notifications_screen.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/booking_overview_screen.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/services/user_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static NotificationService? _instance;
  GlobalKey<NavigatorState>? _navigatorKey;
  static FirebaseMessaging? _firebaseMessaging;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  NotificationService._(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static Future<NotificationService> initialize(
      GlobalKey<NavigatorState> navigatorKey) async {
    if (_instance == null) {
      _instance = NotificationService._(navigatorKey);

      await _initFirebaseMessaging();
      await _initLocalNotification();
      _initTimeZone();
    }

    return _instance!;
  }

  static void _initTimeZone() async {
    try {
      String _timezone = await FlutterNativeTimezone.getLocalTimezone();
      print('Time:: $_timezone');
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(_timezone));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> _initFirebaseMessaging() async {
    _firebaseMessaging = FirebaseMessaging.instance;

    await _firebaseMessaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    var fcmToken = await _firebaseMessaging!.getToken();
    _instance!._saveFcmToken(fcmToken!);

    _firebaseMessaging!.getInitialMessage().then((message) {
      if (message != null) {
        updateBadge();
        _instance!._handlePushWhileClosed(message);
      }
    });

    _firebaseMessaging!.onTokenRefresh.listen(_instance!._saveFcmToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      updateBadge();
      _instance!._handlePushWhileOpen(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      updateBadge();
      _instance!._handlePushWhileClosed(message);
    });

    return Future.sync(() => null);
  }

  static Future updateBadge() async {
    UserProvider.getUser()!.then((user) {
      if (user == null) FlutterAppBadger.removeBadge();

      _getNotificationsStream(user).listen((event) {
        if (event == 0) {
          // return FlutterAppBadger.updateBadgeCount(event);
        }

        FlutterAppBadger.updateBadgeCount(event);
      });
    });
  }

  static Stream<int> _getNotificationsStream(user) {
    if (user == null) return Stream.value(0);

    if (user.getRole() == "Vendor")
      return appStateBloc.getVendorNotificationsCount;

    if (user.getRole() == "User") return appStateBloc.getUserNotificationsCount;

    return Stream.value(0);
  }

  Future<void> scheduleNotification(ScheduleNotification notification) async {
    var scheduledNotificationDateTime =
        tz.TZDateTime.from(notification.dateTime, tz.local);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'appventure',
      'appventure_channel',
      'description',
      priority: Priority.max,
      importance: Importance.max,
      fullScreenIntent: true,
    );
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentAlert: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    //TODO : Notification Message Required
    await flutterLocalNotificationsPlugin!.zonedSchedule(
        notification.notificationId,
        '${notification.bookingTitle}',
        'Notification message required!',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelScheduleNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin!.cancel(notificationId);
  }

  static Future<void> _initLocalNotification() {
    // For local push notification
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('appventure_icon_white');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: _instance!._onSelectNotification);

    return Future.sync(() => null);
  }

  void _saveFcmToken(String token) async {
    UserLoginModel? user = await UserProvider.getUser();
    if (user != null) {
      UserService.saveFcmToken(userId: user.sId, fcmToken: token);
    }
  }

  void _handlePushWhileOpen(RemoteMessage message) {
    appStateBloc.getNotifications();
    print('---------handlePushWhileOpen---------=${message.data}');

    AnalyticsService.logOpenNotification(message);

    //Show push message
    _showNotification(message);
  }

  Future<void> _handlePushWhileClosed(RemoteMessage message) {
    appStateBloc.getNotifications();
    print('---------handlePushWhileClosed---------=${message.data}');

    AnalyticsService.logOpenNotification(message);

    NotificationData? notificationData =
        parseBackgroundNotificationData(message.data);

    //Handle action
    _handleAction(notificationData!.action!, notificationData.data, false);

    return Future.sync(() => null);
  }

  void _handleLocal(Map<String, dynamic> data) {
    updateBadge();
    appStateBloc.getNotifications();

    NotificationData? notificationData = parseNotificationData(data, false);

    //Handle action
    _handleAction(notificationData!.action!, notificationData.data, false);
  }

  void handleInApp(NotificationModel notification) {
    updateBadge();
    appStateBloc.getNotifications();

    //Log firebase event
    if (kReleaseMode) {
      // FirebaseAnalytics.logEvent(
      //   name: 'fcm_in_app_message_action',
      //   parameters: <String, dynamic>{
      //     'message_id': notification.id,
      //     'message_title': notification.title,
      //     'message_device_time': DateTime.now().toIso8601String(),
      //   },
      // );
    }

    //Handle action
    NotificationData? notificationData =
        parseNotificationData(json.decode(notification.data!), true);

    //Handle action
    _handleAction(notificationData!.action!, notificationData.data, true);
  }

  void _handleAction(String action, dynamic data, bool inApp) async {
    NotificationActions? notificationAction =
        NotificationActions.values.firstWhere(
      (element) =>
          element.toString().split('.')[1].toLowerCase() ==
          action.toLowerCase(),
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('handleNotification', true);

    UserLoginModel? user = await UserProvider.getUser();

    if (user == null) return;

    switch (notificationAction) {
      case NotificationActions.NONE:
        if (inApp) break;

        _navigatorKey!.currentState!.pushNamed(NotificationsScreen.route);

        break;
      case NotificationActions.USER_SHOW_DENIED_REQUEST:
        user.switchToUserRole();

        bool stopRoutePop = false;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil(
          MainScreen.route,
          (route) {
            if (stopRoutePop) return true;
            if (ModalRoute.withName(MainScreen.route)(route)) {
              stopRoutePop = true;
            }
            return false;
          },
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 1,
            notificationAction: notificationAction,
            notificationData: data,
          ),
        );

        break;
      case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
        user.switchToUserRole();

        bool stopRoutePop = false;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil(
          MainScreen.route,
          (route) {
            if (stopRoutePop) return true;
            if (ModalRoute.withName(MainScreen.route)(route)) {
              stopRoutePop = true;
            }
            return false;
          },
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 1,
            notificationAction: notificationAction,
            notificationData: data,
          ),
        );
        break;

      case NotificationActions.USER_SHOW_USABLE_BOOKING:
        user.switchToUserRole();

        bool stopRoutePop = false;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil(
          MainScreen.route,
          (route) {
            if (stopRoutePop) return true;
            if (ModalRoute.withName(MainScreen.route)(route)) {
              stopRoutePop = true;
            }
            return false;
          },
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 1,
            notificationAction: notificationAction,
            notificationData: data,
          ),
        );

        break;
      case NotificationActions.VENDOR_SHOW_REFUNDED_BOOKING:
        if (user.role == "User") return;

        user.switchToDefaultRole();

        _navigatorKey!.currentState!
            .popUntil(ModalRoute.withName(MainScreen.route));

        _navigatorKey!.currentState!.pushReplacementNamed(
          MainScreen.route,
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 0,
          ),
        );

        Future.delayed(Duration(milliseconds: 1000), () {
          _navigatorKey!.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) => VendorBookingOverviewScreen(
                notificationAction: notificationAction,
                notificationData: data,
              ),
            ),
          );
        });

        break;
      case NotificationActions.VENDOR_SHOW_REQUEST:
        if (user.role == "User") return;

        user.switchToDefaultRole();

        _navigatorKey!.currentState!
            .popUntil(ModalRoute.withName(MainScreen.route));

        _navigatorKey!.currentState!.pushReplacementNamed(
          MainScreen.route,
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 0,
          ),
        );

        Future.delayed(Duration(milliseconds: 1000), () {
          _navigatorKey!.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) => VendorBookingOverviewScreen(
                notificationAction: notificationAction,
                notificationData: data,
              ),
            ),
          );
        });

        break;
      default:
        if (inApp) break;
        _navigatorKey!.currentState!.pushNamed(NotificationsScreen.route);
    }
  }

  void _showNotification(RemoteMessage? message) async {
    String? title = message!.notification!.title;
    String? body = message.notification!.body;

    var android = AndroidNotificationDetails(
      'appventure',
      'appventure_channel ',
      'description',
      priority: Priority.max,
      importance: Importance.max,
      fullScreenIntent: true,
    );

    var iOS = IOSNotificationDetails(presentAlert: true);
    var platform = new NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin!.show(0, '$title', '$body', platform,
        payload: jsonEncode(message.data));
  }

  Future _onSelectNotification(String? payload) {
    print('----------onSelectNotification-------$payload');
    _handleLocal(json.decode(payload!));

    return Future.sync(() => true);
  }

  NotificationData? parseNotificationData(
      Map<String, dynamic> data, bool inApp) {
    try {
      if (inApp) return NotificationData.fromJson(data);

      return NotificationData.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  NotificationData? parseBackgroundNotificationData(Map<String, dynamic> data) {
    try {
      return NotificationData.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}

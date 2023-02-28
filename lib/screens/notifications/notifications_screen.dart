import 'dart:collection';
import 'dart:convert';

import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/components/custom_error_screen.dart';
import 'package:yucatan/models/notification_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/services/notification_service/notification_service.dart';
import 'package:yucatan/services/notifications_to_read_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_notification_response.dart';
import 'package:yucatan/services/user_notification_service.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/image_util.dart';
import 'package:yucatan/utils/network_utils.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'components/notification_list_item_shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  static const String route = '/notifications';

  final Function(HashMap) onNotificationClicked;

  NotificationsScreen({
    required this.onNotificationClicked,
  });

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<UserNotificationResponse> _notificationsFuture;
  UserLoginModel _user;
  bool isNetworkAvailable = true;
  String userRole = "User";
  List<SavedNotificationData> savedNotificationList = [];
  HashMap notificationMapObject = new HashMap<String, SavedNotificationData>();

  @override
  void initState() {
    _loadNotifications();
    super.initState();
  }

  void _loadNotifications() async {
    var user = await UserProvider.getUser();
    if (user != null) {
      setState(() {
        _user = user;
        if (user.getRole() == "Vendor") {
          this.userRole = "Vendor";
        } else {
          this.userRole = "User";
        }
      });
    }

    UserNotificationService.getSavedNotificationReadFlagData()
        .then((notificationMapObject) {
      this.notificationMapObject = notificationMapObject;
      callNotificationsApi();
    });
  }

  void callNotificationsApi() {
    if (_user != null) {
      NetworkUtils.isNetworkAvailable().then((isNetworkAvailable) {
        setState(() {
          this.isNetworkAvailable = isNetworkAvailable;
        });
      });
      setState(() {
        _notificationsFuture =
            UserNotificationService.getNotificationsForUser();
        storeNotificationReadFlag();
      });
    }
  }

  void storeNotificationReadFlag() {
    if (_notificationsFuture != null) {
      _notificationsFuture.then((userNotificationResponse) {
        userNotificationResponse.notifications.forEach((notificationData) {
          if (notificationData.type == NotificationType.SYSTEM) {
            SavedNotificationData savedNotificationData =
                SavedNotificationData();
            savedNotificationData.notificationId = notificationData.id;
            for (var notificationUserId in notificationData.target.userIds) {
              if (notificationUserId.userId.trim() == _user.sId.trim()) {
                savedNotificationData.read = true;
                savedNotificationData.userId = notificationUserId.userId;
                break;
              }
            }
            savedNotificationList.add(savedNotificationData);
            UserNotificationService.storeNotificationReadFlagList(
                SavedNotificationData.encode(savedNotificationList));
          }
        });
      });
    }
  }

  void callApi() {
    _notificationsFuture = UserNotificationService.getNotificationsForUser();
  }

  _refreshNotifications() {
    setState(() {
      _notificationsFuture = UserNotificationService.getNotificationsForUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          userRole == "User" ? null : CustomTheme.vendorMenubackground,
      appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.notificationsScreen_title,
          appBar: AppBar(),
          centerTitle: true,
          backgroundColor: userRole == "User"
              ? CustomTheme.primaryColorDark
              : CustomTheme.primaryColor),
      body: isNetworkAvailable
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                top: Dimensions.getScaledSize(15.0),
                left: Dimensions.getScaledSize(15.0),
                right: Dimensions.getScaledSize(15.0),
                bottom: Dimensions.getScaledSize(15.0),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.getScaledSize(15.0)),
                ),
              ),
              padding: userRole == "Vendor"
                  ? EdgeInsets.symmetric(
                      vertical: Dimensions.getScaledSize(10.0),
                      horizontal: Dimensions.getScaledSize(12.0))
                  : null,
              child: FutureBuilder<UserNotificationResponse>(
                future: _notificationsFuture,
                builder: (context, snapshot) {
                  if (_user == null) {
                    return CustomErrorEmptyScreen(
                      title: AppLocalizations.of(context)!.commonWords_mistake,
                      description: AppLocalizations.of(context)
                          .notificationsNotLoggedInScreen_loginTosee,
                      rive: RiveAnimation(
                        riveFileName: 'notifications_animiert_loop.riv',
                        riveAnimationName: 'Animation 1',
                        placeholderImage:
                            'lib/assets/images/favorites_empty.png',
                        startAnimationAfterMilliseconds: 0,
                      ),
                      customButtonText:
                          AppLocalizations.of(context)!.loginSceen_login,
                      callback: () {
                        Navigator.of(context).pushNamed(LoginScreen.route).then(
                          (value) {
                            Navigator.of(context).pushReplacementNamed(
                              MainScreen.route,
                              arguments: MainScreenParameter(
                                bottomNavigationBarIndex: 0,
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasData) {
                    snapshot.data.notifications.sort((a, b) =>
                        b.publishDateTime.compareTo(a.publishDateTime));

                    var filterList =
                        getFilteredNotifications(snapshot.data.notifications);

                    return filterList.length == 0
                        ? CustomErrorEmptyScreen(
                            title: AppLocalizations.of(context)
                                .commonWords_mistake,
                            description: AppLocalizations.of(context)
                                .noNotificationsScreen_noNotifications,
                            rive: RiveAnimation(
                              riveFileName: 'notifications_animiert_loop.riv',
                              riveAnimationName: 'Animation 1',
                              placeholderImage:
                                  'lib/assets/images/favorites_empty.png',
                              startAnimationAfterMilliseconds: 0,
                            ),
                            showButton: false,
                          )
                        : RefreshIndicator(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: Dimensions.getScaledSize(5.0),
                                    ),
                                    _notificationItem(filterList[index], index),
                                    SizedBox(
                                      height: Dimensions.getScaledSize(5.0),
                                    ),
                                  ],
                                );
                              },
                              itemCount: filterList.length,
                            ),
                            onRefresh: () async {
                              await Future.delayed(Duration(seconds: 1));
                              _refreshNotifications();
                            },
                          );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }

                  return NotificationListViewShimmer(
                    width: MediaQuery.of(context).size.width,
                  );
                },
              ),
            )
          : ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
              bool isNetworkAvailable = await NetworkUtils.isNetworkAvailable();
              this.isNetworkAvailable = isNetworkAvailable;
              if (isNetworkAvailable) {
                setState(() {});
              }
            }),
    );
  }

  Widget _notificationItem(NotificationModel notificationModel, int index) {
    //Log firebase event
    if (kReleaseMode) {
      FirebaseAnalytics().logEvent(
        name: 'fcm_in_app_message_impression',
        parameters: <String, dynamic>{
          'message_id': notificationModel.id,
          'message_title': notificationModel.title,
          'message_device_time': DateTime.now().toIso8601String(),
        },
      );
    }

    if (notificationModel.type == NotificationType.SYSTEM) {
      notificationModel.opened =
          notificationMapObject.containsKey(notificationModel.id);
    } else {
      for (var notificationUserIdArray in notificationModel.target.userIds) {
        if (notificationUserIdArray.userId.trim() == _user.sId.trim() &&
            notificationUserIdArray.read) {
          notificationModel.opened = true;
        }
      }
    }

    return InkWell(
      onTap: () async {
        if (!notificationMapObject.containsKey(notificationModel.id) &&
            notificationModel.type == NotificationType.SYSTEM) {
          setState(() {
            SavedNotificationData savedNotificationData =
                SavedNotificationData();
            savedNotificationData.notificationId = notificationModel.id;
            savedNotificationData.read = true;
            savedNotificationData.userId = _user.sId;
            notificationMapObject['${notificationModel.id}'] =
                savedNotificationData;
            widget.onNotificationClicked(notificationMapObject);
          });
        } else {
          UserNotificationService.setNotificationsToRead(notificationModel.id)
              .then((userNotificationsResponse) {
            NotificationsToReadResponse notificationsToReadResponse =
                userNotificationsResponse;
            if (notificationsToReadResponse != null) {
              if (notificationsToReadResponse.status == 200) {
                widget.onNotificationClicked(notificationMapObject);
                _loadNotifications();
              }
            }
          });
        }
        NotificationService notificationServiceInstance =
            await NotificationService.initialize(null);

        notificationServiceInstance.handleInApp(notificationModel);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: notificationModel.opened
              ? Colors.white
              : CustomTheme.primaryColor.withOpacity(0.1),
          border: Border.all(
            width: 1.0,
            color: notificationModel.opened
                ? CustomTheme.mediumGrey
                : Colors.white,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.getScaledSize(16.0)),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getScaledSize(10.0),
          vertical: Dimensions.getScaledSize(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Dimensions.getScaledSize(70.0),
              width: Dimensions.getScaledSize(70.0),
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.white,
                  width: Dimensions.getScaledSize(3.0),
                ),
                borderRadius: BorderRadius.circular(60),
                color: CustomTheme.primaryColorDark,
              ),
              child: Center(
                child: Icon(
                  Icons.home_work_outlined,
                  size: Dimensions.getScaledSize(35.0),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.getScaledSize(10.0),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.getScaledSize(4.0),
                          horizontal: Dimensions.getScaledSize(8.0)),
                      decoration: BoxDecoration(
                        color: _getActionColor(notificationModel),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        '${notificationModel.title}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(12.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(6.0),
                    ),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                            text: notificationModel.descriptionSubject,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(14.0),
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColorDark,
                            ),
                            children: [
                              TextSpan(
                                text: isNotNullOrEmpty(
                                        notificationModel.descriptionSubject)
                                    ? ' | ${notificationModel.description}'
                                    : '${notificationModel.description}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: Dimensions.getScaledSize(14.0),
                                  color: CustomTheme.primaryColorDark,
                                ),
                              ),
                            ])),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.getScaledSize(10.0),
            ),
            SizedBox(
              width: Dimensions.getScaledSize(60.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  _getPublishedDateString(notificationModel),
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(14.0),
                    color: CustomTheme.darkGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(NotificationModel notificationModel) {
    NotificationData data =
        NotificationData.fromJson(jsonDecode(notificationModel.data));

    var action = NotificationActions.values.firstWhere(
        (element) =>
            element.toString().split('.')[1].toLowerCase() ==
            data.action.toLowerCase(),
        orElse: () => NotificationActions.NONE);

    switch (action) {
      case NotificationActions.USER_SHOW_USABLE_BOOKING:
        return CustomTheme.accentColor2;
      case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
      case NotificationActions.VENDOR_SHOW_REFUNDED_BOOKING:
        return CustomTheme.accentColor1;
      case NotificationActions.USER_SHOW_DENIED_REQUEST:
      case NotificationActions.VENDOR_SHOW_REQUEST:
        return CustomTheme.primaryColor;
      case NotificationActions.NONE:
      default:
        return CustomTheme.accentColor3;
    }
  }

  String _getPublishedDateString(NotificationModel notificationModel) {
    var now = DateTime.now();

    if (GlobalDate.isToday(notificationModel.publishDateTime)) {
      return AppLocalizations.of(context)!.today;
    } else if (notificationModel.publishDateTime.isAfter(
      DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(
        Duration(days: 1),
      ),
    )) {
      return AppLocalizations.of(context)!.notificationsScreen_oneDay;
    } else if (notificationModel.publishDateTime.isAfter(
      DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(
        Duration(days: 2),
      ),
    )) {
      return AppLocalizations.of(context)!.notificationsScreen_twoDay;
    } else if (notificationModel.publishDateTime.isAfter(
      DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(
        Duration(days: 3),
      ),
    )) {
      return AppLocalizations.of(context)!.notificationsScreen_threeDay;
    } else {
      return DateFormat('dd.MM.yy').format(notificationModel.publishDateTime);
    }
  }

  NotificationActions getNotificationAction(NotificationModel model) {
    var notifcationData = NotificationData.fromJson(jsonDecode(model.data));
    return NotificationActions.values.firstWhere(
        (element) =>
            element.toString().split('.')[1].toLowerCase() ==
            notifcationData.action.toLowerCase(),
        orElse: () => NotificationActions.NONE);
  }

  List<NotificationModel> getFilteredNotifications(
      List<NotificationModel> notifications) {
    List<NotificationModel> filterUser = [];
    List<NotificationModel> filterVendor = [];

    notifications.forEach((element) {
      switch (getNotificationAction(element)) {
        case NotificationActions.USER_SHOW_USABLE_BOOKING:
        case NotificationActions.USER_SHOW_DENIED_REQUEST:
        case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
          filterUser.add(element);
          break;
        case NotificationActions.VENDOR_SHOW_REQUEST:
        case NotificationActions.VENDOR_SHOW_REFUNDED_BOOKING:
          filterVendor.add(element);
          break;
        case NotificationActions.NONE:
          filterUser.add(element);
          filterVendor.add(element);
          break;
      }
    });

    return userRole == "Vendor" ? filterVendor : filterUser;
  }
}

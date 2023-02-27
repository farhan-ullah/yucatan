import 'dart:collection';

import 'package:appventure/bloc/AppStateBloc.dart';
import 'package:appventure/models/notification_model.dart';
import 'package:appventure/services/response/user_login_response.dart';
import 'package:appventure/services/user_provider.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'notifications_screen.dart';

class NotificationView extends StatefulWidget {
  final bool defaultIcon;
  final IconData icon;
  final Color color;
  final bool negativePadding;

  NotificationView({
    this.defaultIcon = true,
    this.icon,
    this.color,
    this.negativePadding = false,
  });

  @override
  _NotificationViewState createState() {
    return _NotificationViewState();
  }
}

class _NotificationViewState extends State<NotificationView> {
  UserLoginModel _user;
  HashMap notificationMapObject = new HashMap<String, SavedNotificationData>();

  @override
  void initState() {
    super.initState();
    getNotificationData();
    appStateBloc.getNotifications();
  }

  Future<void> getNotificationData() async {
    var user = await UserProvider.getUser();
    if (user != null && mounted) {
      setState(() {
        this._user = user;
      });

      // UserNotificationService.getNotificationsForUser()
      //     .then((notificationResponse) {
      //   if (notificationResponse != null) {
      //     this.userNotificationResponse = notificationResponse;
      //     for (var i = 0;
      //         i < userNotificationResponse.notifications.length;
      //         i++) {
      //       var notificationData = userNotificationResponse.notifications[i];
      //       for (var notificationUserIdArray
      //           in notificationData.target.userIds) {
      //         if (notificationUserIdArray.userId.trim() == _user.sId.trim() &&
      //             !notificationUserIdArray.read) {
      //           notificationCounter = notificationCounter + 1;
      //           //print("=${notificationData.type}=AND=${_user.sId}===AND===${notificationUserIdArray.userId} AND ${notificationUserIdArray.read}");
      //           showNotificationBadge = true;
      //           //break;
      //         }
      //       }
      //       if (showNotificationBadge) {
      //         if (this.mounted) {
      //           setState(() {});
      //         }
      //       }
      //     }
      //     //print("=====notificationCounter=====${notificationCounter}");
      //   }
      // });
      /*try {
        this.notificationMapObject.forEach((key, value){
          SavedNotificationData savedNotificationData = value;
          print("=====forEach=====${savedNotificationData.read}");
          if(!savedNotificationData.read){
            if (this.mounted) {
              setState(() {
                showNotificationBadge = true;
              });
            }
          }
        });
      } catch (e) {
        print(e);
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.of(context).pushNamed(NotificationsScreen.route);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationsScreen(
                    onNotificationClicked: (notificationMapObject) {
                      this.notificationMapObject = notificationMapObject;
                      getNotificationData();
                    },
                  )),
        );
      },
      child: StreamBuilder(
        stream: _getNotificationsStream(_user),
        builder: (context, snapshotNotifications) {
          bool showNotificationBadge = false;
          int notificationsCounter = 0;
          if (snapshotNotifications.hasData && snapshotNotifications.data > 0) {
            notificationsCounter = snapshotNotifications.data;
            showNotificationBadge = true;
          }

          return Badge(
            elevation: 0,
            child: Icon(
              widget.defaultIcon ? Icons.notifications_outlined : widget.icon,
              size: Dimensions.getScaledSize(30.0),
              color: widget.defaultIcon ? Colors.white : widget.color,
            ),
            position: BadgePosition.topStart(
              start: Dimensions.getScaledSize(16.0),
              top: widget.negativePadding
                  ? Dimensions.getScaledSize(-3)
                  : Dimensions.getScaledSize(10),
            ),
            badgeColor: CustomTheme.accentColor1,
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(12),
            showBadge: showNotificationBadge,
            badgeContent: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(4),
                right: Dimensions.getScaledSize(4),
              ),
              child: Text(
                '${getNotificationCounterValue(notificationsCounter)}',
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(12),
                  color: Colors.white,
                ),
              ),
            ),
            padding: EdgeInsets.all(2),
          );
        },
      ),
    );
  }

  _getNotificationsStream(user) {
    if (user != null) {
      if (user.getRole() == "Vendor") {
        return appStateBloc.getVendorNotificationsCount;
      }
      if (user.getRole() == "User") {
        return appStateBloc.getUserNotificationsCount;
      }
    }
    return null;
  }

  String getNotificationCounterValue(notificationCounter) {
    if (notificationCounter > 9) {
      return "9+";
    } else {
      return "$notificationCounter";
    }
  }
}

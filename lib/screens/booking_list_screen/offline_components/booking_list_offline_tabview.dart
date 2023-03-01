import 'package:yucatan/components/custom_error_screen.dart';
import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/screens/booking_list_screen/components/booking_list_card_type.dart';
import 'package:yucatan/services/notification_service/navigatable_by_notification.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_offline_listview_item.dart';

class BookingListOfflineView extends StatelessWidget
    with NavigatableByNotifcation {
  final List<BookingDetailedModel>? bookings;
  final Function? refresh;
  final String noBookingsTitle;
  final BookingListCardType bookingListCardType;
  final bool online;
  final NotificationActions? notificationAction;
  final dynamic notificationData;
  final Function? removeDeniedRequest;

  final ItemScrollController _itemScrollController = ItemScrollController();

  BookingListOfflineView({
    Key? key,
    this.bookings,
    this.refresh,
    required this.online,
    required this.noBookingsTitle,
    required this.bookingListCardType,
    this.notificationAction,
    this.notificationData,
    this.removeDeniedRequest,
  });

  @override
  void handleNavigation(
      NotificationActions notificationAction, dynamic notificationData) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      bool? handleNotifications =
          sharedPreferences.getBool('handleNotification');

      if (handleNotifications == false) return;

      if (bookings!
              .any((element) => element.id == notificationData.toString()) ==
          false) return;

      switch (notificationAction) {
        case NotificationActions.USER_SHOW_USABLE_BOOKING:
          if (bookingListCardType != BookingListCardType.USABLE) return;

          //Scroll to the list view element which represents the booking sent via the notification
          _scrollToBookingListViewItem(notificationData.toString());

          break;
        case NotificationActions.USER_SHOW_DENIED_REQUEST:
          if (bookingListCardType != BookingListCardType.REQUESTED) return;

          //Scroll to the list view element which represents the booking sent via the notification
          _scrollToBookingListViewItem(notificationData.toString());

          break;
        case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
          if (bookingListCardType != BookingListCardType.USABLE) return;

          //Scroll to the list view element which represents the booking sent via the notification
          _scrollToBookingListViewItem(notificationData.toString());

          break;
        default:
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () => handleNavigation(notificationAction!, notificationData),
    );

    return bookings!.length == 0
        ? CustomErrorEmptyScreen(
            title: AppLocalizations.of(context)!.commonWords_mistake,
            description: noBookingsTitle,
            rive: RiveAnimation(
              riveFileName: 'tickets_animiert_loop.riv',
              riveAnimationName: 'Animation 1',
              placeholderImage: 'lib/assets/images/booking_list_empty.png',
              startAnimationAfterMilliseconds: 0,
            ),
            customButtonText:
                AppLocalizations.of(context)!.bookingListScreen_goToSearch,
            callback: () {
              eventBus.fire(OnOpenSearch());
            },
          )
        : bookingListCardType == BookingListCardType.REQUESTED
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.getScaledSize(20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.getScaledSize(12.0)),
                    child: Text(
                      AppLocalizations.of(context)!
                          .bookingListScreen_pendingRequests,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18.0),
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                  Expanded(child: _getBookingListView()),
                ],
              )
            : _getBookingListView();
  }

  Widget _getBookingListView() {
    return RefreshIndicator(
      child: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        padding: EdgeInsets.only(
            top: Dimensions.getScaledSize(20.0),
            left: Dimensions.getScaledSize(10.0),
            right: Dimensions.getScaledSize(10.0),
            bottom: Dimensions.getScaledSize(10.0)),
        itemCount: bookings!.length,
        itemBuilder: (context, index) {
          if (bookings![index].status == "REQUEST_DENIED" && online) {
            return Column(
              key: UniqueKey(),
              children: [
                Slidable(
                  child: BookingOfflineListViewItem(
                    booking: bookings![index],
                    bookingListCardType: bookingListCardType,
                    online: online,
                    notificationAction: notificationAction!,
                    notificationData: notificationData,
                  ),

                  startActionPane: ActionPane(
                    motion:  const ScrollMotion(),
                    children: [
                    SlidableAction(
                      onPressed:
                          (value) {
                        removeDeniedRequest!(bookings![index].id);
                      },
                      icon: Icons.delete_forever_outlined,
                      label: AppLocalizations.of(context)!.commonWords_clear,

                    ),


                  ],

                  ),

                  // actionPane: SlidableBehindActionPane(),
                  // actionExtentRatio: 0.4,
                  // secondaryActions: [
                  //   SlideAction(
                  //     onTap: () {
                  //       removeDeniedRequest!(bookings![index].id);
                  //     },
                  //     decoration: BoxDecoration(
                  //       color: CustomTheme.accentColor1,
                  //       borderRadius: BorderRadius.circular(
                  //           Dimensions.getScaledSize(16.0)),
                  //     ),
                  //     child: Container(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Icon(
                  //             Icons.delete_forever_outlined,
                  //             size: Dimensions.getScaledSize(32.0),
                  //             color: Colors.white,
                  //           ),
                  //           SizedBox(
                  //             height: Dimensions.getScaledSize(20.0),
                  //           ),
                  //           Text(
                  //             AppLocalizations.of(context)!.commonWords_clear,
                  //             style: TextStyle(
                  //               fontSize: Dimensions.getScaledSize(16.0),
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ),
                SizedBox(height: Dimensions.getScaledSize(20))
              ],
            );
          }
          return Column(
            key: UniqueKey(),
            children: [
              BookingOfflineListViewItem(
                booking: bookings![index],
                bookingListCardType: bookingListCardType,
                online: online,
                notificationAction: notificationAction!,
                notificationData: notificationData,
              ),
              SizedBox(height: Dimensions.getScaledSize(20))
            ],
          );
        },
      ),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        refresh!();
      },
    );
  }

  ///Scroll to the item in the list view which matches with the given id
  void _scrollToBookingListViewItem(String id) {
    //Scroll to the list view element which represents the booking sent via the notification
    _itemScrollController.scrollTo(
      index: bookings!
          .indexWhere((element) => element.id == notificationData.toString()),
      duration: Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
}

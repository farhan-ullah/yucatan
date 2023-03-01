import 'package:yucatan/components/custom_error_screen.dart';
import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/booking_list_screen/components/booking_list_card_type.dart';
import 'package:yucatan/screens/booking_list_screen/offline_components/booking_list_offline_tabview.dart';
import 'package:yucatan/screens/booking_list_screen/offline_components/booking_list_view_item_skeleton.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/notification_service/navigatable_by_notification.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/booking_detailed_multi_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/status_service.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingListScreenOffline extends StatefulWidget {
  static const String route = '/bookinglist';

  final Function? refresh;
  final NotificationActions? notificationAction;
  final dynamic notificationData;
  final bool? isBookingRequestType;

  BookingListScreenOffline({
    this.refresh,
    this.notificationAction,
    this.notificationData,
    this.isBookingRequestType,
  });

  @override
  _BookingListScreenOfflineState createState() =>
      _BookingListScreenOfflineState();
}

class _BookingListScreenOfflineState extends State<BookingListScreenOffline>
    with NavigatableByNotifcation, TickerProviderStateMixin {
  Future<UserLoginModel>? user;
  Future<BookingDetailedMultiResponseEntity>? bookings;
  List<BookingDetailedModel> used = [];
  List<BookingDetailedModel> usable = [];
  List<BookingDetailedModel> requested = [];
  Future<bool>? onlineStatus;
  TabController? _tabController;
  bool offlineBookings = true;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void removeDeniedBooking(bookingId) async {
    // for now use delete booking

    bool response = await BookingService.deleteBooking(bookingId);
    if (response != null && response) {
      HiveService.updateDatabase();
      BookingDetailedMultiResponseEntity newBookings =
          BookingDetailedMultiResponseEntity();
      requested.removeWhere((element) => element.id == bookingId);
      newBookings.data = [...used, ...usable, ...requested];
      newBookings.status = 200;
      // newBookings.errors = ApiError;
      setState(() {
        bookings = Future.value(newBookings);
      });
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.commonWords_error);
    }
  }

  void refresh() {
    setState(() {
      onlineStatus = null;
      onlineStatus = StatusService.isConnected();
      offlineBookings = true;
    });
  }

  @override
  void initState() {
    //Log firebase event
    if (kReleaseMode) {
      analytics.logEvent(
        name: 'view_booking_list',
        parameters: <String, dynamic>{
          'time': DateTime.now().toIso8601String(),
        },
      );
    }

    offlineBookings = true;
    onlineStatus = StatusService.isConnected();

    if (widget.notificationAction != null && widget.notificationData != null) {
      handleNavigation(widget.notificationAction!, widget.notificationData);
    } else {
      _tabController = TabController(
          length: 3,
          initialIndex: widget.isBookingRequestType! ? 2 : 0,
          vsync: this);
    }

    super.initState();
  }

  @override
  void handleNavigation(
      NotificationActions notificationAction, dynamic notificationData) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool handleNotifications = sharedPreferences.getBool('handleNotification')!;

    if (handleNotifications == false) {
      _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
      return;
    }

    switch (notificationAction) {
      case NotificationActions.USER_SHOW_USABLE_BOOKING:
        _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
        break;
      case NotificationActions.USER_SHOW_DENIED_REQUEST:
        _tabController = TabController(length: 3, initialIndex: 2, vsync: this);
        break;
      case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
        _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Scaffold.of(context).appBarMaxHeight!;
    return FutureBuilder<bool>(
      builder: (context, snapshotConnected) {
        if (snapshotConnected.hasData) {
          // if there is no connectionn, get from SharedPrefs
          if (snapshotConnected.data!) {
            user = UserProvider.getUser();
          } else {
            user = UserProvider.getOfflineUser();
          }
          return Column(
            children: [
              Container(
                height: Dimensions.getScaledSize(60),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(0, height, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CustomTheme.mediumGrey,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: CustomTheme.primaryColorDark,
                  labelColor: CustomTheme.primaryColorDark,
                  labelStyle: TextStyle(
                    fontSize: Dimensions.getScaledSize(18.0),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AcuminProWide',
                  ),
                  unselectedLabelColor: CustomTheme.darkGrey.withOpacity(0.5),
                  unselectedLabelStyle: TextStyle(
                    fontSize: Dimensions.getScaledSize(18.0),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AcuminProWide',
                  ),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.commonWords_usable),
                    Tab(text: AppLocalizations.of(context)!.commonWords_used),
                    Tab(
                        text:
                            AppLocalizations.of(context)!.commonWords_request),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<UserLoginModel>(
                  future: user,
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasData) {
                      if (offlineBookings || !snapshotConnected.data!) {
                        offlineBookings = true;
                        bookings = HiveService.getBookingResponse();
                      }

                      if (snapshotConnected.data! && offlineBookings) {
                        BookingService.getAllForUserDetailed(
                                userSnapshot.data!.sId!)
                            .then((value) {
                          if (value != null &&
                              value.status == 200 &&
                              value.data != null) {
                            if (mounted) {
                              setState(() {
                                offlineBookings = false;
                                bookings = Future.value(value);
                              });
                            }
                          }
                        });
                      }
                      return FutureBuilder<BookingDetailedMultiResponseEntity>(
                        future: bookings,
                        builder: (context, bookingsSnapshot) {
                          if (snapshotConnected.data! &&
                              bookingsSnapshot.hasData &&
                              bookingsSnapshot.data!.data != null) {
                            HiveService.storeBooking(
                                bookingsSnapshot.data!.data!);
                          }
                          if (bookingsSnapshot.hasData &&
                              bookingsSnapshot.data!.data == null) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.getScaledSize(10),
                                  left: Dimensions.getScaledSize(20),
                                  bottom: Dimensions.getScaledSize(20),
                                  right: Dimensions.getScaledSize(20)),
                              child: Text(AppLocalizations.of(context)!
                                  .commonWords_error),
                            );
                          }

                          if (bookingsSnapshot.hasData &&
                              bookingsSnapshot.data!.data != null) {
                            bookingsSnapshot.data!.data!.sort((a, b) =>
                                a.bookingDate!.compareTo(b.bookingDate!));
                            _separateBookings(bookingsSnapshot.data!.data!);

                            return Container(
                              // height: MediaQuery.of(context).size.height -
                              //     60 -
                              //     getProportionateScreenHeight(80) -
                              //     AppBar().preferredSize.height -
                              //     MediaQuery.of(context).padding.top -
                              //     MediaQuery.of(context).padding.bottom,
                              width: MediaQuery.of(context).size.width,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  BookingListOfflineView(
                                    bookingListCardType:
                                        BookingListCardType.USABLE,
                                    noBookingsTitle:
                                        AppLocalizations.of(context)!
                                            .bookingListScreen_noActiveBookings,
                                    bookings: usable,
                                    refresh: refresh,
                                    online: !offlineBookings,
                                    notificationAction:
                                        widget.notificationAction,
                                    notificationData: widget.notificationData,
                                  ),
                                  BookingListOfflineView(
                                    bookingListCardType:
                                        BookingListCardType.USED,
                                    noBookingsTitle:
                                        AppLocalizations.of(context)!
                                            .bookingListScreen_noUsedBookings,
                                    bookings: used,
                                    refresh: refresh,
                                    online: !offlineBookings,
                                    notificationAction:
                                        widget.notificationAction,
                                    notificationData: widget.notificationData,
                                  ),
                                  BookingListOfflineView(
                                    //  key: Key(requested.length.toString()),
                                    bookingListCardType:
                                        BookingListCardType.REQUESTED,
                                    noBookingsTitle: AppLocalizations.of(
                                            context)!
                                        .bookingListScreen_noRequestedBookings,
                                    bookings: requested,
                                    refresh: refresh,
                                    online: !offlineBookings,
                                    notificationAction:
                                        widget.notificationAction,
                                    notificationData: widget.notificationData,
                                    removeDeniedRequest: removeDeniedBooking,
                                  )
                                ],
                              ),
                            );
                          } else if (bookingsSnapshot.hasError) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.getScaledSize(10),
                                  bottom: Dimensions.getScaledSize(20),
                                  left: Dimensions.getScaledSize(20),
                                  right: Dimensions.getScaledSize(20)),
                              child: Text('${bookingsSnapshot.error}'),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.only(
                                top: Dimensions.getScaledSize(20.0),
                                bottom: Dimensions.getScaledSize(16.0),
                                left: Dimensions.getScaledSize(16.0),
                                right: Dimensions.getScaledSize(16.0)),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return BookingListViewItemSkeleton();
                            },
                          );
                        },
                      );
                    } else if (userSnapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: Dimensions.getScaledSize(10),
                            bottom: Dimensions.getScaledSize(20),
                            left: Dimensions.getScaledSize(20),
                            right: Dimensions.getScaledSize(20)),
                        child: Text('${userSnapshot.error}'),
                      );
                    } else if (userSnapshot.data == null) {
                      return CustomErrorEmptyScreen(
                        title:
                            AppLocalizations.of(context)!.commonWords_mistake,
                        description: AppLocalizations.of(context)!
                            .bookingListScreen_loginToSee,
                        rive: RiveAnimation(
                          riveFileName: 'tickets_animiert_loop.riv',
                          riveAnimationName: 'Animation 1',
                          placeholderImage:
                              'lib/assets/images/booking_list_empty.png',
                          startAnimationAfterMilliseconds: 0,
                        ),
                        customButtonText:
                            AppLocalizations.of(context)!.loginSceen_login,
                        callback: _navigateToLogin,
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          );
        } else if (snapshotConnected.hasError) {
          return Padding(
            padding: EdgeInsets.only(
                top: Dimensions.getScaledSize(10),
                bottom: Dimensions.getScaledSize(20),
                left: Dimensions.getScaledSize(20),
                right: Dimensions.getScaledSize(20)),
            child: Text('${snapshotConnected.error}'),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
      future: onlineStatus,
    );
  }

  _separateBookings(List<BookingDetailedModel> bookings) {
    List<BookingDetailedModel> usedBookings = [];
    List<BookingDetailedModel> usableBookings = [];
    List<BookingDetailedModel> requestedBookings = [];
    bookings.forEach((booking) {
      if (_isBookingUsable(booking)) usableBookings.add(booking);
      if (_isBookingUsed(booking)) usedBookings.add(booking);
      if (_isBookingRequested(booking)) requestedBookings.add(booking);
    });
    used = usedBookings;
    usable = usableBookings;
    requested = requestedBookings;
  }

  _isBookingUsable(booking) {
    return ((booking.status == 'SUCCESS' ||
            booking.status == 'REQUEST_ACCEPTED') &&
        booking.tickets.any((element) => element.status == "USABLE"));
  }

  _isBookingUsed(booking) {
    return booking.status == 'REFUNDED' ||
        booking.tickets.every((element) =>
            element.status == "USED" || element.status == "REFUNDED");
  }

  _isBookingRequested(booking) {
    return (booking.status == 'REQUEST' || booking.status == "REQUEST_DENIED");
  }

  _navigateToLogin() {
    Navigator.of(context).pushNamed(LoginScreen.route).then(
      (value) {
        Navigator.of(context).pushReplacementNamed(
          MainScreen.route,
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 1,
          ),
        );
      },
    );
  }
}

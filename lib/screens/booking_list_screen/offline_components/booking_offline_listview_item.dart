import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/screens/booking_list_screen/components/booking_add_review_view.dart';
import 'package:yucatan/screens/booking_list_screen/components/booking_list_card_type.dart';
import 'package:yucatan/screens/booking_list_screen/components/booking_request_denied_info.dart';
import 'package:yucatan/screens/booking_list_screen/components/booking_ticket_list.dart';
import 'package:yucatan/screens/booking_list_screen/offline_components/booking_list_action_button.dart';
import 'package:yucatan/screens/hotelDetailes/hotelDetailes.dart';
import 'package:yucatan/services/notification_service/navigatable_by_notification.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/size_config.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingOfflineListViewItem extends StatefulWidget {
  final BookingDetailedModel booking;
  final BookingListCardType bookingListCardType;
  final bool online;
  final NotificationActions notificationAction;
  final dynamic notificationData;

  BookingOfflineListViewItem({
    required this.online,
    required this.booking,
    required this.bookingListCardType,
    this.notificationAction,
    this.notificationData,
  });

  @override
  _BookingOfflineListViewItemState createState() =>
      _BookingOfflineListViewItemState();
}

class _BookingOfflineListViewItemState extends State<BookingOfflineListViewItem>
    with NavigatableByNotifcation, AutomaticKeepAliveClientMixin {
  // ActivityModel activity;
  double initialBrightness;

  @override
  initState() {
    initializeDateFormatting('de', null);

    // activity = widget.booking.activity;
    Screen.brightness.then((value) => initialBrightness = value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.notificationAction != null &&
          widget.notificationData != null) {
        handleNavigation(widget.notificationAction, widget.notificationData);
      }
    });

    super.initState();
  }

  @override
  void handleNavigation(
      NotificationActions notificationAction, dynamic notificationData) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      bool handleNotifications =
          sharedPreferences.getBool('handleNotification');

      if (handleNotifications == false) return;

      if (widget.booking.id != notificationData.toString()) return;

      switch (notificationAction) {
        case NotificationActions.USER_SHOW_USABLE_BOOKING:
          if (widget.bookingListCardType == BookingListCardType.USABLE &&
              (widget.booking.status == 'SUCCESS' ||
                  widget.booking.status == 'REQUEST_ACCEPTED')) {
            _showTickets(widget.booking.activity);
          }
          break;
        case NotificationActions.USER_SHOW_DENIED_REQUEST:
          if (widget.bookingListCardType == BookingListCardType.REQUESTED &&
              widget.booking.status == 'REQUEST_DENIED') {
            showDialog(
              context: context,
              builder: (context) => BookingRequestDeniedInfo(
                text: widget.booking.requestNote,
                titleText: AppLocalizations.of(context)
                    .bookingListScreen_requestDenied,
              ),
            );
          }
          break;
        // case NotificationActions.USER_SHOW_REFUNDED_BOOKING:
        //   if (widget.bookingListCardType == BookingListCardType.USABLE &&
        //       widget.booking.id == notificationData.toString() &&
        //       widget.booking.status == 'REFUNDED') {
        //     showDialog(
        //       context: context,
        //       builder: (context) => BookingRequestDeniedInfo(
        //         text: widget.booking.requestNote,
        //       ),
        //     );
        //   }
        //   break;
        default:
      }

      sharedPreferences.setBool('handleNotification', false);
    } catch (exception) {
      print(exception);
    }
  }

  @override
  void didUpdateWidget(covariant BookingOfflineListViewItem oldWidget) {
    // activity = widget.booking.activity;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    //Screen.setBrightness(initialBrightness);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isCardTypeRequest())
          Text(
            '${DateFormat('MMMM yyyy', "de-DE").format(widget.booking.bookingDate)}',
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(18.0),
              color: CustomTheme.primaryColorDark,
            ),
          ),
        if (!_isCardTypeRequest())
          SizedBox(
            height: Dimensions.getScaledSize(10.0),
          ),
        Container(
          width: MediaQuery.of(context).size.width,
          //  margin: EdgeInsets.only(bottom: Dimensions.getScaledSize(20.0)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Dimensions.getScaledSize(24.0),
              ),
            ),
            color: CustomTheme.backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: Dimensions.getScaledSize(6.0),
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.getScaledSize(24.0))),
                          child: Stack(
                            children: [
                              widget.online &&
                                      widget.booking?.activity?.thumbnail
                                              ?.publicUrl !=
                                          null
                                  ? GestureDetector(
                                      onTap: () {
                                        if (widget.online &&
                                            (widget.bookingListCardType ==
                                                    BookingListCardType
                                                        .USABLE ||
                                                widget.bookingListCardType ==
                                                    BookingListCardType.USED)) {
                                          navigateToHotelDetails(
                                              context, widget.booking.activity);
                                        }
                                      },
                                      child: loadCachedNetworkImage(
                                        widget.booking?.activity?.thumbnail
                                            ?.publicUrl,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(),
                              if (_isRequestedOrRefunded())
                                Container(
                                    width: SizeConfig.screenWidth * 0.35,
                                    height: SizeConfig.screenHeight * 0.15,
                                    decoration: BoxDecoration(
                                        color: CustomTheme.lightGrey
                                            .withOpacity(0.8))),
                              if (_isRequestedOrRefunded())
                                Container(
                                  width: SizeConfig.screenWidth * 0.35,
                                  height: SizeConfig.screenHeight * 0.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isRefundedBooking() &&
                                          !(widget.booking.status ==
                                              'REQUEST_DENIED'))
                                        Icon(
                                          Icons.hourglass_empty_outlined,
                                          size: Dimensions.getScaledSize(28.0),
                                          color: CustomTheme.accentColor1,
                                        ),
                                      SizedBox(
                                        height: Dimensions.getScaledSize(5.0),
                                      ),
                                      Text(
                                        _isRefundedBooking()
                                            ? AppLocalizations.of(context)
                                                .commonWords_refunded
                                            : widget.booking.status ==
                                                    'REQUEST_DENIED'
                                                ? AppLocalizations.of(context)
                                                    .bookingListScreen_denied
                                                : AppLocalizations.of(context)
                                                    .bookingListScreen_requestInProgress,
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(14.0),
                                          color: CustomTheme.accentColor1,
                                        ),
                                      ),
                                      if (_isRefundedBooking())
                                        SizedBox(
                                          height:
                                              Dimensions.getScaledSize(10.0),
                                        ),
                                      if (_isRefundedBooking())
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.getScaledSize(
                                                      10.0)),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .bookingListScreen_refundWillBePaid,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      12.0),
                                              color: CustomTheme.accentColor1,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.getScaledSize(10.0),
                              left: Dimensions.getScaledSize(15.0),
                              right: Dimensions.getScaledSize(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.booking.activity.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(13.0),
                                    fontWeight: FontWeight.bold,
                                    color: _isRequestedOrRefunded()
                                        ? CustomTheme.darkGrey.withOpacity(0.5)
                                        : CustomTheme.primaryColorDark,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(2.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BookingListActionButton(
                                      action: () {
                                        if (widget.online)
                                          navigateToHotelDetails(
                                              context, widget.booking.activity);
                                      },
                                      backgroundColor:
                                          CustomTheme.primaryColorLight,
                                      iconColor: CustomTheme.primaryColor,
                                      requestedOrRefunded:
                                          _isRequestedOrRefunded(),
                                      iconData: Icons.info_outlined,
                                      text: AppLocalizations.of(context)
                                          .bookingListScreen_details,
                                    ),
                                    _isAnyTicketUsed()
                                        ? BookingListActionButton(
                                            action: () {
                                              if (widget.online)
                                                _showAddReview(
                                                    widget.booking.activity);
                                            },
                                            backgroundColor:
                                                CustomTheme.accentColor3,
                                            iconColor: CustomTheme.accentColor3,
                                            iconData: Icons.star_border,
                                            text: AppLocalizations.of(context)
                                                .bookingListScreen_addReviewButton,
                                            requestedOrRefunded:
                                                _isRequestedOrRefunded(),
                                          )
                                        : BookingListActionButton(
                                            action: () {
                                              if (widget.online)
                                                _launchMapForActivity(
                                                    widget.booking.activity);
                                            },
                                            text: AppLocalizations.of(context)
                                                .bookingListScreen_navigationButton,
                                            backgroundColor:
                                                CustomTheme.primaryColorLight,
                                            iconColor: CustomTheme.primaryColor,
                                            iconData:
                                                Icons.location_on_outlined,
                                            requestedOrRefunded:
                                                _isRequestedOrRefunded(),
                                          ),
                                    Stack(
                                      children: [
                                        BookingListActionButton(
                                          action: () {
                                            _showTickets(
                                                widget.booking.activity);
                                          },
                                          text: AppLocalizations.of(context)
                                              .commonWords_ticket,
                                          backgroundColor:
                                              CustomTheme.primaryColorLight,
                                          iconColor: CustomTheme.primaryColor,
                                          requestedOrRefunded:
                                              _isRequestedOrRefunded(),
                                          iconData: Icons.loyalty_outlined,
                                        ),
                                        if (_showTicketLabel())
                                          _getTicketsLabel(),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.getScaledSize(10.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dimensions.getScaledSize(10.0),
                      right: Dimensions.getScaledSize(15.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: _isRequestedOrRefunded()
                                    ? CustomTheme.darkGrey.withOpacity(0.5)
                                    : CustomTheme.primaryColor,
                                size: Dimensions.getScaledSize(20.0),
                              ),
                              SizedBox(width: Dimensions.getScaledSize(5.0)),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Dimensions.getScaledSize(3.0)),
                                child: Text(
                                  '${DateFormat('E dd.MM.yyyy', "de-DE").format(widget.booking.bookingDate).replaceFirst('.', ',')}',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(11.0),
                                    color: _isRequestedOrRefunded()
                                        ? CustomTheme.darkGrey.withOpacity(0.5)
                                        : CustomTheme.disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.getScaledSize(3.0),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: _isRequestedOrRefunded()
                                    ? CustomTheme.darkGrey.withOpacity(0.5)
                                    : CustomTheme.primaryColor,
                                size: Dimensions.getScaledSize(20.0),
                              ),
                              SizedBox(
                                width: Dimensions.getScaledSize(3.0),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Text(
                                    '${widget.booking.activity.location.zipcode} ${widget.booking.activity.location.city}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(11.0),
                                      color: _isRequestedOrRefunded()
                                          ? CustomTheme.darkGrey
                                              .withOpacity(0.5)
                                          : CustomTheme.disabledColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.getScaledSize(10.0),
                  ),
                ],
              ),
            ),
            onTap: () async {
              if (widget.booking.status == 'REQUEST_DENIED') {
                showDialog(
                  context: context,
                  builder: (context) => BookingRequestDeniedInfo(
                    text: widget.booking.requestNote,
                    titleText: AppLocalizations.of(context)
                        .bookingListScreen_requestDenied,
                  ),
                );
              } else if (widget.booking.status == 'REQUEST') {
                showDialog(
                  context: context,
                  builder: (context) => BookingRequestDeniedInfo(
                    text: AppLocalizations.of(context)
                        .bookingListScreen_vendorWillRespondeSoon,
                    titleText: AppLocalizations.of(context)
                        .bookingListScreen_requestInProgress,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  bool _isAnyTicketUsed() {
    return widget.booking.tickets.any((element) => element.status == "USED");
  }

  bool _isRequestedOrRefunded() {
    return _isCardTypeRequest() || _isRefundedBooking();
  }

  bool _isCardTypeRequest() {
    return widget.bookingListCardType == BookingListCardType.REQUESTED;
  }

  bool _isRefundedBooking() {
    return widget.booking.status == 'REFUNDED';
  }

  bool _showTicketLabel() {
    return _getOpenTicketsForBooking(widget.booking) > 0 &&
        !_isCardTypeRequest();
  }

  void _showTickets(ActivityModel activity) {
    FocusScope.of(context).requestFocus(FocusNode());
    Screen.setBrightness(1);
    showDialog(
      context: context,
      builder: (BuildContext context) => BookingTicketList(
          offline: !widget.online,
          booking: widget.booking.toBookingModel(),
          activity: activity,
          initialBrightness: initialBrightness),
    ).then((value) => Screen.setBrightness(initialBrightness));
  }

  _getTicketsLabel() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        height: Dimensions.getScaledSize(20.0),
        width: Dimensions.getScaledSize(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              Dimensions.getScaledSize(100.0),
            ),
          ),
          color: CustomTheme.accentColor1,
        ),
        child: Center(
          child: Text(
            _getOpenTicketsForBooking(
              widget.booking,
            ).toString(),
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(11.0),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddReview(ActivityModel activityToPass) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await showDialog(
      context: context,
      builder: (BuildContext context) => BookingAddReviewView(
        activity: activityToPass,
      ),
    ).then((value) {
      if (value != null) {
        widget.booking.activity = value.data;
      }
    }, onError: (sacktrace) {});
  }

  int _getOpenTicketsForBooking(BookingDetailedModel booking) {
    int openTickets = 0;

    booking.tickets.forEach((element) {
      if (element.status == "USABLE") {
        openTickets += 1;
      }
    });

    return openTickets;
  }

  void _launchMapForActivity(ActivityModel activity) async {
    final availableMaps = await MapLauncher.installedMaps;
    final coords = Coords(double.parse(activity.location.lat),
        double.parse(activity.location.lon));

    availableMaps.first.showDirections(
      destination: coords,
      destinationTitle: activity.title,
    );
  }

  navigateToHotelDetails(BuildContext context, ActivityModel data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HotelDetailes(
          isFavorite: false,
          //hotelData: data,
          activityId: data.sId,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

// void _updateActivity(ActivitySingleResponse activitySingleResponse){
//   activity = Future.value(activitySingleResponse);
// }
}

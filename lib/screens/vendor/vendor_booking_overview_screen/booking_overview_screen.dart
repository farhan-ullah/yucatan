import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_row.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_request_preview.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/vendor_booking_details_modal.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'dart:convert';

import 'package:yucatan/models/transaction_model.dart';
import 'package:yucatan/screens/booking/components/calendarPopupView.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_date_button.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_loading_indicator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_overview_screen_parameter.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_overview_tab.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_model.dart';
import 'package:yucatan/services/notification_service/models/vendor_show_refunded_booking_model.dart';
import 'package:yucatan/services/notification_service/models/vendor_show_request_model.dart';
import 'package:yucatan/services/notification_service/navigatable_by_notification.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/services/response/transaction_multi_response_entity.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/datefulWidget/DateStatefulWidget.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/image_util.dart';
import 'package:yucatan/utils/network_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'components/booking_categories.dart';

enum SelectedDate {
  NONE,
  TODAY,
  TOMORROW,
  CUSTOM,
  WEEK,
}

class VendorBookingOverviewScreen extends DateStatefulWidget {
  static const route = '/vendorbookingoverview';

  final NotificationActions notificationAction;
  final dynamic notificationData;

  VendorBookingOverviewScreen({
    this.notificationAction,
    this.notificationData,
  });

  @override
  createState() => _VendorBookingOverviewScreenState();
}

class _VendorBookingOverviewScreenState
    extends DateState<VendorBookingOverviewScreen>
    with NavigatableByNotifcation {
  final Color anfrageColor = Color(0xFF0071B8);
  final Color offenColor = CustomTheme.accentColor2;
  final Color storniertColor = CustomTheme.accentColor1;
  final Color eingelostColor = Color(0xFF8B8B8B);

  SelectedDate _selectedDate;
  Category _category;
  TransactionModel _selectedModel;
  bool _firstOpen = true;

  Future<TransactionMultiResponseEntity> transactions;
  bool isNetworkAvailable = true;

  @override
  void initState() {
    initializeDateFormatting('de', null);
    GlobalDate.setToday();

    _selectedDate = SelectedDate.TODAY;
    _category = Category.USABLE;

    NetworkUtils.isNetworkAvailable().then((isNetworkAvailable) {
      this.isNetworkAvailable = isNetworkAvailable;
      setState(() {});
    });

    _getTransactions(true);

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
    final sharedPreferences = await SharedPreferences.getInstance();

    bool handleNotifications = sharedPreferences.getBool('handleNotification');
    try {
      if (handleNotifications == false) return;

      switch (notificationAction) {
        case NotificationActions.VENDOR_SHOW_REQUEST:
          _handleNavigationVendorShowRequest(
              notificationAction, notificationData);
          break;
        case NotificationActions.VENDOR_SHOW_REFUNDED_BOOKING:
          _handleNavigationVendorShowRefundedBooking(
              notificationAction, notificationData);
          break;
        default:
      }
    } catch (exception) {
      print(exception);
    }

    sharedPreferences.setBool('handleNotification', false);
  }

  ///Handle navigation for VENDOR_SHOW_REQUEST action
  void _handleNavigationVendorShowRequest(
      NotificationActions notificationAction, dynamic notificationData) async {
    var parsedNotificationData =
        VendorShowRequestModel.fromJson(json.decode(notificationData));

    if (parsedNotificationData.bookingId == null) return;
    if (parsedNotificationData.bookingDate == null) return;

    _setCategory(Category.REQUESTED);

    GlobalDate.set(parsedNotificationData.bookingDate);
    setState(() {
      onDateChanged(parsedNotificationData.bookingDate);
    });
    _getTransactions(true);

    var transactionData = await transactions;

    bool checkRedirection;
    var transactionObject;
    var transactionModel = transactionData.data.firstWhere(
      (transactionDataElement) {
        checkRedirection = transactionDataElement.bookingId ==
                    parsedNotificationData.bookingId &&
                transactionDataElement.bookingState == "SUCCESS"
            ? true
            : false;
        if (checkRedirection) {
          transactionObject = transactionDataElement;
        }
        return transactionDataElement.bookingId ==
                parsedNotificationData.bookingId &&
            isSameStatus(transactionDataElement, notificationAction);
      },
      orElse: () => null,
    );

    if (transactionModel == null) {
      bool isTicketStateUSABLE = false;
      bool isTicketStateUSED = false;
      if (checkRedirection) {
        //if at least 1 is USABLE ticket state, direct to Offen AND if all are USED, redirect to Eingelöst
        TransactionModel transactionModelObj = transactionObject;
        for (int i = 0; i < transactionModelObj.tickets.length; i++) {
          if (transactionModelObj.tickets[i].state.trim() == "USABLE") {
            isTicketStateUSABLE = true;
            break;
          }
          if (transactionModelObj.tickets[i].state.trim() == "USED") {
            isTicketStateUSED = true;
          } else {
            isTicketStateUSED = false;
          }
        }
      }
      if (isTicketStateUSABLE) {
        _getTransactions(true);
        _setCategory(Category.USABLE);
      } else {
        if (isTicketStateUSED) {
          _getTransactions(true);
          _setCategory(Category.USED);
        }
      }
      transactionModel = transactionObject;
    }

    if (transactionModel == null) return;
    Future.delayed(Duration(milliseconds: 500), () {
      if (_category == Category.REQUESTED) {
        _selectModel(transactionModel);
        return;
      }

      _showTicketList(
        VendorBookingPreviewModel(
          buyer: transactionModel.buyer,
          dateTime: transactionModel.dateTime,
          tickets: transactionModel.tickets.length.toString(),
          totalPrice: transactionModel.totalPrice,
          transactionModel: transactionModel,
          ticketList: transactionModel.tickets,
        ),
      );
    });
  }

  isSameStatus(TransactionModel transactionModel,
      NotificationActions notificationAction) {
    return transactionModel.bookingState ==
        getMatchingStatus(notificationAction);
  }

  String getMatchingStatus(NotificationActions notificationActions) {
    switch (notificationActions) {
      case NotificationActions.NONE:
        return "";
      case NotificationActions.VENDOR_SHOW_REQUEST:
        return "REQUEST";
      case NotificationActions.VENDOR_SHOW_REFUNDED_BOOKING:
        return "REFUNDED";
      default:
        return "";
    }
  }

  ///Handle navigation for VENDOR_SHOW_REFUNDED_BOOKING action
  void _handleNavigationVendorShowRefundedBooking(
      NotificationActions notificationAction, dynamic notificationData) async {
    var parsedNotificationData =
        VendorShowRefundedBookindModel.fromJson(json.decode(notificationData));

    if (parsedNotificationData.bookingId == null) return;
    if (parsedNotificationData.bookingDate == null) return;

    _setCategory(Category.REFUNDED);

    GlobalDate.set(parsedNotificationData.bookingDate);
    setState(() {
      onDateChanged(parsedNotificationData.bookingDate);
    });

    _getTransactions(true);

    var transactionData = await transactions;

    bool checkRedirection = false;
    var transactionObject;
    var transactionModel = transactionData.data.firstWhere(
      (transactionDataElement) {
        if (transactionDataElement.bookingId.trim() ==
                parsedNotificationData.bookingId.trim() &&
            transactionDataElement.bookingState.trim() == "SUCCESS") {
          checkRedirection = true;
          transactionObject = transactionDataElement;
        }
        return transactionDataElement.bookingId ==
                parsedNotificationData.bookingId &&
            isSameStatus(transactionDataElement, notificationAction);
      },
      orElse: () => null,
    );

    if (transactionModel == null) {
      bool isTicketStateRefund = false;
      if (checkRedirection) {
        TransactionModel transactionModelObj = transactionObject;
        for (int i = 0; i < transactionModelObj.tickets.length; i++) {
          if (transactionModelObj.tickets[i].state.trim() == "REFUNDED") {
            isTicketStateRefund = true;
            break;
          }
        }
      }
      if (isTicketStateRefund) {
        transactionModel = transactionObject;
      }
    }

    if (transactionModel == null) return;

    Future.delayed(Duration(milliseconds: 500), () {
      _showTicketList(
        VendorBookingPreviewModel(
          buyer: transactionModel.buyer,
          dateTime: transactionModel.dateTime,
          tickets: transactionModel.tickets.length.toString(),
          totalPrice: transactionModel.totalPrice,
          transactionModel: transactionModel,
          ticketList: transactionModel.tickets,
        ),
      );
    });
  }

  void requestAccepted() {
    _getTransactions(true);
    _setCategory(Category.USABLE);
  }

  void requestDenied() {
    _getTransactions(true);
    _setCategory(Category.REQUESTED);
  }

  void requestFailed() {
    _getTransactions(true);
    _setCategory(Category.REQUESTED);
  }

  _selectModel(TransactionModel transactionModel) {
    setState(() {
      _selectedModel = transactionModel;
    });
  }

  _setModelToNull() {
    setState(() {
      _selectedModel = null;
    });
  }

  bool _isRequested(TransactionModel transactionModel) {
    return transactionModel.bookingState == "REQUEST";
  }

  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;

    final BookingOverviewScreenParameter arguments =
        ModalRoute.of(context).settings.arguments;

    int buttonIndex = 0;

    if (arguments != null) {
      buttonIndex = arguments.buttonIndex;
    }

    if (_firstOpen) {
      _firstOpen = false;

      _category = arguments.category ?? Category.USABLE;

      switch (buttonIndex) {
        case -1:
          _selectedDate = SelectedDate.NONE;
          _getTransactions(false);
          break;
        case 0:
          _selectedDate = SelectedDate.TODAY;
          _getTransactions(false);
          break;
        case 1:
          _selectedDate = SelectedDate.TOMORROW;
          _getTransactions(false);
          break;
        case 2:
          _selectedDate = SelectedDate.WEEK;
          _getTransactions(false);
          break;
        case 3:
          _selectedDate = SelectedDate.CUSTOM;
          Future.delayed(
            Duration(milliseconds: 150),
            () {
              _selectCustomDate();
            },
          );
          break;
        default:
          _selectedDate = SelectedDate.TODAY;
      }
    }

    return Scaffold(
      backgroundColor: isNetworkAvailable ? Color(0xFFBDD4E1) : Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vendor_bookingOverview_title),
        centerTitle: true,
        actions: [
          Container(
            margin:
                EdgeInsets.fromLTRB(0, 0, Dimensions.getScaledSize(20.0), 0),
            child: NotificationView(
              negativePadding: false,
            ),
          ),
        ],
      ),
      body: isNetworkAvailable
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.05 * displayWidth),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.getScaledSize(20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VendorBookingDateButton(
                          text: AppLocalizations.of(context)!.today,
                          onTap: () => _selectedDateChanges(SelectedDate.TODAY),
                          selected: _selectedDate == SelectedDate.TODAY,
                          fontSize: Dimensions.getScaledSize(14.0),
                          height: Dimensions.getScaledSize(40.0),
                          width: double.infinity,
                          color: anfrageColor),
                      SizedBox(width: Dimensions.getScaledSize(8.0)),
                      VendorBookingDateButton(
                          text: AppLocalizations.of(context)!.tomorrow,
                          onTap: () =>
                              _selectedDateChanges(SelectedDate.TOMORROW),
                          selected: _selectedDate == SelectedDate.TOMORROW,
                          fontSize: Dimensions.getScaledSize(14.0),
                          height: Dimensions.getScaledSize(40.0),
                          width: double.infinity,
                          color: anfrageColor),
                      SizedBox(width: Dimensions.getScaledSize(8.0)),
                      VendorBookingDateButton(
                          text: AppLocalizations.of(context)!.commonWords_week,
                          onTap: () => _selectedDateChanges(SelectedDate.WEEK),
                          selected: _selectedDate == SelectedDate.WEEK,
                          fontSize: Dimensions.getScaledSize(14.0),
                          height: Dimensions.getScaledSize(40.0),
                          width: double.infinity,
                          color: anfrageColor),
                      SizedBox(width: Dimensions.getScaledSize(8.0)),
                      GestureDetector(
                        onTap: () {
                          _selectCustomDate();
                        },
                        child: Container(
                          height: Dimensions.getScaledSize(40.0),
                          width: displayWidth * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: CustomTheme.primaryColorDark,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'lib/assets/images/calendar.svg',
                              color: Colors.white,
                              height: 25,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.getScaledSize(20.0)),
                  Row(
                    children: [
                      VendorBookingOverviewTab(
                        text: AppLocalizations.of(context)!.commonWords_request,
                        color: anfrageColor,
                        fontSize: Dimensions.getScaledSize(13.0),
                        height: Dimensions.getScaledSize(52.0),
                        selected: _category == Category.REQUESTED,
                        onTap: () => _setCategory(Category.REQUESTED),
                      ),
                      SizedBox(width: Dimensions.getScaledSize(2.0)),
                      VendorBookingOverviewTab(
                        text: AppLocalizations.of(context)!.commonWords_usable,
                        color: offenColor,
                        fontSize: Dimensions.getScaledSize(13.0),
                        height: Dimensions.getScaledSize(52.0),
                        selected: _category == Category.USABLE,
                        onTap: () => _setCategory(Category.USABLE),
                      ),
                      SizedBox(width: Dimensions.getScaledSize(2.0)),
                      VendorBookingOverviewTab(
                        text: AppLocalizations.of(context)!.commonWords_used,
                        color: eingelostColor,
                        fontSize: Dimensions.getScaledSize(13.0),
                        height: Dimensions.getScaledSize(52.0),
                        selected: _category == Category.USED,
                        onTap: () => _setCategory(Category.USED),
                      ),
                      SizedBox(width: Dimensions.getScaledSize(2.0)),
                      VendorBookingOverviewTab(
                        text:
                            AppLocalizations.of(context)!.commonWords_refunded,
                        color: storniertColor,
                        fontSize: Dimensions.getScaledSize(13.0),
                        height: Dimensions.getScaledSize(52.0),
                        selected: _category == Category.REFUNDED,
                        onTap: () => _setCategory(Category.REFUNDED),
                      ),
                    ],
                  ),
                  if (_selectedModel == null)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white)),
                      padding: EdgeInsets.only(
                          // left: displayWidth * 0.04,
                          // right: displayWidth * 0.04,
                          top: 0.01 * displayHeight),
                      height: 0.035 * displayHeight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayWidth * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .vendor_table_date,
                                  style: _getListViewHeaderStyle(
                                      fontSize:
                                          Dimensions.getScaledSize(12.0))),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .vendor_table_count,
                                    style: _getListViewHeaderStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(12.0)))),
                            Expanded(
                                flex: 6,
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .vendor_table_customer,
                                    style: _getListViewHeaderStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(12.0)))),
                            Expanded(
                              flex: 3,
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .vendor_table_amount("€"),
                                  style: _getListViewHeaderStyle(
                                      fontSize:
                                          Dimensions.getScaledSize(12.0))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: displayWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: _selectedModel == null
                          ? FutureBuilder<TransactionMultiResponseEntity>(
                              future: transactions,
                              builder: (context, snapshotTransactions) {
                                if (snapshotTransactions.connectionState ==
                                    ConnectionState.waiting)
                                  return VendorBookingLoadingIndicator();
                                if (snapshotTransactions.hasData) {
                                  if (snapshotTransactions.data.data == null) {
                                    return Center(
                                      child: Text(AppLocalizations.of(context)
                                          .vendor_table_noBookings),
                                    );
                                  }
                                  final transactionsToDisplay =
                                      _filterByCategory(
                                          snapshotTransactions.data.data);
                                  if (transactionsToDisplay.length == 0)
                                    return _getNoBookingsMessage(
                                        displayWidth,
                                        displayHeight,
                                        AppLocalizations.of(context)!
                                            .vendor_table_noBookings);

                                  return RefreshIndicator(
                                    child: ListView.separated(
                                        padding: EdgeInsets.only(
                                            bottom: displayHeight * 0.01),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return VendorBookingPreviewRow(
                                            transaction: transactionsToDisplay
                                                .elementAt(index),
                                            color: anfrageColor,
                                            onTap: _isRequested(
                                                    transactionsToDisplay
                                                        .elementAt(index)
                                                        .transactionModel)
                                                ? () => _selectModel(
                                                    transactionsToDisplay
                                                        .elementAt(index)
                                                        .transactionModel)
                                                : () => _showTicketList(
                                                    transactionsToDisplay
                                                        .elementAt(index)),
                                            height: 0.033 * displayHeight,
                                            fontSize: 0.015 * displayHeight,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            thickness: 1,
                                          );
                                        },
                                        itemCount:
                                            transactionsToDisplay.length),
                                    onRefresh: () async {
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      _getTransactions(true);
                                    },
                                  );
                                }
                                if (snapshotTransactions.hasError)
                                  return _getNoBookingsMessage(
                                      displayWidth,
                                      displayHeight,
                                      AppLocalizations.of(context)
                                          .commonWords_error);
                                return VendorBookingLoadingIndicator();
                              },
                            )
                          : VendorBookingRequestPreview(
                              transactionModel: _selectedModel,
                              requestAccepted: requestAccepted,
                              requestDenied: requestDenied,
                              requestFailed: requestFailed,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom +
                        Dimensions.getScaledSize(20.0),
                  ),
                ],
              ),
            )
          : ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
              bool isNetworkAvailable = await NetworkUtils.isNetworkAvailable();
              this.isNetworkAvailable = isNetworkAvailable;
              if (isNetworkAvailable) {
                _getTransactions(true);
              }
            }),
    );
  }

  _getTransactions(bool refresh) {
    DateTime dateFrom;
    DateTime dateTo;
    DateTime now = DateTime.now();
    switch (_selectedDate) {
      case SelectedDate.NONE:
        dateFrom = DateTime(now.year, now.month, now.day);
        dateFrom = dateFrom.subtract(Duration(days: 730));
        dateTo =
            DateTime(now.year, now.month, now.day).add(Duration(days: 730));
        break;
      case SelectedDate.TODAY:
        dateFrom = DateTime(now.year, now.month, now.day);
        dateTo = DateTime(now.year, now.month, now.day);
        break;
      case SelectedDate.TOMORROW:
        dateFrom =
            DateTime(now.year, now.month, now.day).add(Duration(days: 1));
        dateTo = dateFrom;
        break;
      case SelectedDate.CUSTOM:
        dateFrom = DateTime(GlobalDate.current().year,
            GlobalDate.current().month, GlobalDate.current().day);
        dateTo = dateFrom;
        break;
      case SelectedDate.WEEK:
        dateFrom = DateTime(now.year, now.month, now.day);
        dateTo = dateFrom.add(Duration(days: 7));
        break;
      default:
        dateFrom = DateTime(now.year, now.month, now.day);
        dateTo = dateFrom.add(Duration(days: 365));
        break;
    }
    _setModelToNull();
    if (refresh) {
      setState(() {
        transactions = null;
        transactions = BookingService.getTransactionsForDateRange(
            dateFrom: dateFrom, dateTo: dateTo);
      });
    } else {
      transactions = null;
      transactions = BookingService.getTransactionsForDateRange(
          dateFrom: dateFrom, dateTo: dateTo);
    }
  }

  _getNoBookingsMessage(
      double displayWidth, double displayHeight, String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: displayWidth * 0.03, vertical: 0.2 * displayHeight),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "AcuminProWide",
              color: anfrageColor,
              fontSize: displayHeight * 0.02,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _getListViewHeaderStyle({double fontSize}) {
    return TextStyle(
        fontFamily: "AcuminProWide",
        color: _getCurrentColor(),
        fontSize: fontSize,
        fontWeight: FontWeight.bold);
  }

  _getCurrentColor() {
    switch (_category) {
      case Category.REQUESTED:
        return anfrageColor;
      case Category.USABLE:
        return offenColor;
      case Category.USED:
        return eingelostColor;
      case Category.REFUNDED:
        return storniertColor;
    }
    return anfrageColor;
  }

  _setCategory(Category category) {
    _setModelToNull();
    setState(() {
      _category = category;
    });
  }

  @override
  onDateChanged(DateTime dateTime) {
    if (!mounted) {
      return;
    }

    setState(() {
      if (dateTime == null) {
        _selectedDate = SelectedDate.NONE;
      } else if (GlobalDate.isToday(dateTime) &&
          _selectedDate != SelectedDate.WEEK) {
        _selectedDate = SelectedDate.TODAY;
      } else if (GlobalDate.isTomorrow(dateTime)) {
        _selectedDate = SelectedDate.TOMORROW;
      } else if (!GlobalDate.isToday(dateTime)) {
        _selectedDate = SelectedDate.CUSTOM;
      }
    });
  }

  void _selectedDateChanges(SelectedDate selectedDate) {
    if (!mounted) {
      return;
    }

    setState(() {
      if (_selectedDate == selectedDate) {
        _selectedDate = SelectedDate.NONE;
      } else {
        _selectedDate = selectedDate;
      }
    });

    if (_selectedDate == SelectedDate.NONE) {
      GlobalDate.set(null);
    }
    if (_selectedDate == SelectedDate.TODAY) {
      GlobalDate.setToday();
    } else if (_selectedDate == SelectedDate.TOMORROW) {
      GlobalDate.setTomorrow();
    } else if (_selectedDate == SelectedDate.WEEK) {
      GlobalDate.setToday();
    }
    _getTransactions(true);
  }

  void _selectCustomDate() {
    FocusScope.of(context).requestFocus(FocusNode());
    _showDateSelectorDialog(context: context);
  }

  void _showDateSelectorDialog({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now().subtract(Duration(days: 730)),
        initialDate: GlobalDate.current(),
        onApplyClick: (DateTime date) {
          setState(() {
            if (date != null) {
              GlobalDate.set(date);
              _selectedDate = SelectedDate.CUSTOM;
              onDateChanged(date);
              _getTransactions(true);
            }
          });
        },
        onCancelClick: () {
          _selectedDate = SelectedDate.NONE;
        },
        usedForVendor: true,
      ),
    );
  }

  _showTicketList(VendorBookingPreviewModel bookingPreviewModel) {
    if (bookingPreviewModel.transactionModel.bookingState != "REQUEST" &&
        bookingPreviewModel.transactionModel.bookingState != "REQUEST_DENIED")
      showDialog(
        context: context,
        builder: (context) {
          return VendorBookingDetailsModal(
            vendorBookingPreviewModel: bookingPreviewModel,
            category: _category,
            refresh: () {
              _getTransactions(true);
            },
          );
        },
      );
  }

  bool isBookingCategoryEqual(TransactionModel transaction) {
    bool equalCategory = false;
    /*DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);*/
    switch (_category) {
      case Category.REQUESTED:
        // if (_selectedDate == SelectedDate.NONE)
        //   equalCategory = transaction.bookingState == "REQUEST" &&
        //           transaction.dateTime.isAfter(now) ||
        //       transaction.bookingState == "REQUEST_DENIED";
        // else
        equalCategory = transaction.bookingState == "REQUEST" ||
            transaction.bookingState == "REQUEST_DENIED";
        break;
      case Category.USABLE:
        equalCategory = transaction.bookingState == "SUCCESS" ||
            transaction.bookingState == "REQUEST_ACCEPTED";
        // if (_selectedDate == SelectedDate.NONE) {
        //   equalCategory = equalCategory && transaction.dateTime.isAfter(now);
        // }
        break;

      case Category.USED:
        equalCategory = transaction.bookingState == "SUCCESS" ||
            transaction.bookingState == "REQUEST_ACCEPTED";
        // if (_selectedDate == SelectedDate.NONE) {
        //   equalCategory = equalCategory && transaction.dateTime.isAfter(now);
        // }
        break;

      case Category.REFUNDED:
        equalCategory = transaction.bookingState == "SUCCESS" ||
            transaction.bookingState == "REQUEST_ACCEPTED" ||
            transaction.bookingState == "REFUNDED";
        // if (_selectedDate == SelectedDate.NONE)
        //   equalCategory = equalCategory && transaction.dateTime.isAfter(now);
        break;
    }
    return equalCategory;
  }

  List<VendorBookingPreviewModel> _filterByCategory(
      List<TransactionModel> bookings) {
    List<VendorBookingPreviewModel> bookingPreviewModels = [];
    final filterdTranasctions =
        bookings.where((element) => isBookingCategoryEqual(element)).toList();

    filterdTranasctions.forEach((transaction) {
      double totalPrice = 0;
      int numberOfTickets = 0;
      List<TransactionTicket> ticketsList = [];
      switch (_category) {
        case Category.REQUESTED:
          numberOfTickets = transaction.tickets.length;
          totalPrice = transaction.totalPrice;
          ticketsList.addAll(transaction.tickets);
          break;
        case Category.USABLE:
          transaction.tickets.forEach((ticket) {
            if (ticket.state == "USABLE") {
              numberOfTickets += 1;
              totalPrice += ticket.price;
              ticketsList.add(ticket);
            }
          });
          break;
        case Category.USED:
          transaction.tickets.forEach((ticket) {
            if (ticket.state == "USED") {
              numberOfTickets += 1;
              totalPrice += ticket.price;
              ticketsList.add(ticket);
            }
          });
          break;

        case Category.REFUNDED:
          if (transaction.bookingState == "SUCCESS")
            transaction.tickets.forEach((ticket) {
              if (ticket.state == "REFUNDED") {
                numberOfTickets += 1;
                totalPrice += ticket.price;
                ticketsList.add(ticket);
              }
            });
          else if (transaction.bookingState == "REFUNDED") {
            numberOfTickets = transaction.tickets.length;
            totalPrice = transaction.totalPrice;
            ticketsList.addAll(transaction.tickets);
          }
          break;
      }

      if (numberOfTickets > 0)
        bookingPreviewModels.add(VendorBookingPreviewModel(
            buyer: transaction.buyer,
            dateTime: transaction.dateTime,
            tickets: numberOfTickets.toString(),
            totalPrice: totalPrice,
            transactionModel: transaction,
            ticketList: ticketsList));
    });

    return bookingPreviewModels;
  }
}

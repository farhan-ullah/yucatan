import 'dart:io';

import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/components/custom_error_screen.dart';
import 'package:yucatan/components/payment_processing_screen.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/models/schedule_notification.dart';
import 'package:yucatan/screens/checkout_screen/checkout_screen.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/payment_credit_card_screen/payment_credit_card_screen.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/notification_service/notification_service.dart';
import 'package:yucatan/services/response/payment_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Future<PaymentResponse> future;
  final ActivityModel activity;
  final bool isPaypal;
  final List<OrderProduct> order;

  PaymentSuccessScreen({
    required this.future,
    required this.activity,
    required this.order,
    this.isPaypal,
  });

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool requestRequired = false;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    _requestRequestForBooking().then((requestRequired) {
      /*setState(() {
      });*/
      this.requestRequired = requestRequired;
    });
  }

  Future<bool> _requestRequestForBooking() async {
    bool requestRequired = false;
    widget.order.forEach((productElement) {
      Product product = _findProduct(productElement.id);
      if (product.requestRequired) {
        requestRequired = true;
      }
    });
    return requestRequired;
  }

  Product _findProduct(String productId) {
    Product product;
    widget.activity.bookingDetails.productCategories.forEach(
      (productCategoryElement) {
        productCategoryElement.products.forEach(
          (productElement) {
            if (productElement.id == productId) {
              product = productElement;
            }
          },
        );
        productCategoryElement.productSubCategories.forEach(
          (productSubCategoryElement) {
            productSubCategoryElement.products.forEach(
              (productElement) {
                if (productElement.id == productId) {
                  product = productElement;
                }
              },
            );
          },
        );
      },
    );
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: FutureBuilder<PaymentResponse>(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.success) {
              //Log firebase event
              if (kReleaseMode && firstBuild) {
                firstBuild = false;
                AnalyticsService.logPurchaseCompleted(snapshot.data.booking);
              }

              _giveFeedback();
              _scheduleLocalNotification(snapshot.data.booking);
            }
            return Scaffold(
              body: snapshot.data.success
                  ? Stack(
                      children: [
                        CustomErrorEmptyScreen(
                          title: AppLocalizations.of(context)
                              .paymentCreditCardScreen_wellDone,
                          description: requestRequired
                              ? AppLocalizations.of(context)
                                  .paymentCreditCardScreen_requestReceived
                              : AppLocalizations.of(context)
                                  .paymentCreditCardScreen_bookingReceived,
                          image: 'lib/assets/images/success.png',
                          showButton: false,
                          customText: requestRequired
                              ? AppLocalizations.of(context)
                                  .paymentCreditCardScreen_willReceiveTicketsRequested
                              : AppLocalizations.of(context)
                                  .paymentCreditCardScreen_willReceiveTicketsBooking,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Column(
                            children: [
                              ColoredDivider(
                                height: Dimensions.getScaledSize(3.0),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: Dimensions.getScaledSize(60.0) +
                                    MediaQuery.of(context).padding.bottom,
                                padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).padding.bottom),
                                color: CustomTheme.primaryColorDark,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: Dimensions.getScaledSize(20.0),
                                    right: Dimensions.getScaledSize(20.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _navigateToBookingList(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: Dimensions.getScaledSize(
                                                  12.0),
                                              bottom: Dimensions.getScaledSize(
                                                  12.0),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  CustomTheme.borderRadius,
                                                ),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: Dimensions
                                                        .getScaledSize(2.0)),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .paymentCreditCardScreen_bookings,
                                                  style: TextStyle(
                                                    fontSize: Dimensions
                                                        .getScaledSize(20.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: CustomTheme
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimensions.getScaledSize(30.0),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _navigateToHomeScreen(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: Dimensions.getScaledSize(
                                                  12.0),
                                              bottom: Dimensions.getScaledSize(
                                                  12.0),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  CustomTheme.borderRadius,
                                                ),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: Dimensions
                                                        .getScaledSize(2.0)),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .paymentCreditCardScreen_startSite,
                                                  style: TextStyle(
                                                    fontSize: Dimensions
                                                        .getScaledSize(20.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: CustomTheme
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : CustomErrorEmptyScreen(
                      titleColor: snapshot.data.success
                          ? CustomTheme.primaryColorDark
                          : CustomTheme.accentColor1,
                      title: snapshot.data.success
                          ? AppLocalizations.of(context)
                              .paymentCreditCardScreen_thankYou
                          : AppLocalizations.of(context)
                              .paymentCreditCardScreen_mistake,
                      description: snapshot.data.success
                          ? AppLocalizations.of(context)
                              .paymentCreditCardScreen_paymentReceivedSuccess
                          : AppLocalizations.of(context)
                              .paymentCreditCardScreen_paymentReceivedError,
                      image: snapshot.data.success
                          ? 'lib/assets/images/success.png'
                          : 'lib/assets/images/error.png',
                      customText: snapshot.data.success
                          ? AppLocalizations.of(context)
                              .paymentCreditCardScreen_bookingCompleted
                          : AppLocalizations.of(context)
                              .paymentCreditCardScreen_bookingNotCompleted,
                      customButtonText: snapshot.data.success
                          ? AppLocalizations.of(context)
                              .paymentCreditCardScreen_goToBookings
                          : AppLocalizations.of(context)
                              .paymentCreditCardScreen_tryAgain,
                      callback: () {
                        if (snapshot.data.success) {
                          _navigateToBookingList(context);
                        } else {
                          _navigateBack(context);
                        }
                      },
                    ),
              appBar: AppBar(
                title: Center(
                  child: Text(
                    snapshot.data.success
                        ? AppLocalizations.of(context)
                            .paymentCreditCardScreen_paymentSuccess
                        : AppLocalizations.of(context)
                            .paymentCreditCardScreen_paymentError,
                  ),
                ),
                backgroundColor: CustomTheme.primaryColorDark,
                elevation: 0,
                leading: Container(),
                leadingWidth: 0,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return PaymentProcessingScreen();
        },
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  _navigateToBookingList(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(MainScreen.route));
    Navigator.of(context).pushReplacementNamed(
      MainScreen.route,
      arguments: MainScreenParameter(
          bottomNavigationBarIndex: 1,
          isBookingRequestType: this.requestRequired),
    );
  }

  _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(MainScreen.route));
    Navigator.of(context).pushReplacementNamed(
      MainScreen.route,
      arguments: MainScreenParameter(
        bottomNavigationBarIndex: 0,
      ),
    );
  }

  _navigateBack(BuildContext context) {
    if (widget.isPaypal == true) {
      Navigator.of(context).popUntil(ModalRoute.withName(CheckoutScreen.route));
      return;
    } else
      Navigator.of(context)
          .popUntil(ModalRoute.withName(PaymentCreditCardScreen.route));
  }

  _giveFeedback() {
    Vibrate.feedback(FeedbackType.success);

    if (Platform.isIOS) return;

    final AudioCache player = new AudioCache();
    player.play('audio/payment_success.wav');
  }

  void _scheduleLocalNotification(BookingModel booking) async {
    DateTime notificationDate = booking.bookingDate;
    var bookingTimeStrings =
        booking.tickets.map((e) => e.bookingTimeString).toSet().toList();

    bookingTimeStrings.forEach((element) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      int counter = (sharedPreferences.getInt('notificationId') ?? 0) + 1;
      sharedPreferences.setInt('notificationId', counter);

      DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
      String time = element;
      if (!isNotNullOrEmpty(time)) {
        widget.activity.openingHours?.regularOpeningHours?.forEach((hrs) {
          hrs.openingHours.forEach((element1) {
            if (isNotNullOrEmpty(element1.start)) {
              time = element1.start;
            }
          });
        });

        if (!isNotNullOrEmpty(time)) {
          widget.activity.openingHours?.specialOpeningHours?.forEach((hrs) {
            hrs.openingHours.forEach((element1) {
              if (isNotNullOrEmpty(element1.start)) {
                time = element1.start;
              }
            });
          });
        }
      }

      String scheduleDateTime = '${dateFormat.format(notificationDate)} $time';

      DateTime dateTime = DateTime.parse(scheduleDateTime);

      print('ScheduleDateTime:: ${dateTime.toString()}');

      ScheduleNotification scheduleNotification = ScheduleNotification(
          booking.id,
          booking.activity,
          dateTime.subtract(const Duration(hours: 2)),
          counter);
      HiveService.setScheduledNotification(scheduleNotification);
      NotificationService.initialize(null).then((value) {
        try {
          value.scheduleNotification(scheduleNotification);
          print(
              'Notification:: Scheduled Notification at ${scheduleNotification.dateTime}');
        } catch (e) {
          print(e);
        }
      });
    });
  }
}

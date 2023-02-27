import 'package:appventure/components/custom_app_bar.dart';
import 'package:appventure/components/dashed_divider.dart';
import 'package:appventure/models/activity_model.dart';
import 'package:appventure/models/order_model.dart';
import 'package:appventure/screens/booking/components/booking_bar.dart';
import 'package:appventure/screens/inquiry/components/inquiry_screen_parameter.dart';
import 'package:appventure/screens/payment_credit_card_screen/components/payment_credit_card_screen_parameter.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/rive_animation.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InquiryScreen extends StatefulWidget {
  static const route = '/inquiry';

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  bool _showInfoContainer = false;

  @override
  Widget build(BuildContext context) {
    final InquiryScreenParameter arguments =
        ModalRoute.of(context).settings.arguments;
    final ActivityModel activity = arguments.activity;
    final OrderModel order = arguments.order;
    final String selectedRoute = arguments.selectedPaymentRoute;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).inquiryScreen_makeInquiry,
        appBar: AppBar(),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.getScaledSize(20.0),
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0),
                        ),
                        child: Text(
                          activity.title,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(18.0),
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.primaryColorDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(20.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context)
                              .inquiryScreen_limitedPlacesMessage,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(14.0),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(20.0),
                      ),
                      ..._getInfoCards(),
                      // increased (Test on Iphone 11 needed)
                      SizedBox(
                        height: Dimensions.getScaledSize(50.0),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(60.0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0 - MediaQuery.of(context).viewInsets.bottom,
                child: BookingBar(
                  bookingDetails: activity.bookingDetails,
                  orderProducts: order.products,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      selectedRoute,
                      arguments: PaymentCreditCardScreenParameter(
                        activity: activity,
                        order: order,
                      ),
                    );
                  },
                  buttonText: AppLocalizations.of(context).commonWords_further,
                  showDivider: !_showInfoContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getInfoCards() {
    return [
      _buildInfoCard(
        '1',
        'inquiry_animated1.riv',
        0,
        'Anfrage stellen',
        'Der Anbieter prüft, ob zu Deinem ausgewählten Zeitpunkt noch Tickets verfügbar sind.',
      ),
      _buildInfoCard(
        '2',
        'inquiry_animated2.riv',
        2000,
        'Antwort erhalten',
        'Der Anbieter reagiert so schnell wie möglich auf Deine Anfrage und Du erhältst zeitnah eine Rückmeldung.',
      ),
      _buildInfoCard(
        '3',
        'inquiry_animated3.riv',
        4000,
        'Abenteuer starten',
        'Nachdem die Buchung bestätigt wurde, erhältst Du Dein digitales Ticket in der App.',
      ),
    ];
  }

  Widget _buildInfoCard(String leadingText, String riveFileName,
      int startAnimationAfterMilliseconds, String title, String subTitle) {
    return Stack(
      children: [
        Container(
          height: Dimensions.getScaledSize(130.0),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            top: Dimensions.getScaledSize(10.0),
            bottom: Dimensions.getScaledSize(10.0),
            left: Dimensions.getScaledSize(24.0),
            right: Dimensions.getScaledSize(24.0),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomTheme.darkGrey.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(16.0)),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: Dimensions.getScaledSize(6.0),
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: Dimensions.getScaledSize(130.0),
                width: MediaQuery.of(context).size.width * 0.1,
                padding: EdgeInsets.all(
                  Dimensions.getScaledSize(5.0),
                ),
                child: Container(
                  height: Dimensions.getScaledSize(130.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(16.0)),
                    color: CustomTheme.lightGrey,
                  ),
                  child: Center(
                    child: Text(
                      leadingText,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(15.0),
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.theme.primaryColorDark,
                      ),
                    ),
                  ),
                ),
              ),
              DashedDivider(
                height: Dimensions.getScaledSize(130.0),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: Dimensions.getScaledSize(10),
                          top: Dimensions.getScaledSize(10),
                          bottom: Dimensions.getScaledSize(10),
                          right: Dimensions.getScaledSize(5),
                        ),
                        child: RiveAnimation(
                          riveFileName: riveFileName,
                          riveAnimationName: "Animation 1",
                          placeholderImage: 'lib/assets/images/help.png',
                          startAnimationAfterMilliseconds:
                              startAnimationAfterMilliseconds,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.only(
                          right: Dimensions.getScaledSize(10),
                          top: Dimensions.getScaledSize(10),
                          bottom: Dimensions.getScaledSize(10),
                          left: Dimensions.getScaledSize(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(13.0),
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.theme.primaryColorDark,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(10),
                            ),
                            Text(
                              subTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(11.0),
                                color: CustomTheme.theme.primaryColorDark,
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
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * -0.02 +
              Dimensions.getScaledSize(10.0),
          left: MediaQuery.of(context).size.width * 0.08 +
              1.5 +
              Dimensions.getScaledSize(24.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.04,
                width: MediaQuery.of(context).size.width * 0.04,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomTheme.darkGrey.withOpacity(0.5),
                  ),
                  borderRadius:
                      BorderRadius.circular(Dimensions.getScaledSize(48.0)),
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.02,
                  width: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.width * -0.02 +
              Dimensions.getScaledSize(10.0),
          left: MediaQuery.of(context).size.width * 0.08 +
              1.5 +
              Dimensions.getScaledSize(24.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.04,
                width: MediaQuery.of(context).size.width * 0.04,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomTheme.darkGrey.withOpacity(0.5),
                  ),
                  borderRadius:
                      BorderRadius.circular(Dimensions.getScaledSize(48.0)),
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.02,
                  width: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

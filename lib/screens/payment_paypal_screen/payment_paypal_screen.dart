import 'package:appventure/components/custom_app_bar.dart';
import 'package:appventure/models/activity_model.dart';
import 'package:appventure/models/order_model.dart';
import 'package:appventure/screens/payment_credit_card_screen/components/payment_credit_card_screen_parameter.dart';
import 'package:appventure/screens/payment_paypal_screen/components/payment_paypal_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentPaypalScreen extends StatefulWidget {
  static const String route = '/payment/paypal';

  @override
  _PaymentPaypalScreenState createState() => _PaymentPaypalScreenState();
}

class _PaymentPaypalScreenState extends State<PaymentPaypalScreen> {
  @override
  Widget build(BuildContext context) {
    final PaymentCreditCardScreenParameter arguments =
        ModalRoute.of(context).settings.arguments;
    final ActivityModel activity = arguments.activity;
    final OrderModel order = arguments.order;

    return Scaffold(
      body: PaymentPaypalScreenView(
        order: order,
        activity: activity,
      ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).paymentPayPalScreen_title,
        appBar: AppBar(),
        centerTitle: true,
      ),
    );
  }
}
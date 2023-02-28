import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/screens/checkout_screen/components/checkout_screen_parameter.dart';
import 'package:yucatan/screens/checkout_screen/components/checkout_screen_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  static const route = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final CheckoutScreenParameter arguments =
        ModalRoute.of(context).settings.arguments;
    final ActivityModel activity = arguments.activity;
    final OrderModel order = arguments.order;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CheckoutScreenView(
        activity: activity,
        order: order,
      ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.checkoutScreen_title,
        appBar: AppBar(),
        centerTitle: true,
      ),
    );
  }
}

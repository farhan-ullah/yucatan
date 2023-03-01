import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/booking/components/booking_screen_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  static const route = '/booking';

  @override
  State<StatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    final ActivityModel? activity = ModalRoute.of(context)!.settings.arguments as ActivityModel?;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: BookingScreenView(activity: activity),
      ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.bookingScreen_title,
        appBar: AppBar(),
        centerTitle: true,
      ),
    );
  }
}

import 'package:yucatan/screens/notifications/notifications_screen.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QrScreenScaffold extends StatelessWidget {
  const QrScreenScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.qrScreen_title),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(NotificationsScreen.route);
            },
            child: Icon(
              Icons.notifications_outlined,
              size: Dimensions.getScaledSize(28.0),
            ),
          ),
          SizedBox(
            width: Dimensions.getScaledSize(24.0),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.home_outlined,
                size: Dimensions.getScaledSize(32.0),
                color: Colors.white,
              ),
              SizedBox(height: Dimensions.getScaledSize(4.0)),
              Text(
                AppLocalizations.of(context)!.qrScreen_home,
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(13.0),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Dimensions.getScaledSize(24.0)),
            ],
          ),
        ),
      )),
    );
  }
}

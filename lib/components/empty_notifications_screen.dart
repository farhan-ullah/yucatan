import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/utils/widget_dimensions.dart';

class EmptyNotificationScreen extends StatefulWidget {
  final VoidCallback? callback;
  EmptyNotificationScreen({this.callback});

  @override
  _EmptyNotificationScreenState createState() {
    return _EmptyNotificationScreenState();
  }
}

class _EmptyNotificationScreenState extends State<EmptyNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: Container()),
          Text(
            AppLocalizations.of(context)!.commonWords_mistake,
            style: TextStyle(
              color: CustomTheme.primaryColorDark,
              fontSize: Dimensions.getScaledSize(20.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Dimensions.getScaledSize(20.0)),
          Text(
            AppLocalizations.of(context)!.noNotificationsScreen_noNotifications,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(16.0),
                letterSpacing: CustomTheme.letterSpacing,
                color: CustomTheme.primaryColorDark),
          ),
          SizedBox(height: Dimensions.getScaledSize(30.0)),
          SizedBox(
            height: Dimensions.getHeight(percentage: 35.0),
            child: Image.asset(
              "lib/assets/images/favorites_empty.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: Dimensions.getScaledSize(45.0)),
          Expanded(flex: 7, child: Container()),
        ],
      ),
    );
  }

/*  void _navigateToSearch() {
    Navigator.of(context).pushNamed(
      SearchScreen.route,
    );
  }*/
}

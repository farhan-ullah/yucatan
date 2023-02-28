import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NotificationNotLoggedIn extends StatelessWidget {
  NotificationNotLoggedIn({Key? key}) : super(key: key);

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
            AppLocalizations.of(context)!
                .notificationsNotLoggedInScreen_loginTosee,
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
          Expanded(flex: 2, child: Container()),
          Container(
            width: Dimensions.getWidth(percentage: 50),
            height: Dimensions.getScaledSize(45.0),
            child: OutlinedButton(
              onPressed: () {
                _navigateToLogin(context);
              },
              child: Text(
                AppLocalizations.of(context)!.loginSceen_login,
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(20.0),
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(BorderSide(
                    color: CustomTheme.primaryColorDark,
                  )),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor:
                      MaterialStateProperty.all(CustomTheme.primaryColorDark),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(7)),
                  ))),
            ),
          ),
          Expanded(flex: 5, child: Container())
        ],
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
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

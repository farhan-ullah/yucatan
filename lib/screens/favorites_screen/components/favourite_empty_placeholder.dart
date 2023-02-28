import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouriteEmptyScreen extends StatefulWidget {
  FavouriteEmptyScreen({Key? key}) : super(key: key);

  @override
  _FavouriteEmptyScreenState createState() {
    return _FavouriteEmptyScreenState();
  }
}

class _FavouriteEmptyScreenState extends State<FavouriteEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.getScaledSize(60.0),
          ),
          SizedBox(
            height: Dimensions.getHeight(percentage: 40.0),
            child: Image.asset(
              "lib/assets/images/favorites_empty.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: Dimensions.getScaledSize(60.0),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
              left: Dimensions.getScaledSize(20.0),
              right: Dimensions.getScaledSize(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.favoritesScreen_logInToSee,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(18.0),
                    letterSpacing: CustomTheme.letterSpacing,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                OutlinedButton(
                  onPressed: () {
                    _navigateToLogin();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            Dimensions.getScaledSize(5.0)),
                      )),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor: MaterialStateProperty.all(
                          CustomTheme.primaryColorDark)),
                  child: Text(
                    AppLocalizations.of(context)!.loginSceen_login,
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(20.0),
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.primaryColorLight,
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getScaledSize(60.0),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  void _navigateToLogin() {
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

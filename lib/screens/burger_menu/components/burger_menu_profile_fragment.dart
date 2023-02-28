import 'package:yucatan/screens/authentication/login/loginbloc/login_screen.dart';
import 'package:yucatan/screens/authentication/register/register_screen.dart';
import 'package:yucatan/screens/burger_menu/components/burger_menu_list_item_spacer.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/profile/profile_screen.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'burger_menu_list_item.dart';

class BurgerMenuProfileFragment extends StatefulWidget {
  final UserLoginModel user;

  const BurgerMenuProfileFragment({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BurgerMenuProfileFragmentState();
}

class _BurgerMenuProfileFragmentState extends State<BurgerMenuProfileFragment> {
  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      // if user is not logged in:
      return _notLoggedInFragment();
    } else {
      // if the user is logged in:
      return _loggedInFragment();
    }
  }

  /// Widget to display if the user is not logged in currently
  Widget _notLoggedInFragment() {
    double height = Scaffold.of(context).appBarMaxHeight;
    return Container(
      margin: EdgeInsets.fromLTRB(0, height, 0, 0),
      decoration: BoxDecoration(
        color: CustomTheme.loginBackground,
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3))),
      ),
      padding: EdgeInsets.all(Dimensions.getScaledSize(25.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Dimensions.pixels_25),
          Text(
            AppLocalizations.of(context)!.burgerMenuScreen_loginNow,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(20.0),
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: Dimensions.getScaledSize(35.0)),
          MaterialButton(
            color: Colors.white,
            elevation: 0,
            textColor: Colors.white,
            disabledColor: CustomTheme.grey,
            disabledTextColor: CustomTheme.primaryColorDark,
            onPressed: () async {
              await Navigator.of(context).pushNamed(LoginScreen.route);
              _loginRegisterReload();
            },
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.getScaledSize(5.0)),
                side: BorderSide(color: CustomTheme.primaryColorDark)),
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.getScaledSize(10.0),
                horizontal: Dimensions.pixels_75),
            child: Text(
              AppLocalizations.of(context)!.loginSceen_login,
              style: TextStyle(
                  fontSize: Dimensions.getScaledSize(18.0),
                  color: CustomTheme.primaryColorDark,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: Dimensions.getScaledSize(35.0)),
          Text(
            AppLocalizations.of(context)!.authenticationSceen_noProfile,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.black, fontFamily: CustomTheme.fontFamily),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)
                          .authenticationSceen_registerNow,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)
                          .authenticationSceen_registerNowRegister,
                      style: TextStyle(
                          color: CustomTheme.primaryColor,
                          fontFamily: CustomTheme.fontFamily,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await Navigator.of(context).pushNamed(
                            RegisterScreen.route,
                          );
                          _loginRegisterReload();
                        },
                    ),
                    TextSpan(text: '.'),
                  ])),
          SizedBox(height: Dimensions.getScaledSize(10.0)),
        ],
      ),
    );
  }

  /// Widget to display if the user is currently logged in
  Widget _loggedInFragment() {
    double height = Scaffold.of(context).appBarMaxHeight;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, height, 0, 0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.5, color: Colors.black.withOpacity(0.3))),
          ),
          padding: EdgeInsets.fromLTRB(
              Dimensions.getScaledSize(10.0),
              Dimensions.getScaledSize(15.0),
              Dimensions.getScaledSize(15.0),
              Dimensions.getScaledSize(35.0)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: Dimensions.getScaledSize(45.0),
                  backgroundColor: CustomTheme.primaryColorLight,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.015),
                        child: Text(
                          widget.user.username != null
                              ? widget.user.username.isEmpty
                                  ? "U"
                                  : widget.user.username[0]
                              : 'U',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: Dimensions.getScaledSize(52.0),
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ))),
              SizedBox(width: Dimensions.getScaledSize(25.0)),
              Text(
                widget.user?.username ?? "Benutzername",
                style: TextStyle(
                    color: CustomTheme.primaryColorDark,
                    fontSize: Dimensions.getScaledSize(24.0),
                    fontWeight: FontWeight.bold),
              ),
              /*Text(widget.user?.email ?? "E-mail",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: Dimensions.getScaledSize(12.0),
                      fontWeight: FontWeight.normal)),
              SizedBox(height: Dimensions.getScaledSize(5.0)),*/
            ],
          ),
        ),
        BurgerMenuListItem(
          text: AppLocalizations.of(context)!.burgerMenuScreen_profileSettings,
          //icon: Icon(Icons.person),
          showSvg: true,
          svgPath: "lib/assets/images/portrait_black_24dp.svg",
          tapRoute: ProfileScreen.route,
          tapActionPost: () {},
        ),
        widget.user == null ? BurgerMenuListItemSpacer() : Container()
      ],
    );
  }

  _loginRegisterReload() async {
    debugPrint("_loginRegisterReload");
    if (await UserProvider.getUser() != null)
      Navigator.of(context).pushReplacementNamed(MainScreen.route);
  }
}

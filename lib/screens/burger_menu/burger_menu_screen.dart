import 'package:yucatan/screens/burger_menu/bloc/burger_menu_bloc.dart';
import 'package:yucatan/screens/contact/contact_screen.dart';
import 'package:yucatan/screens/favorites_screen/bloc/user_bloc.dart';
import 'package:yucatan/screens/impressum_datenschutz/impressum_datenschutz.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/notifications/notifications_screen.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../services/response/user_login_response.dart';
import 'components/burger_menu_list_item.dart';
import 'components/burger_menu_profile_fragment.dart';

class BurgerMenuScreen extends StatefulWidget {
  static const String route = '/burgermenu';

  @override
  _BurgerMenuScreenState createState() => _BurgerMenuScreenState();
}

class _BurgerMenuScreenState extends State<BurgerMenuScreen> {
  final InAppReview _inAppReview = InAppReview.instance;
  final UserLoginModelBloc bloc = UserLoginModelBloc();
  final BurgerMenuBloc burgerMenuBloc = BurgerMenuBloc();
  UserLoginModel userModel;

  @override
  void initState() {
    _getLoginState();
    bloc.eventSink.add(UserLoginAction.FetchLoggedInUser);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    burgerMenuBloc.dispose();
    super.dispose();
  }

  void _getLoginState() {
    bloc.userModelStream.listen((event) {
      userModel = event;
      if (event == null) {
        burgerMenuBloc.setLoginState = LoginState.NOT_LOGGED_IN;
      } else {
        burgerMenuBloc.setLoginState = LoginState.LOGGED_IN;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoginState>(
        stream: burgerMenuBloc.loginState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.only(
                    top: Dimensions.getScaledSize(10.0),
                    left: Dimensions.getScaledSize(10.0),
                    bottom: Dimensions.getScaledSize(10.0),
                    right: Dimensions.getScaledSize(10.0)),
                children: _fillUserEntries(userModel),
              ),
            );
          }

          return Container();
        });
  }

  _fillUserEntries(UserLoginModel user) {
    List<Widget> _widgets = [];

    _widgets.add(BurgerMenuProfileFragment(user: user));

    _widgets.add(BurgerMenuListItem(
        text: AppLocalizations.of(context)!.burger_menu_notification_text,
        tapActionPre: () async =>
            {Navigator.of(context).pushNamed(NotificationsScreen.route)},
        icon: new Icon(Icons.notifications_outlined,
            color: CustomTheme.primaryColorDark)));

    _widgets.add(BurgerMenuListItem(
        text: AppLocalizations.of(context)!.burger_menu_reviews_text,
        tapActionPre: () async => {
              if (await _inAppReview.isAvailable())
                {_inAppReview.requestReview()}
            },
        icon:
            new Icon(Icons.star_border, color: CustomTheme.primaryColorDark)));

    _widgets.add(BurgerMenuListItem(
      text: AppLocalizations.of(context)!.burger_menu_contact_text,
      icon: new Icon(Icons.contact_support_outlined,
          color: CustomTheme.primaryColorDark),
      tapActionPre: () async =>
          {Navigator.of(context).pushNamed(ContactScreen.route)},
    ));

    _widgets.add(BurgerMenuListItem(
      text: AppLocalizations.of(context)!
          .burger_menu_imprint_data_protection_text,
      tapActionPre: () async =>
          {Navigator.of(context).pushNamed(ImpressumDatenschutz.route)},
      showSvg: true,
      svgPath: "lib/assets/images/policy_black_24dp.svg",
    ));

    if (user != null) {
      if (user.getRole() == "Vendor") {
        _widgets.add(BurgerMenuListItem(
            text:
                AppLocalizations.of(context)!.burger_menu_to_the_user_view_text,
            tapActionPre: () => user.switchToUserRole(),
            tapRoute: MainScreen.route,
            icon: Icon(Icons.view_carousel,
                color: CustomTheme.primaryColorDark)));
      } else if (user.isVendorPseudoUser()) {
        _widgets.add(BurgerMenuListItem(
            text: AppLocalizations.of(context)
                .burger_menu_to_the_provider_view_text,
            tapActionPre: () {
              user.switchToDefaultRole();
            },
            tapRoute: MainScreen.route,
            icon: Icon(Icons.view_carousel_outlined,
                color: CustomTheme.primaryColorDark)));
      }

      _widgets.add(BurgerMenuListItem(
        text: AppLocalizations.of(context)!.burger_menu_sign_out_text,
        tapActionPre: () async {
          await HiveService.clearDatabase();
          await UserProvider.logout();
        },
        tapRoute: MainScreen.route,
        showSvg: true,
        svgPath: "lib/assets/images/exit_to_app_black_24dp.svg",
      ));

      _widgets.add(Container(
          margin: EdgeInsets.fromLTRB(0, Dimensions.pixels_20, 0, 0),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)
                    .burger_menu_made_in_bavaria_with_text,
                style: TextStyle(color: CustomTheme.hintText),
              ),
              SizedBox(
                width: Dimensions.pixels_10,
              ),
              SvgPicture.asset(
                'lib/assets/images/pretzel_heart.svg',
                color: CustomTheme.hintText,
                height: Dimensions.pixels_25,
              ),
            ],
          ))));
    } else {
      _widgets.add(Container(
          margin: EdgeInsets.fromLTRB(0, Dimensions.pixels_20, 0, 0),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)
                    .burger_menu_made_in_bavaria_with_text,
                style: TextStyle(color: CustomTheme.hintText),
              ),
              SizedBox(
                width: Dimensions.pixels_10,
              ),
              SvgPicture.asset(
                'lib/assets/images/pretzel_heart.svg',
                color: CustomTheme.hintText,
                height: Dimensions.pixels_25,
              ),
            ],
          ))));
    }
    return _widgets;
  }
}

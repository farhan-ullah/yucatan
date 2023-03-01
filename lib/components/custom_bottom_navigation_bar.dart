import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/screens/activity_list_screen/activity_list_screen.dart';
import 'package:yucatan/screens/activity_map/activity_map_screen.dart';
import 'package:yucatan/screens/booking_list_screen/booking_list_screen_offline.dart';
import 'package:yucatan/screens/burger_menu/burger_menu_screen.dart';
import 'package:yucatan/screens/favorites_screen/favorites_screen.dart';
import 'package:yucatan/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:yucatan/screens/vendor/activity_overview/activity_overview.dart';
import 'package:yucatan/screens/vendor/burger_menu/vendor_burger_menu_screen.dart';
import 'package:yucatan/screens/vendor/dashboard/vendor_dashboard.dart';
import 'package:yucatan/screens/vendor/statistic/vendor_statistic_screen.dart';
import 'package:yucatan/services/notification_service/notification_actions.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_callback_handler.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/bool_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  final Function(Widget, UserLoginModel)? updateFragment;
  final int? index;
  final NotificationActions? notificationAction;
  final dynamic notificationData;
  String? activityId;
  bool isBookingRequestType;

  CustomBottomNavigationBar({
    Key? key,
    this.updateFragment,
    this.index,
    this.notificationAction,
    this.notificationData,
    this.activityId,
    this.isBookingRequestType = false,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int _selectedIndex = 0;
  List<Widget> widgetOptionsUser = [];
  List<Widget> widgetOptionsVendor = [];
  var widgetOptions = [];
  UserLoginModel? user;
  Widget? bottomBarView;

  void _onItemTapped(int index) {
    shuffelActivitysList = false;
    setState(() {
      _selectedIndex = index;
      widget.updateFragment!(widgetOptions[index], user!);
    });
  }

  _onUserChanged() async {
    print("---_onUserChanged----");
    user = await UserProvider.getUser();
    _updateWidgets(user!);
    widget.updateFragment!(widgetOptions[_selectedIndex], user!);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void initState() {
    eventBus.on<OnOpenSearch>().listen((event) {
      if (mounted) {
        setState(() {
          _selectedIndex = 0;
          widget.updateFragment!(
              ActivityListScreen(
                animationController: animationController!,
                showSearch: true,
                activityId: widget.activityId!,
              ),
              user!);
        });
      }
    });
    animationController =
        AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _selectedIndex = widget.index!;

    widgetOptionsUser = [
      ActivityListScreen(
        animationController: animationController!,
        activityId: widget.activityId!,
      ),
      BookingListScreenOffline(
        notificationAction: widget.notificationAction!,
        notificationData: widget.notificationData,
        isBookingRequestType: widget.isBookingRequestType ?? false,
      ),
      ActivityMapScreen(),
      FavoritesScreen(),
      BurgerMenuScreen(),
    ];

    widgetOptionsVendor = [
      VendorDashboard(),
      VendorStatisticScreen(),
      QRScannerScreen(),
      VendorActivityOverview(),
      VendorBurgerMenuScreen(),
    ];
    widgetOptions = widgetOptionsUser;

    UserCallbackHandler().callbacks.add(_onUserChanged());

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.updateFragment!(widgetOptions[0], user!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          Dimensions.getScaledSize(63) + MediaQuery.of(context).padding.bottom,
      child: Container(
        decoration: widgetOptions == widgetOptionsUser
            ? BoxDecoration(
                color: CustomTheme.primaryColorDark,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: CustomTheme.grey,
                    blurRadius: Dimensions.getScaledSize(4.0),
                    offset: const Offset(0, -2),
                  ),
                ],
              )
            : BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                  colors: [
                    Color(0xff004D88),
                    Color(0xff0071B8),
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: CustomTheme.grey,
                    blurRadius: Dimensions.getScaledSize(4.0),
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
        child: Column(
          children: <Widget>[
            ColoredDivider(height: Dimensions.getScaledSize(3.0)),
            //SizedBox(height: Dimensions.getScaledSize(4.0)),
            //showBottomBarView(),
            showBottomBarViewRefactored(),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }

  _updateWidgets(UserLoginModel user) {
    if (user == null) {
      widgetOptions = widgetOptionsUser;
    } else {
      if (user.getRole() == 'Vendor' && widget.activityId! != null) {
        widgetOptions = widgetOptionsUser;
        user.switchToUserRole();
        widget.activityId = null;
      } else {
        if (user.getRole() == 'Vendor') {
          widgetOptions = widgetOptionsVendor;
        } else {
          widgetOptions = widgetOptionsUser;
        }
      }
    }
  }

  _getIconMenuButton(
      {String? text, int? buttonNumber, Color? selectedColor, iconData}) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
          onTap: () {
            _onItemTapped(buttonNumber!);
          },
          child: Column(
            children: <Widget>[
              SizedBox(height: Dimensions.getScaledSize(4.0)),
              Container(
                width: Dimensions.getScaledSize(40.0),
                height: Dimensions.getScaledSize(32.0),
                child: Icon(
                  iconData,
                  size: Dimensions.getScaledSize(28.0),
                  color: _selectedIndex == buttonNumber
                      ? selectedColor
                      : Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.getScaledSize(4.0)),
                child: Text(
                  text!,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(11.0),
                    fontWeight: FontWeight.w500,
                    color: _selectedIndex == buttonNumber
                        ? selectedColor
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getQRbutton() {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
          onTap: () {
            _onItemTapped(2);
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                height: Dimensions.getScaledSize(4.0),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: Dimensions.getScaledSize(4.0),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.getScaledSize(60.0)),
                  ),
                ),
                width: Dimensions.getScaledSize(54.0),
                height: Dimensions.getScaledSize(54.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(QRScannerScreen.route);
                  },
                  child: Icon(
                    Icons.qr_code_scanner_sharp,
                    color: _selectedIndex == 2
                        ? CustomTheme.primaryColorDark
                        : CustomTheme.primaryColorLight,
                    size: Dimensions.getScaledSize(40.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getSvgMenuButton(
      {String? text, String? svgPath, int? buttonNumber, Color? selectedColor}) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
          onTap: () {
            _onItemTapped(buttonNumber!);
          },
          child: Column(
            children: <Widget>[
              SizedBox(height: Dimensions.getScaledSize(4.0)),
              Container(
                width: Dimensions.getScaledSize(24.0),
                height: Dimensions.getScaledSize(32.0),
                child: SvgPicture.asset(
                  svgPath!,
                  color: _selectedIndex == buttonNumber
                      ? selectedColor
                      : Colors.white, //Does not work with .3 opacity
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.getScaledSize(4.0)),
                child: Text(
                  text!,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(11.0),
                    fontWeight: FontWeight.w500,
                    color: _selectedIndex == buttonNumber
                        ? selectedColor
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showBottomBarViewRefactored() {
    if (widgetOptions == widgetOptionsVendor) {
      return Row(
        children: [
          _getIconMenuButton(
            buttonNumber: 0,
            iconData: Icons.home_outlined,
            selectedColor: CustomTheme.primaryColorDark,
            text: AppLocalizations.of(context)!.customBottomNavigationBar_home,
          ),
          _getSvgMenuButton(
            buttonNumber: 1,
            svgPath: 'lib/assets/images/statistik.svg',
            selectedColor: CustomTheme.primaryColorDark,
            text: AppLocalizations.of(context)!
                .customBottomNavigationBar_statistic,
          ),
          _getQRbutton(),
          _getSvgMenuButton(
            buttonNumber: 3,
            svgPath: 'lib/assets/images/angebot.svg',
            selectedColor: CustomTheme.primaryColorDark,
            text: AppLocalizations.of(context)!.customBottomNavigationBar_offers,
          ),
          _getSvgMenuButton(
            buttonNumber: 4,
            svgPath: 'lib/assets/images/profil.svg',
            selectedColor: CustomTheme.primaryColorDark,
            text:
                AppLocalizations.of(context)!.customBottomNavigationBar_profile,
          ),
        ],
      );
    }
    return Row(
      children: [
        _getIconMenuButton(
          buttonNumber: 0,
          iconData: Icons.search,
          selectedColor: CustomTheme.primaryColorLight,
          text: AppLocalizations.of(context)!.customBottomNavigationBar_find,
        ),
        _getIconMenuButton(
            buttonNumber: 1,
            iconData: Icons.loyalty_outlined,
            text:
                AppLocalizations.of(context)!.customBottomNavigationBar_bookings,
            selectedColor: CustomTheme.primaryColorLight),
        _getIconMenuButton(
            buttonNumber: 2,
            iconData: Icons.map_outlined,
            text: AppLocalizations.of(context)!.customBottomNavigationBar_map,
            selectedColor: CustomTheme.primaryColorLight),
        _getIconMenuButton(
            buttonNumber: 3,
            iconData: Icons.favorite_border,
            text: AppLocalizations.of(context)!
                .customBottomNavigationBar_favorites,
            selectedColor: CustomTheme.primaryColorLight),
        _getIconMenuButton(
            buttonNumber: 4,
            iconData: Icons.menu_outlined,
            text: AppLocalizations.of(context)!.customBottomNavigationBar_menu,
            selectedColor: CustomTheme.primaryColorLight)
      ],
    );
  }

  Widget showBottomBarView() {
    if (widgetOptions == widgetOptionsUser) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(0);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.search,
                        size: Dimensions.getScaledSize(28.0),
                        color: _selectedIndex == 0
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_find,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 0
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(1);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.loyalty_outlined,
                        color: _selectedIndex == 1
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                        size: Dimensions.getScaledSize(28.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_bookings,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 1
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(2);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.map_outlined,
                        color: _selectedIndex == 2
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                        size: Dimensions.getScaledSize(28.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_map,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 2
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(3);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.favorite_border,
                        size: Dimensions.getScaledSize(28.0),
                        color: _selectedIndex == 3
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: Dimensions.getScaledSize(5.0),
                        bottom: Dimensions.getScaledSize(5.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_favorites,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 3
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(4);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.menu_outlined,
                        color: _selectedIndex == 4
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                        size: Dimensions.getScaledSize(28.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_menu,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 4
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    } else if (widgetOptions == widgetOptionsVendor) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(0);
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.home_outlined,
                        size: Dimensions.getScaledSize(28.0),
                        color: _selectedIndex == 0
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_home,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 0
                              ? CustomTheme.primaryColorDark
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(1);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(24.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: SvgPicture.asset(
                        'lib/assets/images/statistik.svg',
                        color: _selectedIndex == 1
                            ? CustomTheme.primaryColorDark
                            : Colors.white, //Does not work with .3 opacity
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_statistic,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 1
                              ? CustomTheme.primaryColorDark
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(2);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: Dimensions.getScaledSize(4.0),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.getScaledSize(60.0)),
                        ),
                      ),
                      width: Dimensions.getScaledSize(54.0),
                      height: Dimensions.getScaledSize(54.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(QRScannerScreen.route);
                        },
                        child: Icon(
                          Icons.qr_code_scanner_sharp,
                          color: _selectedIndex == 2
                              ? CustomTheme.primaryColorDark
                              : CustomTheme.primaryColorLight,
                          size: Dimensions.getScaledSize(40.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(3);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(24.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: SvgPicture.asset(
                        'lib/assets/images/angebot.svg',
                        color: _selectedIndex == 3
                            ? CustomTheme.primaryColorDark
                            : Colors.white, //Does not work with .3 opacity
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_offers,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 3
                              ? CustomTheme.primaryColorDark
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(4);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(24.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: SvgPicture.asset(
                        'lib/assets/images/profil.svg',
                        color: _selectedIndex == 4
                            ? CustomTheme.primaryColorDark
                            : Colors.white, //Does not work with .3 opacity
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_profile,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 4
                              ? CustomTheme.primaryColorDark
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(0);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.search,
                        size: Dimensions.getScaledSize(24.0),
                        color: _selectedIndex == 0
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_find,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 0
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(1);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.loyalty_outlined,
                        color: _selectedIndex == 1
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                        size: Dimensions.getScaledSize(24.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Dimensions.getScaledSize(5.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_bookings,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 1
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(2);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: SvgPicture.asset(
                        'lib/assets/images/map.svg',
                        color: _selectedIndex == 2
                            ? CustomTheme.primaryColorLight
                            : Colors.white, //Does not work with .3 opacity
                        height: Dimensions.getScaledSize(24.0),
                        width: Dimensions.getScaledSize(24.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_map,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 2
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(3);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.favorite_border,
                        size: Dimensions.getScaledSize(24.0),
                        color: _selectedIndex == 3
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_favorites,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 3
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: CustomTheme.primaryColorLight.withOpacity(0.2),
                onTap: () {
                  _onItemTapped(4);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.getScaledSize(4.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(40.0),
                      height: Dimensions.getScaledSize(32.0),
                      child: Icon(
                        Icons.menu_outlined,
                        color: _selectedIndex == 4
                            ? CustomTheme.primaryColorLight
                            : Colors.white,
                        size: Dimensions.getScaledSize(24.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimensions.getScaledSize(5.0)),
                      child: Text(
                        AppLocalizations.of(context)!
                            .customBottomNavigationBar_menu,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(11.0),
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 4
                              ? CustomTheme.primaryColorLight
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
  }
}

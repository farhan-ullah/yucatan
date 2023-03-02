import 'package:yucatan/components/custom_bottom_navigation_bar.dart';
import 'package:yucatan/components/sliding_appbar.dart';
import 'package:yucatan/screens/activity_list_screen/activity_list_screen.dart';
import 'package:yucatan/screens/authentication/login/loginbloc/login_screen.dart';
import 'package:yucatan/screens/authentication/reset_passowrd.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/services/user_service.dart';
import 'package:yucatan/size_config.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/banner/flavor_banner.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  static const String route = '/';

  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Widget fragment = Container();
  String appLink = "";
  UserLoginModel? user;
  bool showAppBar = true;

  bool _visible = true;
  AnimationController? _controller;

  void _updateFragment(Widget fragment, UserLoginModel user) {
    setState(() {
      this.fragment = fragment;
      this.user = user;
      if (user == null) {
        this.showAppBar = true;
      } else {
        if (user.getRole() == 'Vendor') {
          this.showAppBar = false;
        } else {
          this.showAppBar = true;
        }
      }
    });
  }

  void _navigateToHomeScreen(BuildContext context, {String? activityID}) {
    UserProvider.getUserSync()?.switchToUserRole();
    Navigator.of(context).popUntil(ModalRoute.withName(MainScreen.route));
    Navigator.of(context).pushReplacementNamed(
      MainScreen.route,
      arguments: MainScreenParameter(
          bottomNavigationBarIndex: 0, activityId: activityID),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    eventBus.on<OnAppLinkClick>().listen((OnAppLinkClick event) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        this.appLink = event.link;
        if (this.appLink.contains('users/resetPassword')) {
          _updateFragment(ResetPassword(), user!);
        } else if (this.appLink.contains('users/confirm')) {
          var email = this.appLink.split('email=')[1].split('&')[0];
          var token = this.appLink.split('token=')[1];
          UserService.confirmUser(email: email, token: token);
          _updateFragment(LoginScreen(), user!);
        }
      });
    });

    eventBus.on<OnMapClickCallback>().listen((OnMapClickCallback event) {
      setState(() {
        _visible = event.showAppBar;
      });
    });

    eventBus.on<OnDeepLinkClick>().listen((OnDeepLinkClick event) {
      //print("---OnDeepLinkClick.event---=${event.activityID}");
      if (this.mounted) {
        _navigateToHomeScreen(context, activityID: event.activityID);
      }
      //_navigateToHomeScreen(context);
    });

    // For Testing Purpose
    // HiveService.getScheduledNotificationsList().then((value) {
    //   value.forEach((element) {
    //     print('Notification:: Scheduled Notifications ${element.dateTime} ${element.id}');
    //   });
    // });
  }

  @override
  void dispose() {
    if (_controller != null) _controller!.dispose();
    // eventBus.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainScreenParameter? parameter = ModalRoute.of(context)!.settings.arguments as MainScreenParameter?;
    SizeConfig().init(context);

    if (fragment is ResetPassword) {
      return ResetPassword(
        link: appLink,
        updateFragment: () {
          _updateFragment(Container(), user!);
        },
      );
    } else if (fragment is LoginScreen) {
      return LoginScreen();
    } else {
      print("Data Showed 2 Farhan : $fragment");
      return fragment is ActivityListScreen
          ? FlavorBanner(
              child: Scaffold(
                body: fragment,
                bottomNavigationBar: CustomBottomNavigationBar(
                  updateFragment: _updateFragment,
                  index: parameter?.bottomNavigationBarIndex ?? 0,
                  notificationAction: parameter?.notificationAction,
                  notificationData: parameter?.notificationData,
                  activityId: parameter?.activityId,
                  isBookingRequestType: parameter!.isBookingRequestType!,
                ),
              ),
            )
          : FlavorBanner(
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: showAppBar
                    ? SlidingAppBar(
                        controller: _controller!,
                        visible: _visible,
                        child: AppBar(
                          title: GestureDetector(
                            onTap: () {
                              _navigateToHomeScreen(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/images/logo.svg',
                                  color: Colors.white,
                                  height: Dimensions.getScaledSize(28.0),
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: CustomTheme.primaryColorDark,
                          actions: [
                            GestureDetector(
                              onTap: () {
                                /*Navigator.of(context)
                              .pushNamed(NotificationsScreen.route);*/
                              },
                              //child: Icon( Icons.notifications,size: Dimensions.getScaledSize(28.0),
                              child: NotificationView(
                                negativePadding: false,
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.getScaledSize(24.0),
                            ),
                          ],
                        ),
                      )
                    : null,
                body: fragment,
                bottomNavigationBar: CustomBottomNavigationBar(
                  updateFragment: _updateFragment,
                  index: parameter?.bottomNavigationBarIndex ?? 0,
                  notificationAction: parameter?.notificationAction,
                  notificationData: parameter?.notificationData,
                  activityId: parameter?.activityId,
                  isBookingRequestType: parameter!.isBookingRequestType!,
                ),
              ),
            );
    }
  }
}

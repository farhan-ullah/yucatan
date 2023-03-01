import 'package:yucatan/bloc/AppStateBloc.dart';
import 'package:yucatan/screens/contact/contact_screen.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:yucatan/screens/notifications/notifications_screen.dart';
import 'package:yucatan/screens/profile/profile_screen.dart';
import 'package:yucatan/screens/vendor/burger_menu/bloc/vendor_burger_menu_bloc.dart';
import 'package:yucatan/services/common_service.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/response/user_notification_response.dart';
import 'package:yucatan/services/service_locator.dart';
import 'package:yucatan/services/user_notification_service.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/bool_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';

class VendorBurgerMenuScreen extends StatefulWidget {
  static const String route = '/vendorburgermenu';

  VendorBurgerMenuScreen();

  @override
  _VendorBurgerMenuScreenState createState() {
    return _VendorBurgerMenuScreenState();
  }
}

class _VendorBurgerMenuScreenState extends State<VendorBurgerMenuScreen> {
  UserLoginModel? user;
  Future<UserNotificationResponse>? notifications;
  WebViewValues? _currentWebViewValue;
  InAppWebViewController? webView;
  VendorBurgerMenuBloc bloc = getIt.get<VendorBurgerMenuBloc>();

  List<String> webPages = [
    "https://www.myappventure.de/",
    "https://www.myappventure.de/",
    "https://www.myappventure.de/",
    "https://www.myappventure.de/",
  ];

  @override
  void initState() {
    super.initState();
    appStateBloc.getNotifications();
    _currentWebViewValue = WebViewValues.IMPRINT;
    user = UserProvider.getUserSync();
    notifications = UserNotificationService.getNotificationsForUser();

    CommonService.getLegalDocWebPageUrl().then((value) {
      if (value?.data != null && value?.status == 200) {
        webPages[0] = value!.data!.tos!;
        webPages[1] = value.data!.privacy!;
        webPages[2] = value.data!.imprint!;
        webPages[3] = value.data!.rightOfWithdrawal!;
        if (webView != null) {
          webView!.loadUrl(
            urlRequest: URLRequest(
              url: Uri.parse(
                getViews(_currentWebViewValue!),
              ),
            ),
          );
        }
      }
    });
  }

  //fixme: unused code!
/*  Future<void> getVendorInfo() async {
    user = await UserProvider.getUser();
    setState(() {});
  }*/

  _getWebViewScreen() {
    return Container(
        height: double.infinity,
        color: CustomTheme.vendorMenubackground,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: Dimensions.getScaledSize(220.0),
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.getScaledSize(20.0)),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/vendor_bg_image.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    Dimensions.getScaledSize(20.0),
                    Dimensions.getScaledSize(50.0),
                    Dimensions.getScaledSize(20.0),
                    Dimensions.getScaledSize(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        bloc.setView = false;
                      },
                      child: SvgPicture.asset(
                        'lib/assets/images/login_back_icon.svg',
                        color: Colors.white,
                        height: Dimensions.getScaledSize(30.0),
                      ),
                    ),
                    NotificationView(
                      negativePadding: true,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    Dimensions.getScaledSize(20.0),
                    Dimensions.getScaledSize(140.0),
                    Dimensions.getScaledSize(20.0),
                    Dimensions.getScaledSize(20.0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 0),
                            borderRadius: BorderRadius.all(Radius.circular(
                                Dimensions.getScaledSize(15.0)))),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.getScaledSize(12),
                          vertical: Dimensions.getScaledSize(15),
                        ),
                        child: StreamBuilder<WebViewValues>(
                            initialData: WebViewValues.IMPRINT,
                            stream: bloc.webviewTabStream,
                            builder: (context, snapshot) {
                              _currentWebViewValue = snapshot.data;
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              CustomTheme.backgroundColorVendor,
                                          //color: Colors.green,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Dimensions.getScaledSize(
                                                    8.0)))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: getTabButton("Impressum",
                                                WebViewValues.IMPRINT)),
                                        Expanded(
                                            child: getTabButton(
                                                "AGB", WebViewValues.TOS)),
                                        Expanded(
                                            child: getTabButton("Datenschutz",
                                                WebViewValues.PRIVACY)),
                                        Expanded(
                                            child: getTabButton(
                                                "Widerruf",
                                                WebViewValues
                                                    .RIGHTOFWITHDRAWAL)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: Dimensions.getScaledSize(10)),
                                  SizedBox(
                                    height: Dimensions.getScaledSize(1000),
                                    child: InAppWebView(
                                      initialUrlRequest: URLRequest(
                                          url: Uri.parse(
                                              getViews(_currentWebViewValue!))),
                                      initialOptions: InAppWebViewGroupOptions(
                                          crossPlatform: InAppWebViewOptions()),
                                      onWebViewCreated:
                                          (InAppWebViewController controller) {
                                        webView = controller;
                                      },
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                      SizedBox(height: Dimensions.getScaledSize(12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.viewStream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return _getWebViewScreen();
          }

          return Container(
            height: double.infinity,
            color: CustomTheme.vendorMenubackground,
            child: Stack(
              children: [
                Container(
                  height: Dimensions.getScaledSize(220),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.getScaledSize(20.0)),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("lib/assets/images/vendor_bg_image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      Dimensions.getScaledSize(20.0),
                      Dimensions.getScaledSize(
                        MediaQuery.of(context).padding.top,
                      ),
                      Dimensions.getScaledSize(20.0),
                      Dimensions.getScaledSize(20.0)),
                  child: Container(
                    height: AppBar().preferredSize.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/images/appventure_logo_neg.svg',
                          color: Colors.white,
                          height: Dimensions.getScaledSize(30.0),
                        ),
                        NotificationView(
                          negativePadding: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      Dimensions.getScaledSize(20.0),
                      Dimensions.getScaledSize(140.0),
                      Dimensions.getScaledSize(20.0),
                      Dimensions.getScaledSize(20.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                Dimensions.getScaledSize(15.0)))),
                    padding: EdgeInsets.fromLTRB(
                        0, Dimensions.getScaledSize(80) - 1, 0, 0),
                    child: Container(
                      height: 1,
                      color: CustomTheme.backgroundColorVendor,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: CustomTheme.mediumGrey,
                            border: Border.all(
                                color: Colors.white,
                                width: Dimensions.getScaledSize(4.0)),
                            borderRadius: BorderRadius.all(Radius.circular(
                                Dimensions.getScaledSize(60.0)))),
                        width: Dimensions.getScaledSize(100.0),
                        height: Dimensions.getScaledSize(100.0),
                        margin: EdgeInsets.fromLTRB(
                            0, Dimensions.getScaledSize(90.0), 0, 0),
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: CustomTheme.mediumGrey,
                            minRadius: Dimensions.getScaledSize(100.0),
                            child: Text(
                              getUserName(),
                              style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(32.0),
                                  color: CustomTheme.primaryColorLight,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      Dimensions.getScaledSize(20.0),
                      Dimensions.getScaledSize(219.0),
                      Dimensions.getScaledSize(20.0),
                      0),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 0),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(
                                      Dimensions.getScaledSize(15.0)))),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.getScaledSize(16)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: Dimensions.getScaledSize(20.0)),
                                    Text(
                                      user == null
                                          ? ""
                                          : "${user!.firstname.trim()} ${user!.lastname.trim()}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(24.0),
                                        color: CustomTheme.primaryColorLight,
                                        fontFamily: CustomTheme.fontFamily,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.getScaledSize(5),
                                    ),
                                    Text(
                                      user == null
                                          ? ""
                                          : user!.username!.trim(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(20.0),
                                        color: CustomTheme.primaryColorLight,
                                        fontFamily: CustomTheme.fontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimensions.getScaledSize(40)),
                                    newVendorMenuListRow(
                                        "Profileinstellungen",
                                        getSvg(
                                            "lib/assets/images/portrait_black_24dp.svg"),
                                        () => navigateToPersonScreen(context)),
                                    getDivider(),
                                    newVendorMenuListRow(
                                        "Bewertungen",
                                        getSvg(
                                            'lib/assets/images/star_border_black_24dp.svg'),
                                        () async {
                                      final InAppReview inAppReview =
                                          InAppReview.instance;

                                      if (await inAppReview.isAvailable()) {
                                        inAppReview.requestReview();
                                      } else
                                        inAppReview.openStoreListing();
                                    }),
                                    getDivider(),
                                    getNotificationsRow(),
                                    getDivider(),
                                    newVendorMenuListRow(
                                        "Kontakt",
                                        getSvg(
                                            'lib/assets/images/contact_support_black_24dp.svg'),
                                        () {
                                      Navigator.of(context)
                                          .pushNamed(ContactScreen.route);
                                    }),
                                    getDivider(),
                                    newVendorMenuListRow(
                                        "Impressum & Datenschutz",
                                        getSvg(
                                            'lib/assets/images/policy_black_24dp.svg'),
                                        () => openWebView()),
                                    getDivider(),
                                    newVendorMenuListRow(
                                        "Zur Useransicht",
                                        getSvg(
                                            'lib/assets/images/switch_mode_icon.svg'),
                                        () async {
                                      if (!shuffelActivitysList &&
                                          shuffleCounter == 0) {
                                        shuffelActivitysList = true;
                                      }
                                      user!.switchToUserRole();
                                      shuffleCounter = shuffleCounter + 1;
                                      await Navigator.of(context)
                                          .pushReplacementNamed(
                                              MainScreen.route);
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.getScaledSize(12)),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 0),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  Dimensions.getScaledSize(15.0)))),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.getScaledSize(12)),
                          child: newVendorMenuListRow(
                              "Abmelden",
                              getSvg(
                                  'lib/assets/images/exit_to_app_black_24dp.svg'),
                              () => logout(context)),
                        ),
                        SizedBox(height: Dimensions.getScaledSize(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Made from Bavaria with ",
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(12.0),
                                color: Colors.white,
                                fontFamily: CustomTheme.fontFamily,
                              ),
                            ),
                            Container(
                              width: Dimensions.getScaledSize(13.0),
                              height: Dimensions.getScaledSize(13.0),
                              child: SvgPicture.asset(
                                "lib/assets/images/pretzel_heart.svg",
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.getScaledSize(20.0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  getViews(WebViewValues value) {
    switch (value) {
      case WebViewValues.TOS:
        return webPages[0];
        break;
      case WebViewValues.PRIVACY:
        return webPages[1];
        break;
      case WebViewValues.IMPRINT:
        return webPages[2];
        break;
      case WebViewValues.RIGHTOFWITHDRAWAL:
        return webPages[3];
        break;
    }
  }

  getTabButton(String text, WebViewValues value) {
    bool isSelected = _currentWebViewValue == value;
    return GestureDetector(
      onTap: () {
        if (webView != null && webView!.getUrl() != getViews(value)) {
          bloc.setwebviewTab = value;
          webView!.loadUrl(
              urlRequest: URLRequest(url: Uri.parse(getViews(value))));
        }
      },
      child: Container(
        height: Dimensions.getScaledSize(36.0),
        decoration: BoxDecoration(
            color: isSelected ? CustomTheme.primaryColorLight : Colors.white,
            border: Border.all(
                width: 0,
                color:
                    isSelected ? CustomTheme.primaryColorLight : Colors.white),
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.getScaledSize(6)))),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : CustomTheme.primaryColorLight,
              fontSize: Dimensions.getScaledSize(10.0),
              fontWeight: FontWeight.w300,
              fontFamily: CustomTheme.fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  getIcon(IconData iconData) {
    return Icon(
      iconData,
      color: CustomTheme.primaryColorLight,
      size: Dimensions.getScaledSize(22.0),
    );
  }

  getSvg(String svgPath) {
    return Container(
      width: Dimensions.getScaledSize(20.0),
      height: Dimensions.getScaledSize(28.0),
      child: SvgPicture.asset(
        svgPath,
        color: CustomTheme.primaryColorLight,
      ),
    );
  }

  getDivider({height = 3.0}) {
    return Divider(
      color: CustomTheme.vendorMenubackground,
      height: height,
    );
  }

  getNotificationsRow() {
    return StreamBuilder(
        stream: appStateBloc.getVendorNotificationsCount,
        builder: (context, snapshotNotifications) {
          int? notificationsNumber = 0;
          if (snapshotNotifications.hasData &&
              snapshotNotifications.data != null) {
            notificationsNumber = snapshotNotifications.data.toString().length;
          }
          bool hasNotifications = notificationsNumber == 0;
          return GestureDetector(
            onTap: () => navigateToNotifications(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.getScaledSize(10.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                        text: "Benachrichtigungen  ",
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(15.0),
                          color: CustomTheme.primaryColorLight,
                          fontFamily: CustomTheme.fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                              text: '($notificationsNumber)',
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(15.0),
                                color: hasNotifications
                                    ? CustomTheme.primaryColorLight
                                    : Color(0xffff5858),
                                fontFamily: CustomTheme.fontFamily,
                                fontWeight: FontWeight.w600,
                              ))
                        ]),
                  ),
                  Icon(
                    Icons.notifications_outlined,
                    color: hasNotifications
                        ? CustomTheme.primaryColorLight
                        : CustomTheme.accentColor1,
                    size: Dimensions.getScaledSize(22.0),
                  )
                ],
              ),
            ),
          );
        });
  }

  String getUserName() {
    String name = "";
    if (user == null) {
      return "";
    } else {
      name =
          "${user!.firstname.trim().isEmpty ? '' : user!.firstname.substring(0, 1).trim()}${user!.lastname.trim().isEmpty ? '' : user!.lastname.substring(0, 1).trim()}";
    }
    return name;
  }

  Widget newVendorMenuListRow(String text, Widget icon, Function action) {
    return GestureDetector(
      onTap: () => action(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.getScaledSize(10.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(15.0),
                color: CustomTheme.primaryColorLight,
                fontFamily: CustomTheme.fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
            icon
          ],
        ),
      ),
    );
  }

  String getSvgPath(String menuName) {
    String path = '';

    if (menuName == "Profileinstellungen") {
      path = 'lib/assets/images/profil.svg';
    }
    if (menuName == "Kontakt") {
      path = 'lib/assets/images/smart_toy_black_24dp.svg';
    }
    if (menuName == "Abmelden") {
      path = 'lib/assets/images/exit_to_app_black_24dp.svg';
    }

    return path;
  }

  navigateToNotifications(context) {
    Navigator.of(context).pushNamed(NotificationsScreen.route);
  }

  navigateToPersonScreen(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  logout(context) async {
    await HiveService.clearDatabase();
    await UserProvider.logout();
    await Navigator.of(context).pushReplacementNamed(MainScreen.route);
  }

  openWebView() {
    bloc.setView = true;
  }

  closeWebView() {
    bloc.setView = false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum WebViewValues {
  TOS,
  PRIVACY,
  IMPRINT,
  RIGHTOFWITHDRAWAL,
}

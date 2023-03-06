import 'package:yucatan/screens/activity_list_screen/activity_list_screen.dart';
import 'package:yucatan/screens/authentication/forgot/forgot_screen.dart';
import 'package:yucatan/screens/authentication/login/loginbloc/login_screen.dart';
import 'package:yucatan/screens/authentication/register/register_screen.dart';
import 'package:yucatan/screens/authentication/reset_passowrd.dart';
import 'package:yucatan/screens/authentication/reset_screen.dart';
import 'package:yucatan/screens/booking/booking_screen.dart';
import 'package:yucatan/screens/booking_list_screen/booking_list_screen_offline.dart';
import 'package:yucatan/screens/burger_menu/burger_menu_screen.dart';
import 'package:yucatan/screens/checkout_screen/checkout_screen.dart';
import 'package:yucatan/screens/contact/contact_screen.dart';
import 'package:yucatan/screens/favorites_screen/favorites_screen.dart';
import 'package:yucatan/screens/impressum_datenschutz/impressum_datenschutz.dart';
import 'package:yucatan/screens/inquiry/inquiry_screen.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/notifications/notifications_screen.dart';
import 'package:yucatan/screens/onboarding_screen/onboarding_screen.dart';
import 'package:yucatan/screens/payment_credit_card_screen/payment_credit_card_screen.dart';
import 'package:yucatan/screens/payment_paypal_screen/payment_paypal_screen.dart';
import 'package:yucatan/screens/profile/profile_screen.dart';
import 'package:yucatan/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:yucatan/screens/search_screen/search_screen.dart';
import 'package:yucatan/screens/splash_screen/splash_screen.dart';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_screen.dart';
import 'package:yucatan/screens/vendor/order_overview/order_overview_screen.dart';
import 'package:yucatan/screens/vendor/statistic/vendor_statistic_screen.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/booking_overview_screen.dart';
import 'package:flutter/material.dart';

import '../screens/newScreenforLogo/new_logo_screen.dart';

class CustomRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.route: (context) => SplashScreen(),
    MainScreen.route: (context) => MainScreen(),
    LogoScreen.route: (context) => LogoScreen(),
    LoginScreen.route: (context) => LoginScreen(),
    RegisterScreen.route: (context) => RegisterScreen(),
    ResetScreen.route: (context) => ResetScreen(),
    ForgotScreen.route: (context) => ForgotScreen(),
    ActivityListScreen.route: (context) => ActivityListScreen(),
    BookingScreen.route: (context) => BookingScreen(),
    CheckoutScreen.route: (context) => CheckoutScreen(),
    PaymentCreditCardScreen.route: (context) => PaymentCreditCardScreen(),
    PaymentPaypalScreen.route: (context) => PaymentPaypalScreen(),
    BookingListScreenOffline.route: (context) => BookingListScreenOffline(),
    BurgerMenuScreen.route: (context) => BurgerMenuScreen(),
    ProfileScreen.route: (context) => ProfileScreen(),
    SearchScreen.route: (context) => SearchScreen(),
    FavoritesScreen.route: (context) => FavoritesScreen(),
    OrderOverviewScreen.route: (context) => OrderOverviewScreen(),
    ResetPassword.route: (context) => ResetPassword(),
    InquiryScreen.route: (context) => InquiryScreen(),
    NotificationsScreen.route: (context) => NotificationsScreen(
          onNotificationClicked: (notificationMapObject) {},
        ),
    ImpressumDatenschutz.route: (context) => ImpressumDatenschutz(),
    OnboardingScreen.route: (context) => OnboardingScreen(),
    QRScannerScreen.route: (context) => QRScannerScreen(),
    VendorDemandScreen.route: (context) => VendorDemandScreen(),
    ContactScreen.route: (context) => ContactScreen(),
    VendorStatisticScreen.route: (context) => VendorStatisticScreen(),
    VendorBookingOverviewScreen.route: (context) =>
        VendorBookingOverviewScreen(),
  };
}

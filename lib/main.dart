import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yucatan/config/flavor_config.dart';
import 'package:yucatan/routes/custom_routes.dart';
import 'package:yucatan/screens/splash_screen/splash_screen.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/service_locator.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/utils/bool_utils.dart';
import 'package:yucatan/utils/country_utils.dart';
import 'package:yucatan/utils/theme_model.dart';

import 'l10n/l10n.dart';

class EnvironmentConfig {
  static const FLAVOR =
      String.fromEnvironment("DEFINE_FLAVOR", defaultValue: "DEV");
}

Future<void> main() async {
  switch (EnvironmentConfig.FLAVOR) {
    case "QA":
      FlavorConfig(
        flavor: Flavor.QA,
        values: FlavorValues(baseUrl: "https://api.myappventure.de/api"),
        // values:
        //     FlavorValues(baseUrl: "https://appventure-test.fast-rocket.de/api"),
      );
      break;
    case "PROD":
      FlavorConfig(
        flavor: Flavor.PROD,
        values: FlavorValues(baseUrl: "https://api.myappventure.de/api"),
      );
      break;
    case "DEV":
      FlavorConfig(
        flavor: Flavor.DEV,
        values: FlavorValues(baseUrl: "https://api.myappventure.de/api"),
        // values:
        //     FlavorValues(baseUrl: "https://appventure.dev.fast-rocket.de/api"),
      );
      break;
    default:
      FlavorConfig(
        flavor: Flavor.DEV,
        values: FlavorValues(baseUrl: "https://api.myappventure.de/api"),
        // values:
        //     FlavorValues(baseUrl: "https://appventure.dev.fast-rocket.de/api"),
      );
  }

  WidgetsFlutterBinding.ensureInitialized();
  shuffelActivitysList = true;
  await Firebase.initializeApp();
  await HiveService.initHive();
  serviceLocator();
  await CountryUtils.loadCountryNamesAsset().then((countryObjectData) {
    // ignore: unused_local_variable, only for init
    var countryUtilsInstance =
        CountryUtils.getInstance(countryObjects: countryObjectData);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) async {
      HttpOverrides.global = MyHttpOverrides();

      await Hive.initFlutter();
      Hive.openBox('mybox');

      runApp(MultiProvider(providers: [
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => ThemeModel(),
        ),
      ], child: const MyApp()));
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState>? navigatorKey;
    return ChangeNotifierProvider<ThemeModel>(
      create: (BuildContext context) => ThemeModel(),
      child: Consumer<ThemeModel>(builder: (context, model, __) {
        return ScreenUtilInit(
          designSize: const Size(1284, 2778),
          builder: (context, child) => MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              //to add support for each generated language
              //supportedLocales: AppLocalizations.supportedLocales,

              supportedLocales: L10n.all,
              theme: ThemeData(
                dividerColor: model.dividerColor,
                textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: model.textColor, displayColor: model.textColor),
                appBarTheme: AppBarTheme(color: model.primaryMainColor),
                primaryColor: model.primaryMainColor,
                accentColor: model.accentColor,
              ),
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              initialRoute: SplashScreen.route,
              routes: CustomRoutes.routes),
        );
      }),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

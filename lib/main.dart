import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yucatan/routes/custom_routes.dart';
import 'package:yucatan/screens/splash_screen/splash_screen.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'l10n/l10n.dart';

Future<void> main() async {

  await Hive.initFlutter();
  Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState>? navigatorKey;
    return ScreenUtilInit(
      designSize: const Size(1284, 2778),
      builder: (context, child) => MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ], //to add support for each generated language
          //supportedLocales: AppLocalizations.supportedLocales,

          supportedLocales: L10n.all,
          title: 'Yucatan',
          theme: CustomTheme.theme,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: SplashScreen.route,
          routes: CustomRoutes.routes),
    );
  }
}

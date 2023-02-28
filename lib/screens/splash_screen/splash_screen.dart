import 'dart:async';

import 'package:yucatan/screens/onboarding_screen/onboarding_screen.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/size_custom_config.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:device_info/device_info.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splashscreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 4),
      () async {
        var prefs = await SharedPreferences.getInstance();
        bool firstOpenFlag = prefs.getBool("FirstOpen-Flag") ?? true;
        if (firstOpenFlag)
          Navigator.of(context).popAndPushNamed(OnboardingScreen.route);
        else
          Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeCustomConfig().init(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
      Orientation.portrait,
    );

    _setPreferredOrientations();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF052145),
              Color(0xFF004D88),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.getHeight(percentage: 30.0),
            ),
            Container(
              height: Dimensions.getHeight(percentage: 25.0),
              child: RiveAnimation(
                riveFileName: 'app-start.riv',
                riveAnimationName: 'Animation 1',
                placeholderImage: 'lib/assets/images/appventure_icon_white.png',
                startAnimationAfterMilliseconds: 0,
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(30.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.splashScreen_text1,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(22.0),
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.splashScreen_text2,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(22.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setPreferredOrientations() async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo info = await deviceInfo.iosInfo;
      if (info.model.toLowerCase().contains("ipad")) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      var smallestDimension = MediaQuery.of(context).size.shortestSide;
      final isTablet = smallestDimension >= 600;

      if (isTablet) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
  }
}

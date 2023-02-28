import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoNetworkScreen extends StatefulWidget {
  final VoidCallback? callback;

  NoNetworkScreen({this.callback});

  @override
  _NoNetworkScreenState createState() {
    return _NoNetworkScreenState();
  }
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            AppLocalizations.of(context)!.noNetworkScreen_noNetwork,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: CustomTheme.letterSpacing,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            /*child: Image.asset(
              "lib/assets/images/booking_list_empty.png",
              fit: BoxFit.cover,
            ),*/
            child: RiveAnimation(
              riveFileName: 'internet_connection_animiert_loop.riv',
              riveAnimationName: 'Animation 1',
              placeholderImage: 'lib/assets/images/no_internet_connection.png',
              startAnimationAfterMilliseconds: 0,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            width: 180,
            child: OutlinedButton(
              onPressed: () {
                widget.callback!();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noNetworkScreen_refresh,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.sync,
                    color: CustomTheme.primaryColorDark,
                  )
                ],
              ),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor:
                      MaterialStateProperty.all(CustomTheme.primaryColorDark),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(
                          color: CustomTheme.primaryColorDark,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)))),
            ),
          ),
        ],
      ),
    );
  }
}

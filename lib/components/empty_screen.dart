import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/utils/widget_dimensions.dart';

class EmptyScreen extends StatelessWidget {
  final Function onClick;
  final String buttonText;
  final String screenTitle;
  final double topPadding;

  EmptyScreen({
    required this.buttonText,
    required this.onClick,
    required this.screenTitle,
    required this.topPadding,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: Scaffold.of(context).appBarMaxHeight),
          SizedBox(height: topPadding),
          Expanded(flex: 3, child: Container()),
          Text(
            AppLocalizations.of(context)!.commonWords_mistake,
            style: TextStyle(
              color: CustomTheme.primaryColorDark,
              fontSize: Dimensions.getScaledSize(20.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Dimensions.getScaledSize(20.0)),
          Text(
            screenTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(16.0),
                letterSpacing: CustomTheme.letterSpacing,
                color: CustomTheme.primaryColorDark),
          ),
          SizedBox(height: Dimensions.getScaledSize(30.0)),
          SizedBox(
            height: Dimensions.getHeight(percentage: 35.0),
            child: Image.asset(
              "lib/assets/images/favorites_empty.png",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(flex: 2, child: Container()),
          Container(
            width: Dimensions.getWidth(percentage: 50),
            height: Dimensions.getScaledSize(45.0),
            child: OutlinedButton(
              onPressed: () {
                onClick();
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(20.0),
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(BorderSide(
                    color: CustomTheme.primaryColorDark,
                  )),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor:
                      MaterialStateProperty.all(CustomTheme.primaryColorDark),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(7)),
                  ))),
            ),
          ),
          Expanded(flex: 5, child: Container()),
        ],
      ),
    );
  }
}

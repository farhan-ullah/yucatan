import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QrFeedback extends StatelessWidget {
  final String text;
  final String title;
  final Function goBack;
  final String mode;

  QrFeedback(
      {@required this.title,
      @required this.text,
      @required this.mode,
      @required this.goBack});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    // double titleSize = displayHeight * 0.02;
    // double textSize = displayHeight * 0.018;

    Color color;
    String imagePath;
    if (mode == "SUCCESS") {
      color = Colors.green;
      imagePath = "lib/assets/images/warning.png";
    } else if (mode == "ERROR" || mode == "REDEEMED") {
      color = Colors.red;
      imagePath = "lib/assets/images/warning.png";
    }

    return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 0.1 * displayWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.getScaledSize(24.0))),
        ),
        child: Container(
          margin: EdgeInsets.only(top: displayHeight * 0.01),
          constraints: BoxConstraints(maxHeight: 0.55 * displayHeight),
          //height: displayHeight - (0.5 * displayHeight).round(),
          width: displayWidth - (0.3 * displayWidth.round()),
          padding: EdgeInsets.symmetric(horizontal: displayWidth * 0.08),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Dimensions.getScaledSize(24.0)),
              color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
                height: displayWidth * 0.5,
                width: displayWidth * 0.5,
              ),
              SizedBox(height: 0.03 * displayHeight),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontFamily: "AcuminProWide",
                    fontWeight: FontWeight.bold,
                    fontSize: 0.02 * displayHeight),
              ),
              SizedBox(height: 0.03 * displayHeight),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomTheme.primaryColorDark,
                    fontFamily: "AcuminProWide",
                    fontWeight: FontWeight.w200,
                    fontSize: 0.018 * displayHeight),
              ),
              Expanded(child: Container()),
              SizedBox(
                width: displayWidth * 0.35,
                child: OutlinedButton(
                  onPressed: () => goBack(),
                  child: Text(
                    mode != "REDEEMED"
                        ? AppLocalizations.of(context).actions_back
                        : AppLocalizations.of(context).commonWords_ok,
                    style: TextStyle(
                        color: CustomTheme.primaryColorDark,
                        fontFamily: "AcuminProWide",
                        fontWeight: FontWeight.bold,
                        fontSize: displayHeight * 0.015),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.035 * displayHeight),
            ],
          ),
        ));
  }
}

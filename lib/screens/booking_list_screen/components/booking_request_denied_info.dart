import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingRequestDeniedInfo extends StatelessWidget {
  final String text;
  final String titleText;

  BookingRequestDeniedInfo({
    required this.text,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    final double displayHeight = MediaQuery.of(context).size.height;
    final double displayWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: displayWidth * 0.1, vertical: displayHeight * 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 0.05 * displayWidth, vertical: 0.03 * displayHeight),
        height: 0.45 * displayHeight,
        width: 0.78 * displayHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: CustomTheme.primaryColorDark,
                    size: 30,
                  ),
                ),
              ],
            ),
            Expanded(flex: 1, child: Container()),
            Icon(
              Icons.info_outline,
              color: CustomTheme.accentColor1,
              size: 35,
            ),
            SizedBox(
              height: 0.02 * displayHeight,
            ),
            Text(
              titleText != null ? titleText : "",
              //AppLocalizations.of(context)!.bookingListScreen_requestDenied,
              style: TextStyle(
                fontFamily: "AcuminProWide",
                fontWeight: FontWeight.w600,
                color: CustomTheme.accentColor1,
                fontSize: 0.025 * displayHeight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 0.03 * displayHeight,
            ),
            Container(
              height: Dimensions.getHeight(percentage: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Text(
                    text != null ? text : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: CustomTheme.fontFamily,
                        fontSize: 0.02 * displayHeight,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(flex: 4, child: Container()),
            BookingListRequestDeniedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              buttonText: AppLocalizations.of(context)!.commonWords_ok,
              color: CustomTheme.accentColor1,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingListRequestDeniedButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final Function onPressed;
  BookingListRequestDeniedButton(
      {required this.color, required this.buttonText, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.31,
      child: OutlinedButton(
        onPressed: onPressed(),
        child: Text(
          buttonText,
          style: TextStyle(
              color: color,
              fontFamily: "AcuminProWide",
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.015),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: color,
          ),
        ),
      ),
    );
  }
}

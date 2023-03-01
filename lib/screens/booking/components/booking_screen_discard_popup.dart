import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingScreenDiscardPopup extends StatelessWidget {
  final bool? showDiscardContainer;
  final Function? onCancel;

  BookingScreenDiscardPopup({
    this.showDiscardContainer,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 500,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        height: showDiscardContainer!
            ? MediaQuery.of(context).size.height -
                Dimensions.getScaledSize(60.0) -
                MediaQuery.of(context).padding.bottom -
                MediaQuery.of(context).padding.top
            : 0,
        width: MediaQuery.of(context).size.width,
        color: CustomTheme.primaryColorDark.withOpacity(0.3),
        child: Stack(
          children: [
            IntrinsicHeight(
              // color: Colors.white,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/images/warning.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(5.0),
                    ),
                    Text(
                      AppLocalizations.of(context)!.bookingScreen_warning,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(20.0),
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.accentColor1,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(5.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Dimensions.getScaledSize(24.0),
                        right: Dimensions.getScaledSize(24.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .bookingScreen_closeWindowSelectionWarning,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(18.0),
                          color: CustomTheme.darkGrey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(15.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(200.0),
                      child: OutlinedButton(
                        onPressed: () {
                          onCancel!();
                        },
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                              width: 1,
                              color: CustomTheme.darkGrey,
                            )),
                            overlayColor: MaterialStateProperty.all(
                                CustomTheme.primaryColorDark)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.bookingScreen_next,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(16.0),
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(5.0),
                    ),
                    Container(
                      width: Dimensions.getScaledSize(200.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                              width: 1,
                              color: CustomTheme.darkGrey,
                            )),
                            overlayColor: MaterialStateProperty.all(
                                CustomTheme.primaryColorDark)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.bookingScreen_discard,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(16.0),
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.accentColor1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(30.0),
                    ),
                    ColoredDivider(
                      height: Dimensions.getScaledSize(5.0),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Dimensions.getScaledSize(18.0),
              left: Dimensions.getScaledSize(18.0),
              child: GestureDetector(
                onTap: () {
                  onCancel!();
                },
                child: Container(
                  height: Dimensions.getScaledSize(32.0),
                  width: Dimensions.getScaledSize(32.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(48.0)),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: Dimensions.getScaledSize(24.0),
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

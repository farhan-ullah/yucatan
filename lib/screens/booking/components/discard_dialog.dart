import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscardDialog extends StatefulWidget {
  final bool isComingFromAdditionalService;
  DiscardDialog(
      this.callback, this.callBackClose, this.isComingFromAdditionalService);
  final VoidCallback callback;
  final VoidCallback callBackClose;

  @override
  _DiscardDialogState createState() {
    return _DiscardDialogState();
  }
}

class _DiscardDialogState extends State<DiscardDialog> {
  @override
  Widget build(BuildContext context) {
    final double displayHeight = MediaQuery.of(context).size.height;
    final double displayWidth = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: displayWidth * 0.1, vertical: displayHeight * 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 0.0,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Wrap(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(
                    right: Dimensions.getScaledSize(20),
                    top: Dimensions.getScaledSize(20)),
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
                    color: CustomTheme.primaryColorDark,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: Dimensions.getScaledSize(10),
              left: Dimensions.getScaledSize(10),
              right: Dimensions.getScaledSize(10),
            ),
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
                    fontSize: Dimensions.getScaledSize(18.0),
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
                    widget.isComingFromAdditionalService
                        ? AppLocalizations.of(context)!
                            .bookingScreen_closeWindowWarning
                        : AppLocalizations.of(context)!
                            .bookingScreen_closeWindowSelectionWarning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(16.0),
                      color: CustomTheme.primaryColorDark,
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
                      Navigator.of(context).pop();
                      widget.callBackClose();
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(
                            CustomTheme.primaryColorDark),
                        side: MaterialStateProperty.all(BorderSide(
                          width: 1,
                          color: CustomTheme.darkGrey,
                        ))),
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
                      widget.callback();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(
                            CustomTheme.primaryColorDark),
                        side: MaterialStateProperty.all(BorderSide(
                          width: 1,
                          color: CustomTheme.accentColor1,
                        ))),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.bookingScreen_clear,
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
                  height: Dimensions.getScaledSize(20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

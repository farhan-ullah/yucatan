import 'package:appventure/components/black_divider.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingScreenAddButton extends StatelessWidget {
  final Function nextBookingStep;

  BookingScreenAddButton({@required this.nextBookingStep});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Dimensions.getScaledSize(65.0) +
          MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.getScaledSize(10.0),
          ),
          BlackDivider(
            height: Dimensions.getScaledSize(1.0),
          ),
          GestureDetector(
            onTap: () {
              nextBookingStep();
            },
            child: Container(
              padding: EdgeInsets.only(
                top: Dimensions.getScaledSize(15.0),
                bottom: Dimensions.getScaledSize(15.0),
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: Text(
                  AppLocalizations.of(context).bookingScreen_add,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(20.0),
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.primaryColorDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

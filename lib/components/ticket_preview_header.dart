import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TicketPreviewHeader extends StatelessWidget {
  final String ticketNumber;
  final Color headerColor;
  TicketPreviewHeader(
      {required this.ticketNumber,
      this.headerColor = CustomTheme.primaryColorDark});

  @override
  Widget build(BuildContext context) {
    // double displayHeight = MediaQuery.of(context).size.height;
    // double displayWidth = MediaQuery.of(context).size.width;

    return Container(
      height: Dimensions.getScaledSize(50.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.getScaledSize(24.0)),
        ),
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getScaledSize(15.0),
        ),
        height: Dimensions.getScaledSize(50.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.getScaledSize(24.0)),
          ),
          color: headerColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/images/appventure_logo_pos.svg',
              height: Dimensions.getScaledSize(30.0),
              color: Colors.white,
            ),
            Expanded(child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.helloWorld,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(11.0),
                    color: Colors.white,
                  ),
                ),
                Text(
                  ticketNumber,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(11.0),
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
}

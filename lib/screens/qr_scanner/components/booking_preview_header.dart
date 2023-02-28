import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//taken from the \lib\screens\booking_list_screen\components\booking_ticket_list.dart lines 100 - 139

class BookingPreviewHeader extends StatelessWidget {
  final String ticketNumber;
  BookingPreviewHeader({required this.ticketNumber});
  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth * 0.04,
      ),
      height: displayHeight * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.getScaledSize(24.0)),
          topRight: Radius.circular(Dimensions.getScaledSize(24.0)),
        ),
        color: CustomTheme.primaryColorDark,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'lib/assets/images/appventure_logo_pos.svg',
            height: displayHeight * 0.037,
            color: Colors.white,
          ),
          Expanded(child: Container()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.bookingListScreen_ticketNumber,
                style: TextStyle(
                  fontSize: 0.03 * displayWidth,
                  color: Colors.white,
                ),
              ),
              Text(
                ticketNumber,
                style: TextStyle(
                  fontSize: 0.03 * displayWidth,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

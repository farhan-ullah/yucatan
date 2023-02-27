import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

import 'booking_dialog_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingDeleteDialog extends StatelessWidget {
  final Function delete;

  BookingDeleteDialog({
    @required this.delete,
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
        height: 0.4 * displayHeight,
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
                    size: Dimensions.getScaledSize(30.0),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.info_outline,
              color: CustomTheme.accentColor1,
              size: Dimensions.getScaledSize(40.0),
            ),
            SizedBox(
              height: 0.02 * displayHeight,
            ),
            Text(
              AppLocalizations.of(context).bookingScreen_deleteProduct,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 0.02 * displayHeight,
                color: CustomTheme.primaryColorDark,
              ),
            ),
            SizedBox(
              height: 0.1 * displayHeight,
            ),
            BookingDialogButton(
              onPressed: () {
                delete();
                Navigator.of(context).pop();
              },
              buttonText: AppLocalizations.of(context).actions_confirm,
              color: CustomTheme.primaryColorDark,
            ),
          ],
        ),
      ),
    );
  }
}

// Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               BookingDeleteDialogwButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 buttonText: "Back",
//                 color: CustomTheme.accentColor2,
//               ),

//             ],
//           ),

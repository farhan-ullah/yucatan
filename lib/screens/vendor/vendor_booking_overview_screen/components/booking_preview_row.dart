import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VendorBookingPreviewRow extends StatelessWidget {
  final VendorBookingPreviewModel transaction;
  final Color color;
  final Function onTap;
  final double height;
  final double fontSize;

  VendorBookingPreviewRow(
      {required this.transaction,
      required this.color,
      required this.onTap,
      required this.height,
      required this.fontSize});

  _getCellStyle({Color? textColor}) {
    return TextStyle(
      fontFamily: "AcuminProWide",
      color: textColor == null ? color : textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w200,
    );
  }

  _getCell({int? flex, String? text, TextAlign? alignment, Color? textColor}) {
    return Expanded(
      flex: flex!,
      child: Text(
        text!,
        textAlign: alignment,
        style: _getCellStyle(textColor: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration:
            transaction.transactionModel.bookingState == "REQUEST_DENIED"
                ? BoxDecoration(
                    color: CustomTheme.mediumGrey,
                  )
                : null,
        height: height,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getCell(
                flex: 3,
                text:
                    '${DateFormat('dd.MM.yyyy', 'de-DE').format(transaction.dateTime)}',
                alignment: TextAlign.left,
                textColor: getTextColor()),
            _getCell(
                flex: 2,
                text: transaction.tickets,
                alignment: TextAlign.center,
                textColor: getTextColor()),
            _getCell(
                flex: 6,
                text: transaction.buyer,
                alignment: TextAlign.left,
                textColor: getTextColor()),
            _getCell(
                flex: 3,
                text: formatPriceDouble(transaction.totalPrice),
                alignment: TextAlign.right,
                textColor: getTextColor()),
          ],
        ),
      ),
    );
  }

  Color getTextColor() {
    Color textColor;
    if (transaction.transactionModel.bookingState == "REQUEST_DENIED") {
      textColor = Color(0xFF8B8B8B);
    } else {
      textColor = this.color;
    }
    return textColor;
  }
}

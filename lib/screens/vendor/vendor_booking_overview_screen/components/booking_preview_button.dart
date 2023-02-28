import 'package:flutter/material.dart';

class VendorBookingPreviewButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final Function onPressed;
  final double width;
  final double fontSize;
  final FontWeight fontWeight;
  VendorBookingPreviewButton(
      {required this.color,
      required this.buttonText,
      required this.onPressed,
      required this.width,
      required this.fontSize,
      this.fontWeight = FontWeight.bold});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: () => onPressed(),
        child: Text(
          buttonText,
          style: TextStyle(
            color: color,
            fontFamily: "AcuminProWide",
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
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

import 'package:flutter/material.dart';

class VendorBookingPreviewFeedback extends StatelessWidget {
  final String text;
  final Color textColor;

  VendorBookingPreviewFeedback({required this.textColor, required this.text});

  Widget build(BuildContext context) {
    final displayHeight = MediaQuery.of(context).size.height;
    final displayWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: displayWidth * 0.03, vertical: 0.2 * displayHeight),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "AcuminProWide",
              color: textColor,
              fontSize: displayHeight * 0.02,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

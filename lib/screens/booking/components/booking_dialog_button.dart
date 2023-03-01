import 'package:flutter/material.dart';

class BookingDialogButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final Function onPressed;
  BookingDialogButton(
      {required this.color, required this.buttonText, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.31,
      child: OutlinedButton(
        onPressed: onPressed(),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: color,
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              color: color,
              fontFamily: "AcuminProWide",
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.015),
        ),
      ),
    );
  }
}

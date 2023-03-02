import 'package:flutter/material.dart';

class VendorBookingDateButton extends StatelessWidget {
  final String? text;
  final bool? selected;
  final Function? onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;
  VendorBookingDateButton(
      {this.text,
      this.selected,
      this.onTap,
      this.width,
      this.height,
      this.fontSize,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap!(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected! ? color : Colors.white,
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: selected! ? Colors.white : color,
                backgroundColor: selected! ? color : Colors.white),
          ),
        ),
      ),
    ));
  }
}

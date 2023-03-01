import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class VendorBookingOverviewTab extends StatelessWidget {
  final String? text;
  final double? height;
  final Color? color;
  final bool? selected;
  final Function? onTap;
  final double? fontSize;

  VendorBookingOverviewTab(
      {this.text,
      this.height,
      this.color,
      this.selected,
      this.onTap,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap!(),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.getScaledSize(8.0)),
              topRight: Radius.circular(Dimensions.getScaledSize(8.0)),
            ),
            color: color,
          ),
          padding: EdgeInsets.only(top: Dimensions.getScaledSize(5.0)),
          child: Container(
            decoration: BoxDecoration(color: selected! ? Colors.white : color),
            child: Center(
              child: Text(
                text!,
                style: TextStyle(
                    fontFamily: "AcuminProWide",
                    color: selected! ? color : Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w200),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

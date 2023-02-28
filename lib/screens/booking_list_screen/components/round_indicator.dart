import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final active;
  RoundIndicator({required this.active});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    // double indicatorWidth = displayWidth * 0.08;
    double spaceBetween = displayWidth * 0.0125;
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: spaceBetween),
      height: Dimensions.getScaledSize(8.0),
      width: Dimensions.getScaledSize(8.0),
      decoration: BoxDecoration(
        color: active ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}

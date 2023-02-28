import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final active;
  Indicator({required this.active});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double indicatorWidth = displayWidth * 0.08;
    double spaceBetween = displayWidth * 0.0125;
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: spaceBetween),
      height: 2.0,
      width: indicatorWidth,
      decoration: BoxDecoration(
        color: active ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

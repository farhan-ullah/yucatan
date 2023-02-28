import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final double width;
  final double unitHeight;

  const DashedDivider({
    required this.height,
    this.width = 1,
    this.unitHeight = 3,
  });

  @override
  Widget build(BuildContext context) {
    double units = height / (unitHeight * 3);
    List<Widget> unitWidgets = [];

    for (var i = 0; i < units; i++) {
      unitWidgets.add(
        Container(
          height: unitHeight * 0.75,
          width: width,
          color: Colors.white,
        ),
      );

      unitWidgets.add(
        Container(
          height: unitHeight * 1.5,
          width: width,
          color: CustomTheme.darkGrey,
        ),
      );

      unitWidgets.add(
        Container(
          height: unitHeight * 0.75,
          width: width,
          color: Colors.white,
        ),
      );
    }

    return Column(
      children: unitWidgets,
    );
  }
}

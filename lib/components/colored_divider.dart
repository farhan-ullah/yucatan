import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';

class ColoredDivider extends StatelessWidget {
  final double height;

  ColoredDivider({this.height = 5});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CustomTheme.primaryColorLight,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CustomTheme.primaryColor,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CustomTheme.primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CustomTheme.accentColor1,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CustomTheme.accentColor2,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CustomTheme.accentColor3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

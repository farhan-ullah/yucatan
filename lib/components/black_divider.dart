import 'package:flutter/material.dart';
import 'package:yucatan/theme/custom_theme.dart';


class BlackDivider extends StatelessWidget {
  final double height;

  BlackDivider({this.height = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      color: CustomTheme.mediumGrey,
    );
  }
}

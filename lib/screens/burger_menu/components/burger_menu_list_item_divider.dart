import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BurgerMenuListItemDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimensions.pixels_10,
        decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3))),
        ));
  }
}

import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BurgerMenuListItemSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimensions.getScaledSize(35.0),
        decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3))),
        ));
  }
}

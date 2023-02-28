import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class BookingListActionButton extends StatelessWidget {
  final Function action;
  final IconData iconData;
  final Color iconColor;
  final String text;
  final bool requestedOrRefunded;
  final Color backgroundColor;

  BookingListActionButton(
      {required this.action,
      required this.iconData,
      required this.iconColor,
      required this.text,
      required this.requestedOrRefunded,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (requestedOrRefunded) return;
            action();
          },
          child: Container(
            margin: EdgeInsets.all(Dimensions.getScaledSize(3.0)),
            width: Dimensions.getScaledSize(44.0),
            height: Dimensions.getScaledSize(44.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  100,
                ),
              ),
              color: requestedOrRefunded
                  ? CustomTheme.mediumGrey.withOpacity(0.5)
                  : backgroundColor.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: Dimensions.getScaledSize(28.0),
                color: requestedOrRefunded
                    ? CustomTheme.darkGrey.withOpacity(0.5)
                    : iconColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(5.0),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(11.0),
            color: requestedOrRefunded
                ? CustomTheme.darkGrey.withOpacity(0.5)
                : Colors.black,
          ),
        ),
      ],
    );
  }
}

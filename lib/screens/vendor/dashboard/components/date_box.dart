import 'package:flutter/material.dart';

import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/image_util.dart';

class VendorDashboardDateBox extends StatelessWidget {
  final bool isLoading;
  final Function onClick;
  final String openBookingsForDay;
  final String boxText;
  final double elementWidth;
  final double elementHeight;

  VendorDashboardDateBox(
      {required this.isLoading,
      required this.onClick,
      required this.openBookingsForDay,
      required this.boxText,
      required this.elementWidth,
      required this.elementHeight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick(),
      child: Container(
        height: elementHeight,
        width: elementWidth,
        decoration: BoxDecoration(
            color: isLoading ? Colors.grey[300] : Colors.white,
            border:
                Border.all(color: isLoading ? Colors.grey[300]! : Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: isLoading
            ? ImageUtil.showShimmerPlaceholder(
                width: elementWidth, height: elementHeight)
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        boxText,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 16,
                            color: CustomTheme.primaryColorLight,
                            fontFamily: CustomTheme.fontFamily,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isLoading ? "" : "$openBookingsForDay",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CustomTheme.primaryColorLight,
                            fontFamily: CustomTheme.fontFamily,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: Icon(Icons.calendar_today_outlined,
                                  color: CustomTheme.primaryColorLight)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

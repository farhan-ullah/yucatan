import 'package:flutter/material.dart';
import 'package:yucatan/size_config.dart';
import 'package:yucatan/utils/image_util.dart';

class VendorDashboardPlaceHolder extends StatelessWidget {
  final double widgetWidth;
  final double widgedHeight;

  VendorDashboardPlaceHolder(
      {required this.widgedHeight, required this.widgetWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenWidth! / 3.2,
        width: SizeConfig.screenWidth! / 3.4,
        margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(
              color: Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ImageUtil.showShimmerPlaceholder(
          width: SizeConfig.screenWidth! / 3.4,
          height: SizeConfig.screenWidth! / 3.2,
        ));
  }
}

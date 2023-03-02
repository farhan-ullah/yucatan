import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationListViewShimmer extends StatelessWidget {
  final double? width;

  const NotificationListViewShimmer({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          // height: Dimensions.pixels_100,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getScaledSize(10.0),
            vertical: Dimensions.getScaledSize(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Dimensions.getScaledSize(80.0),
                width: Dimensions.getScaledSize(80.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomTheme.hintText,
                    width: Dimensions.getScaledSize(3.0),
                  ),
                  borderRadius: BorderRadius.circular(60),
                  color: CustomTheme.mediumGrey,
                ),
                child: Center(
                  child: Icon(
                    Icons.home_work_outlined,
                    size: Dimensions.getScaledSize(40.0),
                    color: CustomTheme.darkGrey,
                  ),
                ),
              ),
              SizedBox(
                width: Dimensions.getScaledSize(10.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              Dimensions.getScaledSize(16.0))),
                      width: width! * 0.25,
                      height: Dimensions.getScaledSize(17.0),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(5.0),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              Dimensions.getScaledSize(16.0))),
                      width: width! * 0.5,
                      height: Dimensions.getScaledSize(30.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimensions.getScaledSize(10.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            Dimensions.getScaledSize(16.0))),
                    width: Dimensions.getScaledSize(40.0),
                    height: Dimensions.getScaledSize(10.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

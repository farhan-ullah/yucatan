import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class RecommendedActivitiesItemTitle extends StatelessWidget {
  final ActivityModel activity;

  RecommendedActivitiesItemTitle({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.getScaledSize(10.0),
        right: Dimensions.getScaledSize(10.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          activity.title!,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.getScaledSize(14.0),
              color: CustomTheme.titleColor),
        ),
      ),
    );
  }
}

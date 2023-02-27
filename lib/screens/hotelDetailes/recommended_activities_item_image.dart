import 'package:appventure/models/activity_model.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/networkImage/network_image_loader.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class RecommendedActivitiesItemImage extends StatelessWidget {
  final ActivityModel activity;

  RecommendedActivitiesItemImage({@required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.getScaledSize(45.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(CustomTheme.borderRadius),
          topRight: Radius.circular(
            CustomTheme.borderRadius,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: loadCachedNetworkImage(
            activity.thumbnail?.publicUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

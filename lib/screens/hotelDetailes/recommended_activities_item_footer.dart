import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedActivitiesItemFooter extends StatelessWidget {
  final ActivityModel activity;

  RecommendedActivitiesItemFooter({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimensions.getScaledSize(10.0),
          bottom: Dimensions.getScaledSize(10.0)),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0),
            child: SmoothStarRating(
              allowHalfRating: true,
              starCount: 5,
              rating: activity.reviewAverageRating ?? 0,
              size: Dimensions.getScaledSize(15.0),
              color: Colors.yellow,
              borderColor: Colors.yellow,
            ),
          ),
          Text(
            ' | ',
            style: TextStyle(fontSize: Dimensions.getScaledSize(12.0)),
          ),
          Text(
            "activity.reviewCount",
            // AppLocalizations.of(context)!
            //     .hotelDetailesScreen_reviewCountHandlePlural(
            //         activity.reviewCount),
            style: TextStyle(fontSize: Dimensions.getScaledSize(12.0)),
          ),
        ],
      ),
    );
  }
}

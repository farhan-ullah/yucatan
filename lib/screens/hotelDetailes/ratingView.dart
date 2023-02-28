import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingView extends StatelessWidget {
  final ActivityModel hotelData;

  const RatingView({Key? key, this.hotelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: Dimensions.getScaledSize(80.0),
              child: Text(
                hotelData.reviewAverageRating.toString().replaceAll('.', ','),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.getScaledSize(38.0),
                  color: CustomTheme.primaryColorDark,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.getScaledSize(8.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)
                          .hotelDetailesScreen_overallRating,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.getScaledSize(16.0),
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                    SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: hotelData.reviewAverageRating,
                      size: Dimensions.getScaledSize(24.0),
                      color: CustomTheme.accentColor3,
                      borderColor: CustomTheme.accentColor3,
                      isReadOnly: true,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: Dimensions.getScaledSize(4.0),
        ),
      ],
    );
  }
}

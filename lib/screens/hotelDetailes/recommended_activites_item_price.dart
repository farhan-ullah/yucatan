import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedActivitiesItemPrice extends StatelessWidget {
  final ActivityModel activity;

  RecommendedActivitiesItemPrice({required this.activity});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.getScaledSize(10.0),
        right: Dimensions.getScaledSize(10.0),
        bottom: Dimensions.getScaledSize(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "${AppLocalizations.of(context)!.commonWords_from} ",
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(12.0),
                fontWeight: FontWeight.bold,
                letterSpacing: CustomTheme.letterSpacing),
          ),
          Text(
            '${formatPriceDouble(activity.priceFrom!)}€',
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(22.0),
                fontWeight: FontWeight.bold,
                letterSpacing: CustomTheme.letterSpacing),
          ),
        ],
      ),
    );
  }
}

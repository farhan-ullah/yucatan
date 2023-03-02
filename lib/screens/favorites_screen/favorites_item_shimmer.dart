import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FavoritesItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: Dimensions.getScaledSize(170.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.getScaledSize(16.0)),
        color: Colors.white,
      ),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.getScaledSize(16.0)),
                    bottomLeft: Radius.circular(Dimensions.getScaledSize(16.0)),
                  ),
                  child: Container(
                      color: Colors.grey,
                      constraints: BoxConstraints.expand() // fully fill parent
                      ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.getScaledSize(5.0),
                    bottom: Dimensions.getScaledSize(5.0),
                    left: Dimensions.getScaledSize(10.0),
                    right: Dimensions.getScaledSize(10.0),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.getScaledSize(16.0)),
                      bottomRight:
                          Radius.circular(Dimensions.getScaledSize(16.0)),
                    ),
                    border: Border.all(
                      color: CustomTheme.mediumGrey,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                Dimensions.getScaledSize(16.0))),
                        width: width * 0.35,
                        height: Dimensions.getScaledSize(16.0),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(5.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                Dimensions.getScaledSize(16.0))),
                        width: width * 0.5,
                        height: Dimensions.getScaledSize(13.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                Dimensions.getScaledSize(16.0))),
                        width: width * 0.25,
                        height: Dimensions.getScaledSize(13.0),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(12.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: Dimensions.getScaledSize(4.0),
                          ),
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: Dimensions.getScaledSize(12.0),
                            color: CustomTheme.primaryColor,
                          ),
                          SizedBox(
                            width: Dimensions.getScaledSize(5.0),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.getScaledSize(16.0))),
                              width: width * 0.05,
                              height: Dimensions.getScaledSize(13.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.getScaledSize(4.0)),
                        child: Row(
                          children: <Widget>[
                            SmoothStarRating(
                              isReadOnly: true,
                              allowHalfRating: true,
                              starCount: 5,
                              rating: 5,
                              size: Dimensions.getScaledSize(20.0),
                              color: CustomTheme.accentColor3,
                              borderColor: CustomTheme.primaryColor,
                            ),
                            /*activity.reviewCount > 0
                            ? Text(
                          " ${activity.reviewAverageRating.toString().replaceAll('.', ',')}",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.withOpacity(0.8)),
                        )
                            : Container(),*/
                            Container(),
                          ],
                        ),
                      ),
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .favoritesScreen_availableFrom,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(13.0),
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(
                            width: Dimensions.getScaledSize(5.0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.getScaledSize(16.0))),
                            width: width * 0.1,
                            height: Dimensions.getScaledSize(20.0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

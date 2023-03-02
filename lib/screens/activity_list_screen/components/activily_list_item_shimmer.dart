import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityListViewShimmer extends StatelessWidget {
  final double? width;
  final bool isComingFromFullMapScreen;

  const ActivityListViewShimmer(
      {Key? key, this.width, this.isComingFromFullMapScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(12.0),
            top: Dimensions.getScaledSize(8.0),
            bottom: Dimensions.getScaledSize(8.0),
            right: Dimensions.getScaledSize(12.0)),
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.getScaledSize(16.0))),
                color: CustomTheme.backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: Dimensions.getScaledSize(6.0),
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.getScaledSize(16.0))),
                //Shimmer.fromColors(child: null, baseColor: null, highlightColor: null)
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                height: Dimensions.getHeight(percentage: 20.0),
                                child: null, // placeholder
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: Dimensions.getHeight(percentage: 9.0),
                                  width: width,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        CustomTheme.primaryColor
                                            .withOpacity(0.8),
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: Dimensions.getScaledSize(10.0),
                                child: Container(
                                  width: width,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.getScaledSize(12.0)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.getScaledSize(
                                                          16.0))),
                                          width: width! * 0.5,
                                          height:
                                              Dimensions.getScaledSize(17.0),
                                        ),
                                        SizedBox(
                                          height:
                                              Dimensions.getScaledSize(28.0),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.getScaledSize(
                                                          16.0))),
                                          width: width! * 0.75,
                                          height:
                                              Dimensions.getScaledSize(13.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          /*Positioned(
                              top: Dimensions.getScaledSize(8.0),
                              right: Dimensions.getScaledSize(8.0),
                              child: Container(
                                height: Dimensions.getScaledSize(32.0),
                                width: Dimensions.getScaledSize(32.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(48),
                                  color: Colors.white
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: Dimensions.getScaledSize(24.0),
                                    color: Colors.white
                                  ),
                                ),
                              )
                          )*/
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.getScaledSize(8.0)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    Dimensions.getScaledSize(
                                                        5.0),
                                              ),
                                              Visibility(
                                                  visible:
                                                      !isComingFromFullMapScreen,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: Dimensions
                                                            .getScaledSize(4.0),
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .mapMarkerAlt,
                                                        size: Dimensions
                                                            .getScaledSize(
                                                                12.0),
                                                        color: CustomTheme
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions
                                                            .getScaledSize(5),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0)),
                                                        width: width! * 0.33,
                                                        height: Dimensions
                                                            .getScaledSize(
                                                                13.0),
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: Dimensions.getScaledSize(
                                                        !isComingFromFullMapScreen
                                                            ? 4.0
                                                            : 0)),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    SmoothStarRating(
                                                      isReadOnly: true,
                                                      allowHalfRating: true,
                                                      starCount: 1,
                                                      rating: 1,
                                                      size: Dimensions
                                                          .getScaledSize(20.0),
                                                      color: CustomTheme
                                                          .accentColor3,
                                                      borderColor: CustomTheme
                                                          .primaryColor,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions
                                                              .getScaledSize(
                                                                  2.0),
                                                          bottom: Dimensions
                                                              .getScaledSize(
                                                                  2.0)),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0)),
                                                        width: width! * 0.33,
                                                        height: Dimensions
                                                            .getScaledSize(
                                                                13.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Row(
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              children: [
                                                Text(
                                                  "${AppLocalizations.of(context)!.activityScreen_from} ",
                                                  style: TextStyle(
                                                      fontSize: Dimensions
                                                          .getScaledSize(13.0),
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  width: width! * 0.1,
                                                  height:
                                                      Dimensions.getScaledSize(
                                                          21.0),
                                                ),
                                                Text(
                                                  "€",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .getScaledSize(18.0),
                                                      color: CustomTheme
                                                          .primaryColorDark),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

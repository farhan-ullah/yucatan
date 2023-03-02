import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VendorActivityOverviewListViewShimmer extends StatelessWidget {
  final double? width;
  final bool isComingFromFullMapScreen;

  const VendorActivityOverviewListViewShimmer(
      {Key? key, this.width, this.isComingFromFullMapScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(12.0),
            top: Dimensions.getScaledSize(25.0),
            bottom: Dimensions.getScaledSize(0.0),
            right: Dimensions.getScaledSize(12.0)),
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: Dimensions.getHeight(percentage: 20),
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
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: <Widget>[
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
                            Container(
                              width: Dimensions.getWidth(percentage: 30),
                              height: Dimensions.getHeight(percentage: 20),
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  width: width! * 0.33,
                                  height: Dimensions.getScaledSize(13.0),
                                ),
                              ),
                            ),
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
                                                                        5.0)),
                                                        width: width! * 0.33,
                                                        height: Dimensions
                                                            .getScaledSize(
                                                                13.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                                                                        5.0)),
                                                        width: width! * 0.33,
                                                        height: Dimensions
                                                            .getScaledSize(
                                                                50.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 10, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              width: width! * 0.1,
                                              height: Dimensions.getScaledSize(
                                                  21.0),
                                            ),
                                          )
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

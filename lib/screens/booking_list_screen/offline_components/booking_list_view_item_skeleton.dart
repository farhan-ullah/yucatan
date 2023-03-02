import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingListViewItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.22,
      child: Shimmer.fromColors(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.22,
          margin:
              EdgeInsets.symmetric(vertical: Dimensions.getScaledSize(10.0)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.getScaledSize(16.0)),
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.015,
                          margin: EdgeInsets.only(
                            top: Dimensions.getScaledSize(5.0),
                            left: Dimensions.getScaledSize(10.0),
                            right: Dimensions.getScaledSize(10.0),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getScaledSize(5.0),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.015,
                          margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.getScaledSize(10.0),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.getScaledSize(16.0)),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getScaledSize(10.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.height * 0.06,
                              height: MediaQuery.of(context).size.height * 0.06,
                              margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.getScaledSize(10.0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.getScaledSize(200.0)),
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.height * 0.06,
                              height: MediaQuery.of(context).size.height * 0.06,
                              margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.getScaledSize(10.0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.height * 0.06,
                              height: MediaQuery.of(context).size.height * 0.06,
                              margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.getScaledSize(10.0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.getScaledSize(3.0),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.015,
                    margin: EdgeInsets.symmetric(
                      vertical: Dimensions.getScaledSize(5.0),
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.getScaledSize(16.0)),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.getScaledSize(10.0),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.015,
                      margin: EdgeInsets.only(
                        top: Dimensions.getScaledSize(5.0),
                        bottom: Dimensions.getScaledSize(5.0),
                        right: Dimensions.getScaledSize(10.0),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.getScaledSize(16.0)),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
      ),
    );
  }
}

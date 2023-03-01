import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/hotelDetailes/hotelDetailes.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesItemView extends StatelessWidget {
  final ActivityModel activity;
  final Function(ActivityModel activity) deletedCallback;
  final bool isFavourite;

  const FavoritesItemView(
      {required this.activity,
      required this.deletedCallback,
      required this.isFavourite});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HotelDetailes(
              isFavorite: isFavourite,
              //hotelData: activity,
              activityId: activity.sId!,
              onFavoriteChangedCallback: (activityId) {
                deletedCallback(activity);
              },
            ),
          ),
        );
      },
      child: Slidable(
        enabled: false,

        startActionPane: ActionPane(
          motion:  const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed:
                  (value) {
                    deletedCallback(activity);
              },
              icon: Icons.delete_forever_outlined,
              label: AppLocalizations.of(context)!.commonWords_clear,

            ),


          ],

        ),

        // actionPane: SlidableBehindActionPane(),
        // actionExtentRatio: 0.4,
        // secondaryActions: [
        //   SlideAction(
        //     onTap: () {
        //       deletedCallback(activity);
        //     },
        //     decoration: BoxDecoration(
        //       color: CustomTheme.accentColor1,
        //       borderRadius:
        //           BorderRadius.circular(Dimensions.getScaledSize(16.0)),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(
        //           Icons.delete_forever_outlined,
        //           size: Dimensions.getScaledSize(32.0),
        //           color: Colors.white,
        //         ),
        //         SizedBox(
        //           height: Dimensions.getScaledSize(20.0),
        //         ),
        //         Text(
        //           AppLocalizations.of(context)!.commonWords_clear,
        //           style: TextStyle(
        //             fontSize: Dimensions.getScaledSize(16.0),
        //             color: Colors.white,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
        child: Stack(
          children: [
            Container(
              height: Dimensions.getScaledSize(120.0),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(0, 10, 5, 0),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.getScaledSize(16.0)),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                      spreadRadius: 0.0),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(Dimensions.getScaledSize(16.0)),
                        bottomLeft:
                            Radius.circular(Dimensions.getScaledSize(16.0)),
                      ),
                      child: loadCachedNetworkImage(
                        activity.thumbnail!.publicUrl!,
                        fit: BoxFit.cover,
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
                          topRight:
                              Radius.circular(Dimensions.getScaledSize(16.0)),
                          bottomRight:
                              Radius.circular(Dimensions.getScaledSize(16.0)),
                        ),
                      ),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Dimensions.getScaledSize(5.0),
                          ),
                          Text(
                            activity.title!.trim(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.getScaledSize(16.0),
                              color: CustomTheme.primaryColorDark,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, Dimensions.getScaledSize(3.0), 0, 0),
                            child: Text(
                              activity.vendor!.name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(13.0),
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(10.0),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: Dimensions.getScaledSize(0.0),
                              ),
                              Icon(
                                FontAwesomeIcons.mapMarkerAlt,
                                size: Dimensions.getScaledSize(16.0),
                                color: CustomTheme.primaryColor,
                              ),
                              SizedBox(
                                width: Dimensions.getScaledSize(5.0),
                              ),
                              Expanded(
                                child: Text(
                                  '${activity.location!.zipcode} ${activity.location!.city} ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(13.0),
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: activity.reviewCount == 0
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SmoothStarRating(
                                              isReadOnly: true,
                                              allowHalfRating: true,
                                              starCount: 1,
                                              rating: 1,
                                              size: Dimensions.getScaledSize(
                                                  20.0),
                                              color: CustomTheme.accentColor3,
                                              borderColor:
                                                  CustomTheme.primaryColor,
                                            ),
                                            Text(
                                                " ${AppLocalizations.of(context)!.commonWords_new}",
                                                style: TextStyle(
                                                    fontSize: Dimensions
                                                        .getScaledSize(13.0),
                                                    color: Colors.grey
                                                        .withOpacity(0.8)))
                                          ],
                                        )
                                      : SmoothStarRating(
                                          isReadOnly: true,
                                          allowHalfRating: true,
                                          starCount: 5,
                                          rating: activity.reviewAverageRating !=
                                                      null &&
                                                  activity.reviewAverageRating !=
                                                      0
                                              ? activity.reviewAverageRating
                                              : 5,
                                          size: Dimensions.getScaledSize(20.0),
                                          color: CustomTheme.accentColor3,
                                          borderColor: CustomTheme.primaryColor,
                                        ),
                                ),
                                activity.reviewCount != null &&
                                        activity.reviewCount! > 0
                                    ? Text(
                                        " ${activity.reviewAverageRating.toString().replaceAll('.', ',')} (${activity.reviewCount})",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      )
                                    : Container(),
                                Expanded(child: Container()),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 4,
                                  ),
                                  child: Text(
                                    "ab",
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(13.0),
                                      color: Colors.grey.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Dimensions.getScaledSize(5),
                                ),
                                Text(
                                  "${formatPriceDouble(activity.priceFrom!)}€",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.getScaledSize(22.0),
                                    color: CustomTheme.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /*Row(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Text(
                                "ab",
                                style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(13.0),
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(
                                width: Dimensions.getScaledSize(5),
                              ),
                              Text(
                                "${formatPriceDouble(activity.priceFrom)}€",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.getScaledSize(20.0),
                                  color: CustomTheme.primaryColorDark,
                                ),
                              ),
                            ],
                          )*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  deletedCallback(activity);
                },
                child: Container(
                  height: Dimensions.getScaledSize(32.0),
                  width: Dimensions.getScaledSize(32.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(48.0)),
                    color: CustomTheme.accentColor1,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_border,
                      size: Dimensions.getScaledSize(24.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

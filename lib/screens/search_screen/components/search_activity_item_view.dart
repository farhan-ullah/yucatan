import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/hotelDetailes/hotelDetailes.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

// ignore: must_be_immutable
class SearchActivityItemView extends StatefulWidget {
  ActivityModel activity;
  bool isfav;
  Function(ActivityModel activity) onFavoriteChangedCallback;
  UserLoginModel userData;
  int index;

  SearchActivityItemView({
    required this.activity,
    required this.isfav,
    this.onFavoriteChangedCallback,
    this.userData,
    this.index,
  });

  @override
  SearchActivityItemViewState createState() => SearchActivityItemViewState();
}

class SearchActivityItemViewState extends State<SearchActivityItemView> {
  bool isFav = false;

  @override
  void initState() {
    isFav = widget.isfav;
    super.initState();
    eventBus.on<onFavDeleted>().listen((onFavDeleted event) {
      if (this.mounted) {
        if (isFav == false) {
          this.isFav = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HotelDetailes(
              isFavorite: isFav,
              //hotelData: widget.activity,
              activityId: widget.activity.sId,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: Dimensions.getScaledSize(10.0)),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.getScaledSize(7.0),
                  right: Dimensions.getScaledSize(6.0)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.getScaledSize(16.0)),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: Dimensions.getScaledSize(120.0),
                    width: Dimensions.getScaledSize(140.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(Dimensions.getScaledSize(16.0)),
                        bottomLeft:
                            Radius.circular(Dimensions.getScaledSize(16.0)),
                      ),
                      child: loadCachedNetworkImage(
                        widget.activity == null ||
                                widget.activity.thumbnail == null ||
                                widget.activity.thumbnail.publicUrl == null
                            ? ""
                            : widget.activity.thumbnail.publicUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: Dimensions.getScaledSize(120.0),
                      padding: EdgeInsets.only(
                        left: Dimensions.getScaledSize(10.0),
                        right: Dimensions.getScaledSize(10.0),
                        top: Dimensions.getScaledSize(10.0),
                        bottom: Dimensions.getScaledSize(5.0),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: Dimensions.getScaledSize(25.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Dimensions.getScaledSize(4.0)),
                                  child: Text(
                                    widget.activity.title.trim(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.getScaledSize(16.0),
                                      color: CustomTheme.primaryColorDark,
                                    ),
                                  ),
                                ),
                              ),
                              /*Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.getScaledSize(4.0)),
                                child: Text(
                                  widget.activity.vendor.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(13.0),
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: Dimensions.getScaledSize(16.0),
                                    color: CustomTheme.primaryColor,
                                  ),
                                  SizedBox(
                                    width: Dimensions.getScaledSize(4.0),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: Dimensions.getScaledSize(3),
                                      ),
                                      child: Text(
                                        '${widget.activity.location.zipcode} ${widget.activity.location.city} ',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(13.0),
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimensions.getScaledSize(4.0),
                              ),
                              Row(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      SmoothStarRating(
                                        allowHalfRating: true,
                                        starCount: 1,
                                        rating: 1,
                                        size: Dimensions.getScaledSize(20.0),
                                        color: CustomTheme.accentColor3,
                                        borderColor: CustomTheme.primaryColor,
                                      ),
                                      widget.activity.reviewCount != null &&
                                              widget.activity.reviewCount > 0
                                          ? Text(
                                              " ${widget.activity.reviewAverageRating.toString().replaceAll('.', ',')}",
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.getScaledSize(
                                                          13.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.8)),
                                            )
                                          : Text(
                                              " Neu",
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.getScaledSize(
                                                        13.0),
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: Dimensions.getScaledSize(3),
                                      ),
                                      child: Row(
                                        textBaseline: TextBaseline.alphabetic,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        children: [
                                          Text(
                                            "ab",
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      13.0),
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimensions.getScaledSize(5),
                                          ),
                                          Text(
                                            "${formatPriceDouble(widget.activity.priceFrom)}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      21.0),
                                              color:
                                                  CustomTheme.primaryColorDark,
                                            ),
                                          ),
                                          Text(
                                            "€",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      18.0),
                                              color:
                                                  CustomTheme.primaryColorDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _onFavoriteButtonPressed(widget.activity.sId);
              },
              child: Container(
                height: Dimensions.getScaledSize(32.0),
                width: Dimensions.getScaledSize(32.0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.getScaledSize(48.0)),
                  color: isFav ? CustomTheme.accentColor1 : Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.favorite_border,
                    size: Dimensions.getScaledSize(24.0),
                    color: isFav ? Colors.white : CustomTheme.accentColor1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onFavoriteButtonPressed(String activityId) async {
    Vibrate.feedback(FeedbackType.light);
    if (widget.userData == null) {
      _navigateToLogin();
      return;
    }
    setState(() {
      this.isFav = false;
    });

    /*UserService.deleteUserFavoriteActivity(
      activityId: activityId,
      userId: widget.userData.sId,
    );
    */
    /*if (isFav) {
      UserService.deleteUserFavoriteActivity(
        activityId: activityId,
        userId: widget.userData.sId,
      );
    } else {
      UserService.addUserFavoriteActivity(
        activityId: activityId,
        userId: widget.userData.sId,
      );
    }*/

    if (widget.onFavoriteChangedCallback != null)
      widget.onFavoriteChangedCallback(widget.activity);
  }

  void _navigateToLogin() async {
    var result = await Navigator.pushNamed(context, LoginScreen.route);
    if (result is bool) {
      if (result) {
        Navigator.of(context).popUntil(ModalRoute.withName(MainScreen.route));
        Navigator.of(context).pushReplacementNamed(
          MainScreen.route,
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 0,
          ),
        );
      }
    }
  }
}

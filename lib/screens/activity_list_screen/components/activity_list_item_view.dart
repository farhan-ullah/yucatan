import 'package:yucatan/models/activity_category_data_model.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/hotelDetailes/hotelDetailes.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/services/user_service.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/bool_utils.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

// ignore: must_be_immutable
class ActivityListViewItem extends StatefulWidget {
  ActivityCategoryDataModel? activityCategoryModel;
  final ActivityModel? activityModel;
  final bool? isFavorite;
  final bool? isComingFromFullMapScreen;
  final double? width;
  final Function(String activityId)? onFavoriteChangedCallback;

  ActivityListViewItem({
    this.activityCategoryModel,
    required this.isFavorite,
    required this.width,
    this.activityModel,
    this.onFavoriteChangedCallback,
    this.isComingFromFullMapScreen = false,
  });

  @override
  _ActivityListViewItemState createState() => _ActivityListViewItemState();
}

class _ActivityListViewItemState extends State<ActivityListViewItem> {
  bool? _isFavorite;
  UserLoginModel? _user;

  @override
  void initState() {
    checkIfActivityCategoryModelNotNull();
    _isFavorite = widget.isFavorite;
    _loadUser();
    super.initState();
  }

  void checkIfActivityCategoryModelNotNull() {
    if (widget.activityCategoryModel == null && widget.activityModel != null) {
      widget.activityCategoryModel = ActivityCategoryDataModel();
      widget.activityCategoryModel!.id = widget.activityModel!.sId;
      Location locationObject = Location();
      locationObject.lat = widget.activityModel!.location!.lat;
      locationObject.lon = widget.activityModel!.location!.lon;
      locationObject.state = widget.activityModel!.location!.state;
      locationObject.city = widget.activityModel!.location!.city;
      locationObject.country = widget.activityModel!.location!.country;
      locationObject.zipcode = widget.activityModel!.location!.zipcode;
      locationObject.housenumber = widget.activityModel!.location!.housenumber;
      locationObject.street = widget.activityModel!.location!.street;
      widget.activityCategoryModel!.location = locationObject;
      widget.activityCategoryModel!.reviewCount =
          widget.activityModel!.reviewCount;
      widget.activityCategoryModel!.reviewAverageRating =
          widget.activityModel!.reviewAverageRating;
      widget.activityCategoryModel!.priceFrom = widget.activityModel!.priceFrom;
      widget.activityCategoryModel!.title = widget.activityModel!.title;
      widget.activityCategoryModel!.thumbnail = widget.activityModel!.thumbnail;
    }
  }

  void _loadUser() async {
    _user = await UserProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getScaledSize(12.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Dimensions.getScaledSize(16.0),
                  ),
                ),
                color: CustomTheme.backgroundColor,
                boxShadow: CustomTheme.shadow,
              ),
              child: GestureDetector(
                onTap: () {
                  shuffelActivitysList = false;
                  print('How are you Farhan!!!!');
                  //Log firebase event
                  AnalyticsService.logViewContent(
                      widget.activityCategoryModel!, widget.activityModel!);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HotelDetailes(
                        //hotelData: widget.activity,
                        activityId:
                            widget.activityCategoryModel.toString().isEmpty
                                ? widget.activityModel != null
                                    ? widget.activityModel!.sId!
                                    : ""
                                : widget.activityCategoryModel!.id.toString(),
                        isFavorite: _isFavorite!,
                        onFavoriteChangedCallback: (activityId) {
                          if (widget.onFavoriteChangedCallback != null) {
                            widget.onFavoriteChangedCallback!(activityId);
                          }
                          setState(() {
                            _isFavorite = !_isFavorite!;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.getScaledSize(16.0))),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                height: Dimensions.getHeight(percentage: 20.0),
                                child: loadCachedNetworkImage(
                                  widget.activityCategoryModel == null
                                      ? widget.activityModel != null
                                          ? widget.activityModel!.thumbnail!
                                              .publicUrl!
                                          : ""
                                      : isNotNullOrEmpty(widget
                                              .activityCategoryModel!
                                              .thumbnail!
                                              .publicUrl!)
                                          ? widget.activityCategoryModel!
                                              .thumbnail!.publicUrl!
                                          : "",
                                  width: widget.width!,
                                  fit: BoxFit.cover,
                                  height:
                                      Dimensions.getHeight(percentage: 20.0),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height:
                                      Dimensions.getHeight(percentage: 11.0),
                                  width: widget.width,
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
                                bottom: widget.isComingFromFullMapScreen!
                                    ? 0
                                    : Dimensions.getScaledSize(10.0),
                                child: Container(
                                  width: widget.width,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widget
                                                .isComingFromFullMapScreen!
                                            ? 0
                                            : Dimensions.getScaledSize(12.0)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        widget.isComingFromFullMapScreen!
                                            ? Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimensions.getScaledSize(
                                                        10.0),
                                                    0,
                                                    0,
                                                    0),
                                                height:
                                                    Dimensions.getScaledSize(
                                                        40.0),
                                                width: widget.width! -
                                                    Dimensions.getScaledSize(
                                                        135.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    widget.activityCategoryModel ==
                                                            null
                                                        ? widget.activityModel !=
                                                                null
                                                            ? "${widget.activityModel!.title!.trim()}"
                                                            : ""
                                                        : "${widget.activityCategoryModel!.title!.trim()}",
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: Dimensions
                                                            .getScaledSize(
                                                                17.0),
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height:
                                                    Dimensions.getScaledSize(
                                                        40.0),
                                                width: widget.width,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    widget.activityCategoryModel ==
                                                            null
                                                        ? widget.activityModel !=
                                                                null
                                                            ? "${widget.activityModel!.title!.trim()}"
                                                            : ""
                                                        : "${widget.activityCategoryModel!.title!.trim()}",
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: Dimensions
                                                            .getScaledSize(
                                                                17.0),
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                            height:
                                                Dimensions.getScaledSize(3.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: widget.isComingFromFullMapScreen == true
                                ? false
                                : true,
                            child: Positioned(
                              top: Dimensions.getScaledSize(8.0),
                              right: Dimensions.getScaledSize(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  widget.activityCategoryModel == null
                                      ? _onFavoriteButtonPressed(
                                          widget.activityModel!.sId!)
                                      : _onFavoriteButtonPressed(
                                          widget.activityCategoryModel!.id!);
                                },
                                child: Container(
                                  height: Dimensions.getScaledSize(32.0),
                                  width: Dimensions.getScaledSize(32.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.getScaledSize(48.0)),
                                    color: _isFavorite!
                                        ? CustomTheme.accentColor1
                                        : Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: Dimensions.getScaledSize(24.0),
                                      color: _isFavorite!
                                          ? Colors.white
                                          : CustomTheme.accentColor1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              Dimensions.getScaledSize(16.0),
                            ),
                            bottomRight: Radius.circular(
                              Dimensions.getScaledSize(16.0),
                            ),
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
                                    Dimensions.getScaledSize(8.0),
                                  ),
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
                                                    widget.isComingFromFullMapScreen ==
                                                            true
                                                        ? false
                                                        : true,
                                                child: Row(
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: Dimensions
                                                          .getScaledSize(16.0),
                                                      color: CustomTheme
                                                          .primaryColorDark,
                                                    ),
                                                    SizedBox(
                                                      width: Dimensions
                                                          .getScaledSize(5.0),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: Dimensions
                                                              .getScaledSize(3),
                                                        ),
                                                        child: Text(
                                                          widget.activityCategoryModel ==
                                                                  null
                                                              ? widget.activityModel !=
                                                                      null
                                                                  ? '${widget.activityModel!.location!.zipcode} ${widget.activityModel!.location!.city} '
                                                                  : ""
                                                              : '${widget.activityCategoryModel!.location!.zipcode} ${widget.activityCategoryModel!.location!.city} ',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: Dimensions
                                                                .getScaledSize(
                                                                    13.0),
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top:
                                                      widget.isComingFromFullMapScreen ==
                                                              true
                                                          ? 0
                                                          : Dimensions
                                                              .getScaledSize(
                                                                  4.0),
                                                ),
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
                                                          .getScaledSize(18.0),
                                                      color: CustomTheme
                                                          .accentColor3,
                                                      borderColor: CustomTheme
                                                          .primaryColor,
                                                    ),
                                                    widget.activityCategoryModel ==
                                                            null
                                                        ? widget.activityModel !=
                                                                null
                                                            ? (widget.activityModel!
                                                                            .reviewCount! !=
                                                                        null &&
                                                                    widget.activityModel!
                                                                            .reviewCount! >
                                                                        0)
                                                                ? Row(
                                                                    children: [
                                                                      Text(
                                                                        " ${widget.activityModel!.reviewAverageRating.toString().replaceAll('.', ',')}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              Dimensions.getScaledSize(13.0),
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        " (${widget.activityModel!.reviewCount.toString()})",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              Dimensions.getScaledSize(13.0),
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    " ${AppLocalizations.of(context)!.activityScreen_new}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimensions.getScaledSize(
                                                                              13.0),
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  )
                                                            : Container()
                                                        : (widget.activityCategoryModel!
                                                                        .reviewCount !=
                                                                    null &&
                                                                widget.activityCategoryModel!
                                                                        .reviewCount! >
                                                                    0)
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    " ${widget.activityCategoryModel!.reviewAverageRating.toString().replaceAll('.', ',')}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimensions.getScaledSize(
                                                                              13.0),
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " (${widget.activityCategoryModel!.reviewCount.toString()})",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimensions.getScaledSize(
                                                                              13.0),
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                " ${AppLocalizations.of(context)!.activityScreen_new}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: Dimensions
                                                                      .getScaledSize(
                                                                          13.0),
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: -5,
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
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  widget.activityCategoryModel ==
                                                          null
                                                      ? widget.activityModel !=
                                                              null
                                                          ? formatPriceDouble(
                                                              widget
                                                                  .activityModel!
                                                                  .priceFrom!)
                                                          : ""
                                                      : formatPriceDouble(widget
                                                          .activityCategoryModel!
                                                          .priceFrom!),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .getScaledSize(21.0),
                                                      color: CustomTheme
                                                          .primaryColorDark),
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

  void _onFavoriteButtonPressed(String activityId) {
    Vibrate.feedback(FeedbackType.light);

    if (_user == null) {
      _navigateToLogin();
      return;
    }

    if (_isFavorite!) {
      UserService.deleteUserFavoriteActivity(
        activityId: activityId,
        userId: _user!.sId,
      );
    } else {
      UserService.addUserFavoriteActivity(
        activityId: activityId,
        userId: _user!.sId,
      );
    }

    if (widget.onFavoriteChangedCallback != null) {
      widget.onFavoriteChangedCallback!(activityId)!;
    }

    setState(() {
      _isFavorite = !_isFavorite!;
    });
  }
}

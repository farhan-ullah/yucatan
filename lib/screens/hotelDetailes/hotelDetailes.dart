import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/booking/booking_screen.dart';
import 'package:yucatan/screens/hotelDetailes/description_items.dart';
import 'package:yucatan/screens/hotelDetailes/detailed_description_screen_view.dart';
import 'package:yucatan/screens/hotelDetailes/google_maps_fullscreen.dart';
import 'package:yucatan/screens/hotelDetailes/recommended_activities.dart';
import 'package:yucatan/screens/hotelDetailes/reviewsListScreen.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/services/user_service.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/bool_utils.dart';
import 'package:yucatan/utils/common_widgets.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/share_utils.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:validators/validators.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../hotelDetailes/hotelRoomeList.dart';
import '../hotelDetailes/reviewsListScreen.dart';

// ignore: must_be_immutable
class HotelDetailes extends StatefulWidget {
  ActivityModel? hotelData;
  final String? activityId;
  final bool? isFavorite;
  final Function(String activityId)? onFavoriteChangedCallback;

  HotelDetailes({
    Key? key,
    //this.hotelData,
    required this.activityId,
    required this.isFavorite,
    this.onFavoriteChangedCallback,
  }) : super(key: key);

  @override
  _HotelDetailesState createState() => _HotelDetailesState();
}

class _HotelDetailesState extends State<HotelDetailes>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  bool isFav = false;
  AnimationController? animationController;
  var imageHeight = 0.0;
  AnimationController? _animationController;
  var bookingBarHeight = 0.0;

  ///Better Player
  BetterPlayerController? _betterPlayerController;

  AnimationController? _animationControllerVideo;

  static const int _animationDuration = 500;
  double _startOpacity = 0.7;
  double _endOpactiy = 0.0;

  UserLoginModel? _user;
  bool? _isFavorite;
  bool showPlayButton = true;
  File? thumbnailImage;
  bool isVideoUrlValid = false;
  StreamController<bool> _placeholderStreamController =
      StreamController.broadcast();
  StreamController<bool> _playButtonStreamController =
      StreamController.broadcast();
  bool _showPlaceholder = true;

  Future<ActivitySingleResponse>? singleActivityResponse;

  @override
  void initState() {
    singleActivityResponse = ActivityService.getActivity(widget.activityId!);
    shuffelActivitysList = false;
    _isFavorite = widget.isFavorite;
    _loadUser();
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    animationController!.forward();
    scrollController.addListener(() {
      if (context != null) {
        if (scrollController.offset < 0) {
          // we static set the just below half scrolling values
          _animationController!.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < imageHeight) {
          // we need around half scrolling values
          if (scrollController.offset < ((imageHeight / 1.25))) {
            _animationController!
                .animateTo((scrollController.offset / imageHeight));
          } else {
            // we static set the just above half scrolling values "around == 0.22"
            _animationController!.animateTo((imageHeight / 1.25) / imageHeight);
          }
        }
      }
    });

    _animationControllerVideo = AnimationController(
        duration: const Duration(milliseconds: _animationDuration),
        vsync: this,
        value: _startOpacity,
        lowerBound: _endOpactiy,
        upperBound: _startOpacity);

    super.initState();
  }

  void _setPlaceholderVisibleState(bool hidden) {
    _placeholderStreamController.add(hidden);
    _showPlaceholder = hidden;
  }

  ///_placeholderStreamController is used only to refresh video placeholder
  Widget _buildVideoPlaceholder(Widget imgFromUrl) {
    return StreamBuilder<bool>(
      stream: _placeholderStreamController.stream,
      builder: (context, snapshot) {
        return _showPlaceholder ? imgFromUrl : const SizedBox();
      },
    );
  }

  void _setCustomPlayButtonVisiblity(bool hidden) {
    _playButtonStreamController.add(hidden);
    showPlayButton = hidden;
  }

  Widget _buildPlayButton(Widget playButtonView) {
    return StreamBuilder<bool>(
      stream: _playButtonStreamController.stream,
      builder: (context, snapshot) {
        return showPlayButton ? playButtonView : const SizedBox();
      },
    );
  }

  @override
  void dispose() {
    _playButtonStreamController.close();
    _placeholderStreamController.close();
    animationController!.dispose();
    _animationControllerVideo!.dispose();
    if (_betterPlayerController != null) {
      _betterPlayerController!.dispose(forceDispose: true);
      _betterPlayerController = null;
    }
    super.dispose();
  }

  void _loadUser() async {
    _user = await UserProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    bookingBarHeight =
        Dimensions.getScaledSize(60.0) + MediaQuery.of(context).padding.bottom;
    imageHeight = MediaQuery.of(context).size.height - bookingBarHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<ActivitySingleResponse>(
        future: singleActivityResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CommonWidget.showSpinner();
            default:
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else {
                widget.hotelData = snapshot.data!.data;

                if (_betterPlayerController == null) {
                  initBetterPlayer();
                }

                if (widget.hotelData != null) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          padding: EdgeInsets.only(top: imageHeight),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.getScaledSize(32.0),
                                  left: Dimensions.getScaledSize(24.0),
                                  right: Dimensions.getScaledSize(24.0)),
                              child: getHotelDetails(isInList: true),
                            ),
                            GestureDetector(
                              onTap: _showDescriptionView,
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: Dimensions.getScaledSize(24.0),
                                      top: Dimensions.getScaledSize(20.0),
                                      right: Dimensions.getScaledSize(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: Dimensions.getScaledSize(5.0),
                                        bottom: Dimensions.getScaledSize(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height:
                                                Dimensions.getScaledSize(22.0),
                                            width:
                                                Dimensions.getScaledSize(22.0),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: Dimensions.getScaledSize(
                                                  22.0),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                Dimensions.getScaledSize(10.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                  "${widget.hotelData!.location!.zipcode} ${widget.hotelData!.location!.city}"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.getScaledSize(24.0),
                                        right: Dimensions.getScaledSize(24.0)),
                                    child: DescriptionItems(
                                      descriptionItems: widget.hotelData!
                                          .activityDetails!.descriptionItems!,
                                      shortDescription: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Dimensions.getScaledSize(15.0),
                                left: Dimensions.getScaledSize(16.0),
                                right: Dimensions.getScaledSize(16.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _showDescriptionView();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.getScaledSize(6),
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: CustomTheme.accentColor1
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: Dimensions.getScaledSize(5.0),
                                      left: Dimensions.getScaledSize(8.0),
                                      right: Dimensions.getScaledSize(8.0),
                                      bottom: Dimensions.getScaledSize(5.0),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height:
                                              Dimensions.getScaledSize(22.0),
                                          width: Dimensions.getScaledSize(22.0),
                                          child: Icon(
                                            Icons.coronavirus_outlined,
                                            size:
                                                Dimensions.getScaledSize(22.0),
                                            color: CustomTheme.accentColor1,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimensions.getScaledSize(10.0),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.getScaledSize(5),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .hotelDetailesScreen_covidMeasures,
                                              style: TextStyle(
                                                color: CustomTheme.accentColor1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            _buildVideoPlayer(),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: Dimensions.getScaledSize(24),
                                right: Dimensions.getScaledSize(24),
                              ),
                              child: Text(widget.hotelData!.activityDetails
                                      ?.shortDescription ??
                                  ''),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(15.0),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(CustomTheme.borderRadius),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _showDescriptionView();
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: Dimensions.getScaledSize(8.0),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .hotelDetailesScreen_description,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      14.0),
                                              color:
                                                  CustomTheme.primaryColorDark,
                                            ),
                                          ),
                                          Container(
                                            width:
                                                Dimensions.getScaledSize(22.0),
                                            height:
                                                Dimensions.getScaledSize(22.0),
                                            margin: EdgeInsets.fromLTRB(
                                                Dimensions.getScaledSize(10.0),
                                                0,
                                                Dimensions.getScaledSize(20.0),
                                                0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: CustomTheme
                                                      .primaryColorDark),
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: Dimensions.getScaledSize(
                                                  16.0),
                                              color:
                                                  CustomTheme.primaryColorDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            Container(
                              color: CustomTheme.grey,
                              child: HotelRoomeList(
                                activity: widget.hotelData!,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(20.0),
                            ),
                            widget.hotelData!.reviewCount != null &&
                                    widget.hotelData!.reviewCount! > 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: Dimensions.getScaledSize(24.0),
                                      right: Dimensions.getScaledSize(24.0),
                                      top: Dimensions.getScaledSize(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              Dimensions.getScaledSize(5.0),
                                              Dimensions.getScaledSize(10.0)),
                                          child: SmoothStarRating(
                                            allowHalfRating: true,
                                            starCount: 1,
                                            rating: 1.0,
                                            size:
                                                Dimensions.getScaledSize(40.0),
                                            color: CustomTheme.accentColor3,
                                            borderColor:
                                                CustomTheme.accentColor3,
                                            isReadOnly: true,
                                          ),
                                        ),
                                        Text(
                                          widget.hotelData!.reviewAverageRating!
                                              .toString()
                                              .replaceAll('.', ','),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Dimensions.getScaledSize(20.0),
                                            color: CustomTheme.primaryColorDark,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimensions.getScaledSize(10),
                                        ),
                                        Text(
                                          "${widget.hotelData!.reviewCount!}",
                                          // AppLocalizations.of(context)!
                                          //     .hotelDetailesScreen_reviewCountHandlePlural(
                                          //         widget.hotelData.reviewCount!),
                                          style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(14.0),
                                            color: CustomTheme.primaryColorDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),

                            widget.hotelData!.reviewCount != null &&
                                    widget.hotelData!.reviewCount! > 0
                                ? Container(
                                    height: Dimensions.getScaledSize(180.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(
                                        right: Dimensions.getScaledSize(19.0),
                                      ),
                                      itemCount: widget.hotelData!
                                                  .activityDetails!.reviews !=
                                              null
                                          ? widget.hotelData!.activityDetails!
                                                      .reviews!.length <=
                                                  5
                                              ? widget
                                                  .hotelData!
                                                  .activityDetails!
                                                  .reviews!
                                                  .length
                                              : 5
                                          : 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40),
                                          child: ReviewsView(
                                            isComingFromHotelDetails: true,
                                            review: widget
                                                .hotelData!
                                                .activityDetails!
                                                .reviews![index],
                                            animation: animationController!,
                                            animationController:
                                                animationController!,
                                            callback: () {
                                              openReviewsListScreen(
                                                  widget.hotelData!);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    height: Dimensions.getScaledSize(180),
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Dimensions.getScaledSize(24),
                                    ),
                                    padding: EdgeInsets.all(
                                      Dimensions.getScaledSize(12),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: CustomTheme.hintText,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.getScaledSize(10.0)),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  Dimensions.getScaledSize(10),
                                            ),
                                            child: RiveAnimation(
                                              riveFileName: 'rating.riv',
                                              riveAnimationName: 'Animation 1',
                                              placeholderImage:
                                                  'lib/assets/images/favorites_empty.png',
                                              startAnimationAfterMilliseconds:
                                                  0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimensions.getScaledSize(10),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .hotelDetailesScreen_noReviewsTitle,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      Dimensions.getScaledSize(
                                                          16.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    Dimensions.getScaledSize(
                                                        10),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .hotelDetailesScreen_noReviewsDescription,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize:
                                                      Dimensions.getScaledSize(
                                                          14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            widget.hotelData!.reviewCount != null &&
                                    widget.hotelData!.reviewCount! > 0
                                ? SizedBox(
                                    height: Dimensions.getScaledSize(20.0),
                                  )
                                : Container(),
                            widget.hotelData!.reviewCount != null &&
                                    widget.hotelData!.reviewCount! > 0
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  CustomTheme.borderRadius)),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewsListScreen(
                                                        activity:
                                                            widget.hotelData!,
                                                      ),
                                                  fullscreenDialog: true),
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .hotelDetailesScreen_showAllReviews,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: Dimensions
                                                        .getScaledSize(14.0),
                                                    color: CustomTheme
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      Dimensions.getScaledSize(
                                                          22.0),
                                                  height:
                                                      Dimensions.getScaledSize(
                                                          22.0),
                                                  margin: EdgeInsets.fromLTRB(
                                                      Dimensions.getScaledSize(
                                                          10.0),
                                                      0,
                                                      Dimensions.getScaledSize(
                                                          20.0),
                                                      0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: CustomTheme
                                                          .primaryColorDark,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: Dimensions
                                                        .getScaledSize(16.0),
                                                    color: CustomTheme
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: Dimensions.getScaledSize(20.0),
                            ),
                            Container(
                              height: Dimensions.getScaledSize(300.0),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: isNotNullOrEmpty(
                                      widget.hotelData!.location!.lat!)
                                  ? GoogleMap(
                                      mapType: MapType.normal,
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                      compassEnabled: false,
                                      mapToolbarEnabled: false,
                                      zoomGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                      tiltGesturesEnabled: false,
                                      rotateGesturesEnabled: false,
                                      onTap: (coordinates) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GoogleMapsFullscreen(
                                                    location: widget
                                                        .hotelData!.location,
                                                    destinationTitle: widget
                                                        .hotelData!.title),
                                          ),
                                        );
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          double.parse(
                                              widget.hotelData!.location!.lat!),
                                          double.parse(
                                              widget.hotelData!.location!.lon!),
                                        ),
                                        zoom: 14,
                                      ),
                                      markers: [
                                        Marker(
                                          markerId: MarkerId('0'),
                                          position: LatLng(
                                            double.parse(widget
                                                .hotelData!.location!.lat!),
                                            double.parse(widget
                                                .hotelData!.location!.lon!),
                                          ),
                                        ),
                                      ].toSet(),
                                    )
                                  : Center(
                                      child: Text(AppLocalizations.of(context)!
                                          .hotelDetailesScreen_locationNotAvailable),
                                    ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.only(
                            //     top: Dimensions.getScaledSize(25.0),
                            //     left: Dimensions.getScaledSize(24.0),
                            //     bottom: Dimensions.getScaledSize(25.0),
                            //     right: Dimensions.getScaledSize(24.0),
                            //   ),
                            //   color: CustomTheme.grey,
                            //   child: Column(
                            //     children: [
                            //       Text(
                            //         'Angeboten von',
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           color: CustomTheme.primaryColorDark,
                            //         ),
                            //       ),
                            //       Text(
                            //         widget.hotelData.vendor.name,
                            //         textAlign: TextAlign.center,
                            //       ),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Text(
                            //             widget.hotelData.vendor.location.street,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //           Text(' '),
                            //           Text(
                            //             widget.hotelData.vendor.location.housenumber,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ],
                            //       ),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Text(
                            //             widget.hotelData.vendor.location.zipcode.toString(),
                            //             textAlign: TextAlign.center,
                            //           ),
                            //           Text(' '),
                            //           Text(
                            //             widget.hotelData.vendor.location.city,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: Dimensions.getScaledSize(24),
                                right: Dimensions.getScaledSize(24),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .hotelDetailesScreen_otherRecommendations,
                                style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(18.0),
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.primaryColorDark,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(20.0),
                            ),
                            RecommendedActivities(
                                activityId: widget.hotelData!.sId!),
                            SizedBox(
                              height: bookingBarHeight +
                                  Dimensions.getScaledSize(20),
                            ),
                          ],
                        ),
                      ),
                      _backgraoundImageUI(widget.hotelData!),
                      _floatingBookingButton(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Container(
                          height: AppBar().preferredSize.height,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: AppBar().preferredSize.height,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.getScaledSize(8.0),
                                      left: Dimensions.getScaledSize(8.0)),
                                  child: Container(
                                    width: AppBar().preferredSize.height - 8,
                                    height: AppBar().preferredSize.height - 8,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.4),
                                        shape: BoxShape.circle),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              CustomTheme.iconRadius),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ShareUtils.createFirebaseDynamicLink(
                                      widget.hotelData!.sId!);
                                },
                                child: SizedBox(
                                  height: AppBar().preferredSize.height,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.getScaledSize(8.0),
                                        right: Dimensions.getScaledSize(8.0)),
                                    child: Container(
                                      height: AppBar().preferredSize.height - 8,
                                      width: AppBar().preferredSize.height - 8,
                                      decoration: BoxDecoration(
                                          //color: Theme.of(context).disabledColor.withOpacity(0.4),
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.4),
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            Dimensions.getScaledSize(8.0)),
                                        child: Icon(
                                          Icons.ios_share,
                                          // size: getProportionateScreenHeight(24),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _onFavoriteButtonPressed(
                                      widget.hotelData!.sId!);
                                },
                                child: SizedBox(
                                  height: AppBar().preferredSize.height,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.getScaledSize(8.0),
                                        right: Dimensions.getScaledSize(8.0)),
                                    child: Container(
                                      height: AppBar().preferredSize.height - 8,
                                      width: AppBar().preferredSize.height - 8,
                                      decoration: BoxDecoration(
                                          //color: Theme.of(context).disabledColor.withOpacity(0.4),
                                          color: _isFavorite!
                                              ? CustomTheme.accentColor1
                                              : Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.4),
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            Dimensions.getScaledSize(8.0)),
                                        child: Icon(
                                          Icons.favorite_border,
                                          // size: getProportionateScreenHeight(24),
                                          color: _isFavorite!
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }
          }
        },
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
        userId: _user!.sId!,
      );
    } else {
      UserService.addUserFavoriteActivity(
        activityId: activityId,
        userId: _user!.sId!,
      );
    }

    if (widget.onFavoriteChangedCallback != null)
      widget.onFavoriteChangedCallback!(activityId);

    setState(() {
      _isFavorite = !_isFavorite!;
    });
  }

  Widget _backgraoundImageUI(ActivityModel hotelData) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (BuildContext, Widget) {
          var opecity = 1.0 -
              (_animationController!.value >=
                      (((imageHeight / 1.2) - bookingBarHeight) / imageHeight)
                  ? 1.0
                  : _animationController!.value);
          return SizedBox(
            height: imageHeight * (1.0 - _animationController!.value),
            child: Stack(
              children: [
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: CustomTheme.grey,
                          blurRadius: Dimensions.getScaledSize(8.0),
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: Dimensions.getScaledSize(3),
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: loadCachedNetworkImage(
                              hotelData
                                  .activityDetails!.media!.cover!.publicUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 5,
                        //   height: (imageHeight *
                        //               (1.0 - _animationController.value) >
                        //           Dimensions.getScaledSize(200.0)
                        //       ? imageHeight * (1.0 - _animationController.value)
                        //       : Dimensions.getScaledSize(200.0)),
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Opacity(
                        //     opacity: opecity,
                        //     child: ImageFiltered(
                        //       imageFilter:
                        //           ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        //       child: ShaderMask(
                        //         shaderCallback: (rect) {
                        //           return LinearGradient(
                        //             begin: Alignment.topCenter,
                        //             end: Alignment.bottomCenter,
                        //             colors: [
                        //               Colors.black,
                        //               Colors.black.withOpacity(0.2),
                        //               Colors.black.withOpacity(0.0),
                        //             ],
                        //             stops: [
                        //               0.6,
                        //               0.7,
                        //               1.0,
                        //             ],
                        //           ).createShader(rect);
                        //         },
                        //         blendMode: BlendMode.dstOut,
                        //         child: loadCachedNetworkImage(
                        //             hotelData.activityDetails.media.cover,
                        //             fit: BoxFit.cover,
                        //             alignment: Alignment.bottomCenter),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: (imageHeight *
                                            (1.0 -
                                                _animationController!.value) >
                                        Dimensions.getScaledSize(200.0)
                                    ? imageHeight *
                                        (1.0 - _animationController!.value)
                                    : Dimensions.getScaledSize(200.0)) *
                                0.60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  CustomTheme.primaryColor.withOpacity(0.9),
                                ],
                                stops: [
                                  0.0,
                                  0.1,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: ColoredDivider(
                            height: Dimensions.getScaledSize(3.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: Dimensions.getScaledSize(20.0),
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opecity,
                    child: Column(
                      children: [
                        IgnorePointer(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: Dimensions.getScaledSize(24.0),
                                right: Dimensions.getScaledSize(24.0)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(CustomTheme.borderRadius)),
                              child: Container(
                                padding: EdgeInsets.all(
                                    Dimensions.getScaledSize(4.0)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Dimensions.getScaledSize(4.0),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Dimensions.getScaledSize(16.0),
                                          right: Dimensions.getScaledSize(16.0),
                                          top: Dimensions.getScaledSize(8.0),
                                          bottom:
                                              Dimensions.getScaledSize(8.0)),
                                      child: getHotelDetails(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getScaledSize(8.0),
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(CustomTheme.borderRadius)),
                            child: Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          CustomTheme.borderRadius)),
                                  onTap: () {
                                    try {
                                      scrollController.animateTo(
                                          MediaQuery.of(context).size.height -
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2.9,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.fastOutSlowIn);
                                    } catch (e) {}
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.getScaledSize(16.0),
                                        horizontal:
                                            Dimensions.getScaledSize(4.0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .hotelDetailesScreen_moreDetails,
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.getScaledSize(
                                                        16.0),
                                                color: Colors.white,
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: Dimensions.getScaledSize(
                                                  32.0),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getHotelDetails({bool isInList = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              isInList
                  ? Text(
                      widget.hotelData!.activityDetails!.title!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.getScaledSize(20),
                        color: isInList
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                    )
                  : Center(
                      child: Text(
                        widget.hotelData!.title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.getScaledSize(20),
                          color: isInList
                              ? CustomTheme.primaryColorDark
                              : Colors.white,
                          height: Dimensions.getScaledSize(1.4),
                        ),
                      ),
                    ),
              isInList
                  ? Container()
                  : Padding(
                      padding:
                          EdgeInsets.only(top: Dimensions.getScaledSize(10.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SmoothStarRating(
                            allowHalfRating: true,
                            starCount: 5,
                            rating: widget.hotelData!.reviewAverageRating == 0
                                ? 5
                                : widget.hotelData!.reviewAverageRating,
                            size: Dimensions.getScaledSize(20.0),
                            color: CustomTheme.accentColor3,
                            borderColor: CustomTheme.accentColor3,
                            isReadOnly: true,
                          ),
                          SizedBox(
                            width: Dimensions.getScaledSize(5),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.getScaledSize(3),
                            ),
                            child: Text(
                              widget.hotelData!.reviewCount == null ||
                                      widget.hotelData!.reviewCount == 0
                                  ? "(${AppLocalizations.of(context)!.commonWords_new})"
                                  : "(${widget.hotelData!.reviewCount})",
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(14.0),
                                color: isInList
                                    ? CustomTheme.dividerColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  _floatingBookingButton() {
    return Positioned(
      bottom: 0,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: bookingBarHeight,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            color: CustomTheme.primaryColorDark,
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(20),
                right: Dimensions.getScaledSize(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.commonWords_from} ",
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(15),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${formatPriceDouble(widget.hotelData!.priceFrom!)}",
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(21),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "€",
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _onTapBook();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Dimensions.getScaledSize(12.0),
                          bottom: Dimensions.getScaledSize(12.0),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              CustomTheme.borderRadius,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.getScaledSize(2.0),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .hotelDetailesScreen_bookNow,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(20),
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.primaryColorDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      child: VisibilityDetector(
        key: Key('${widget.hotelData!.sId}-video-player'),
        onVisibilityChanged: (visibilityInfo) {
          if (!isVideoUrlValid) {
            if (_betterPlayerController != null) {
              if (visibilityInfo.visibleFraction <= 0.3 &&
                  _betterPlayerController!.isPlaying()!) {
                _betterPlayerController!.pause();
              }
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: isValidPreviewVideo
                      ? isVideoUrlValid
                          ? BetterPlayer(
                              controller: _betterPlayerController!,
                            )
                          : CommonWidget.videoErrorView(
                              false, widget.hotelData!)
                      : CommonWidget.videoErrorView(true, widget.hotelData!)),
            ),
            isValidPreviewVideo
                ? _buildPlayButton(Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow_sharp,
                          size: 40,
                        ),
                        onPressed: () {
                          try {
                            if (isValidPreviewVideo) {
                              if (_betterPlayerController != null) {
                                _setCustomPlayButtonVisiblity(false);
                                _betterPlayerController!.play();
                              }
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }

  _onTapBook() {
    try {
      if (_betterPlayerController!.isPlaying() ?? false) {
        _betterPlayerController?.pause();
      }
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pushNamed(
      BookingScreen.route,
      arguments: widget.hotelData,
    );
  }

  _showDescriptionView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedDescriptionScreenView(
          activity: widget.hotelData!,
        ),
      ),
    );
  }

  void openReviewsListScreen(ActivityModel hotelData) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReviewsListScreen(
                activity: hotelData,
              ),
          fullscreenDialog: true),
    );
  }

  bool isValidPreviewVideo = true;
  void initBetterPlayer() {
    if (widget.hotelData == null) {
      //print("invalid activity data");
      return;
    }

    if (widget.hotelData!.activityDetails!.media!.previewVideo == null) {
      isValidPreviewVideo = false;
      return;
    }
    if (isURL(
        widget.hotelData!.activityDetails!.media!.previewVideo?.publicUrl)) {
      isVideoUrlValid = true;

      BetterPlayerControlsConfiguration controlsConfiguration =
          BetterPlayerControlsConfiguration(
        showControls: true,
        enableFullscreen: true,
        showControlsOnInitialize: false,
        enableSkips: false,
        controlsHideTime: Duration(milliseconds: 500),
        enableOverflowMenu: false,
        controlBarHeight: 32,
      );

      BetterPlayerConfiguration betterPlayerConfiguration =
          BetterPlayerConfiguration(
        controlsConfiguration: controlsConfiguration,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        showPlaceholderUntilPlay: true,
        placeholderOnTop: true,
        autoPlay: false,
        looping: true,
        autoDispose: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              "Video URL is invalid >> $errorMessage",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
        eventListener: (BetterPlayerEvent event) {
          if (event.betterPlayerEventType == BetterPlayerEventType.play) {
            _setPlaceholderVisibleState(false);
          }
        },
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        placeholder:
            widget.hotelData!.activityDetails!.media!.previewVideoThumbnail !=
                    null
                ? _buildVideoPlaceholder(
                    loadCachedNetworkImage(
                      widget.hotelData!.activityDetails!.media!
                          .previewVideoThumbnail!.publicUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
      );

      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
      );
      _betterPlayerController!.setupDataSource(BetterPlayerDataSource.network(
        widget.hotelData!.activityDetails!.media!.previewVideo!.publicUrl!,
        cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true),
      ));
      _betterPlayerController!.setVolume(1.0);
    } else {
      isVideoUrlValid = false;
      showPlayButton = false;
    }
  }
}

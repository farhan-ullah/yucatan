import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingAddReviewView extends StatefulWidget {
  final ActivityModel activity;

  BookingAddReviewView({required this.activity});

  @override
  _BookingAddReviewViewState createState() => _BookingAddReviewViewState();
}

class _BookingAddReviewViewState extends State<BookingAddReviewView> {
  Future<UserLoginModel> user;
  Future<ActivitySingleResponse> addReviewFuture;
  UserLoginModel userModel;
  ActivityModelActivityDetailsReview existingReview;
  int step = 1;
  double rating = 5;
  String reviewText = "";

  @override
  void initState() {
    super.initState();
    user = UserProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserLoginModel>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userModel = snapshot.data;
          _loadReview();
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.getScaledSize(24.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      Dimensions.getScaledSize(24.0)),
                                  topRight: Radius.circular(
                                      Dimensions.getScaledSize(24.0)),
                                ),
                                child: loadCachedNetworkImage(
                                  widget.activity.thumbnail?.publicUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(20.0),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20.0),
                                  right: Dimensions.getScaledSize(20.0),
                                ),
                                child: Text(
                                  widget.activity.title,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(18.0),
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.primaryColorDark,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.getScaledSize(30.0)),
                            Visibility(
                              visible: step == 1,
                              child: Expanded(
                                child: Container(
                                  child: Column(
                                    children: [..._getStepOneUi()],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: step == 2,
                              child: Expanded(
                                child: Container(
                                  child: Column(
                                    children: [..._getStepTwoUi()],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: step == 3,
                              child: Expanded(
                                child: Container(
                                  child: _getStepThreeUi(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _getStepOneUi() {
    return [
      Padding(
        padding: EdgeInsets.only(
          left: Dimensions.getScaledSize(20.0),
          right: Dimensions.getScaledSize(20.0),
        ),
        child: Text(
          AppLocalizations.of(context)!.bookingListScreen_addReview_question,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(14.0),
            fontWeight: FontWeight.w500,
            color: CustomTheme.primaryColorDark,
          ),
        ),
      ),
      SizedBox(
        height: Dimensions.getScaledSize(20.0),
      ),
      SmoothStarRating(
        color: CustomTheme.primaryColor,
        allowHalfRating: false,
        rating: rating,
        starCount: 5,
        size: Dimensions.getScaledSize(42.0),
        onRated: (double newRating) {
          setState(() {
            rating = newRating;
          });
        },
      ),
      SizedBox(
        height: Dimensions.getScaledSize(20.0),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(20.0),
            right: Dimensions.getScaledSize(20.0),
          ),
          child: Text(
            _getRatingText(),
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(14.0),
              fontWeight: FontWeight.w500,
              color: CustomTheme.disabledColor,
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(),
      ),
      _getButtons(),
      SizedBox(
        height: Dimensions.getScaledSize(10.0),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(20.0),
            right: Dimensions.getScaledSize(20.0),
          ),
          child: Text(
            '1/2',
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(14.0),
              fontWeight: FontWeight.w500,
              color: CustomTheme.disabledColor,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _getStepTwoUi() {
    return [
      Padding(
        padding: EdgeInsets.only(
          left: Dimensions.getScaledSize(20.0),
          right: Dimensions.getScaledSize(20.0),
        ),
        child: Text(
          AppLocalizations.of(context)!.bookingListScreen_addReview_tellUs,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(14),
            fontWeight: FontWeight.w500,
            color: CustomTheme.primaryColorDark,
          ),
        ),
      ),
      SizedBox(
        height: Dimensions.getScaledSize(20.0),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(18.0),
            right: Dimensions.getScaledSize(18.0),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomTheme.disabledColor,
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: Dimensions.getScaledSize(10.0),
                left: Dimensions.getScaledSize(10.0),
                bottom: Dimensions.getScaledSize(10.0),
                right: Dimensions.getScaledSize(10.0),
              ),
            ),
            maxLines: 3,
            maxLength: 500,
            initialValue: reviewText,
            onChanged: (value) {
              setState(() {
                reviewText = value;
              });
            },
          ),
        ),
      ),
      SizedBox(
        height: Dimensions.getScaledSize(15.0),
      ),
      _getButtons(),
      SizedBox(
        height: Dimensions.getScaledSize(10.0),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(20.0),
            right: Dimensions.getScaledSize(20.0),
          ),
          child: Text(
            '2/2',
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(14.0),
              fontWeight: FontWeight.w500,
              color: CustomTheme.disabledColor,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _getStepThreeUi() {
    return FutureBuilder<ActivitySingleResponse>(
      future: addReviewFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.errors != null) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: Dimensions.getScaledSize(20.0),
                    right: Dimensions.getScaledSize(20.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context)
                        .bookingListScreen_addReview_error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(14.0),
                      fontWeight: FontWeight.w500,
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                _getButtons(),
                SizedBox(
                  height: Dimensions.getScaledSize(27.0),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: Dimensions.getScaledSize(20.0),
                    right: Dimensions.getScaledSize(20.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context)
                        .bookingListScreen_addReview_thankYou,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(14.0),
                      fontWeight: FontWeight.w500,
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Dimensions.getScaledSize(20.0),
                    right: Dimensions.getScaledSize(20.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context)
                        .bookingListScreen_addReview_yourReviewHelpsUs,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(14.0),
                      fontWeight: FontWeight.w500,
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                _getButtons(activitySingleResponse: snapshot.data),
                SizedBox(
                  height: Dimensions.getScaledSize(27.0),
                ),
              ],
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _getButtons({ActivitySingleResponse activitySingleResponse}) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.getScaledSize(18.0),
        right: Dimensions.getScaledSize(18.0),
      ),
      child: step == 3
          ? MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(activitySingleResponse);
              },
              color: CustomTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.getScaledSize(24.0)),
              ),
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(15.0),
                right: Dimensions.getScaledSize(15.0),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)
                      .bookingListScreen_addReview_backToOveview,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(16.0),
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      if (step > 1) {
                        step -= 1;
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  color: CustomTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.only(
                    left: Dimensions.getScaledSize(15.0),
                    right: Dimensions.getScaledSize(15.0),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.actions_back,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      if (step < 3) {
                        step += 1;
                        if (step == 3) {
                          _addReview();
                        }
                      }
                    });
                  },
                  color: CustomTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(24.0)),
                  ),
                  padding: EdgeInsets.only(
                    left: Dimensions.getScaledSize(15.0),
                    right: Dimensions.getScaledSize(15.0),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.commonWords_further,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(16.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _getRatingText() {
    if (rating == 1.0) {
      return AppLocalizations.of(context)
          .bookingListScreen_addReview_options_veryBad;
    } else if (rating == 2.0) {
      return AppLocalizations.of(context)
          .bookingListScreen_addReview_options_bad;
    } else if (rating == 3.0) {
      return AppLocalizations.of(context)
          .bookingListScreen_addReview_options_ok;
    } else if (rating == 4.0) {
      return AppLocalizations.of(context)
          .bookingListScreen_addReview_options_good;
    } else if (rating == 5.0) {
      return AppLocalizations.of(context)
          .bookingListScreen_addReview_options_veryGood;
    }

    return "";
  }

  void _loadReview() {
    // Throws error in case reviews are null
    var review = widget.activity.activityDetails.reviews
        ?.firstWhere((element) => element.user == userModel.sId, orElse: () {
      return null;
    });

    if (review != null && existingReview == null) {
      existingReview = review;
      rating = review.rating.toDouble();
      reviewText = review.description;
    }
  }

  void _addReview() {
    ActivityModelActivityDetailsReview review =
        ActivityModelActivityDetailsReview();
    review.user = userModel.sId;
    review.rating = rating.toInt();
    review.description = reviewText;

    if (existingReview != null) {
      review.sId = existingReview.sId;
      addReviewFuture = ActivityService.editReview(widget.activity.sId, review);
    } else {
      addReviewFuture = ActivityService.addReview(widget.activity.sId, review);
    }
  }
}

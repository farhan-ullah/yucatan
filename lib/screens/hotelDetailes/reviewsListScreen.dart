import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewsListScreen extends StatefulWidget {
  final ActivityModel activity;

  ReviewsListScreen({required this.activity});

  @override
  _ReviewsListScreenState createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ActivityModelActivityDetailsReview> reviews =
        widget.activity.activityDetails.reviews;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(child: appBar()),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: Dimensions.getScaledSize(8.0),
                bottom: MediaQuery.of(context).padding.bottom +
                    Dimensions.getScaledSize(8.0),
              ),
              itemCount: reviews != null ? reviews.length : 0,
              itemBuilder: (context, index) {
                var count = reviews.length > 10 ? 10 : reviews.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                return ReviewsView(
                  callback: () {},
                  review: reviews[index],
                  animation: animation,
                  animationController: animationController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: AppBar().preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(
                top: Dimensions.getScaledSize(8.0),
                left: Dimensions.getScaledSize(8.0)),
            child: Container(
              //width: AppBar().preferredSize.height - 8,
              //height: AppBar().preferredSize.height - 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.getScaledSize(32.0)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.getScaledSize(8.0)),
                        child: Icon(Icons.close),
                      ),
                      SizedBox(width: Dimensions.getScaledSize(10.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: Dimensions.getScaledSize(4.0),
              left: Dimensions.getScaledSize(24.0)),
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
                  size: Dimensions.getScaledSize(40.0),
                  color: CustomTheme.accentColor3,
                  borderColor: CustomTheme.accentColor3,
                  isReadOnly: true,
                ),
              ),
              Text(
                widget.activity.reviewAverageRating
                    .toString()
                    .replaceAll('.', ','),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.getScaledSize(20.0),
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              SizedBox(
                width: Dimensions.getScaledSize(10),
              ),
              Text(
                AppLocalizations.of(context)
                    .hotelDetailesScreen_reviewCountHandlePlural(
                        widget.activity.reviewCount),
                style: new TextStyle(
                  fontSize: Dimensions.getScaledSize(14.0),
                  color: CustomTheme.primaryColorDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewsView extends StatelessWidget {
  final VoidCallback callback;
  final ActivityModelActivityDetailsReview review;
  final AnimationController animationController;
  final Animation animation;
  final bool isComingFromHotelDetails;

  const ReviewsView({
    Key? key,
    this.review,
    this.animationController,
    this.animation,
    this.callback,
    this.isComingFromHotelDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.getScaledSize(24.0),
                  right: isComingFromHotelDetails
                      ? Dimensions.getScaledSize(5.0)
                      : Dimensions.getScaledSize(24.0),
                  top: Dimensions.getScaledSize(16.0)),
              child: InkWell(
                onTap: () {
                  callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomTheme.hintText,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.getScaledSize(10.0)),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      Dimensions.getScaledSize(10.0),
                      Dimensions.getScaledSize(10.0),
                      isComingFromHotelDetails
                          ? Dimensions.getScaledSize(30.0)
                          : Dimensions.getScaledSize(10.0),
                      Dimensions.getScaledSize(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.all(Dimensions.getScaledSize(8.0)),
                            child: CircleAvatar(
                              backgroundColor: CustomTheme.hintText,
                              child: Text(
                                review.userModel?.username != null
                                    ? review.userModel?.username[0]
                                    : 'A',
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Dimensions.getScaledSize(10.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                review.userModel?.username ??
                                    AppLocalizations.of(context)!
                                        .reviewsListScren_anonymousGermany,
                                style:
                                    new TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                review.updatedAt == null
                                    ? ""
                                    : DateFormat('dd.MM.yyyy').format(
                                        DateTime.parse(review.updatedAt),
                                      ),
                                style: new TextStyle(
                                  color: CustomTheme.dividerColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.getScaledSize(8.0)),
                        child: Text(
                          review.description.trim(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: new TextStyle(
                            color: CustomTheme.dividerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yucatan/screens/activity_list_screen/components/activity_list_slider_view.dart';

import '../../theme/custom_theme.dart';
import '../../utils/datefulWidget/DateStatefulWidget.dart';
import '../../utils/datefulWidget/GlobalDate.dart';
import '../../utils/network_utils.dart';
import '../../utils/widget_dimensions.dart';
import '../notifications/notification_view.dart';
import 'components/activity_list_category_view.dart';

// ignore: must_be_immutable
class ActivityListScreen extends DateStatefulWidget {
  static const route = '/activities';

  final AnimationController? animationController;
  final showSearch;
  String? activityId;

  ActivityListScreen(
      {Key? key,
      this.animationController,
      this.showSearch = false,
      this.activityId})
      : super(key: key);

  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends DateState<ActivityListScreen>
    with TickerProviderStateMixin {
  ScrollController? controller;
  AnimationController? _animationController;
  var sliderImageHeight = 0.0;

  // SelectedDate _selectedDate;

  // Future<UserLoginModel> user;
  Future<List<String>>? favoriteActivities;

  bool isNetworkAvailable = false;
  bool _searchViewVisible = false;
  bool isActivityApiCalling = false;

  @override
  void initState() {
    // try {
    //   //print("----------ActivityListScreen-------activityId=${widget.activityId}");
    //   if(widget.activityId != null && !isActivityApiCalling){
    //     isActivityApiCalling = false;
    //     ActivityService.getActivity(widget.activityId).then((value){
    //       isActivityApiCalling = true;
    //       if(value != null){
    //         ActivitySingleResponse activitySingleResponse = value;
    //         //print("-----activitySingleResponse---=${activitySingleResponse.data.sId}");
    //         if(activitySingleResponse != null && activitySingleResponse.data != null){
    //           widget.activityId = null;
    //           isActivityApiCalling = false;
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => HotelDetailes(
    //                 //hotelData: activitySingleResponse.data,
    //                 activityId: activitySingleResponse.data.sId,
    //                 isFavorite: false,
    //                 onFavoriteChangedCallback: (activityId) {

    //                 },
    //               ),
    //             ),
    //           );
    //         }

    //       }
    //     });
    //   }
    // } catch (e) {
    //   print(e);
    // }

    Future.delayed(Duration(seconds: 1), () {
      if (mounted && widget.showSearch)
        setState(() {
          _searchViewVisible = widget.showSearch;
        });
    });

    NetworkUtils.isNetworkAvailable().then((value) {
      if (mounted) {
        this.setState(() {
          this.isNetworkAvailable = value;
        });
      }
    });
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    widget.animationController!.forward();
    controller = ScrollController(initialScrollOffset: 0.0);

    controller!.addListener(() {
      if (context != null) {
        if (controller!.offset < 0) {
          // we static set the just below half scrolling values
          _animationController!.animateTo(0.0);
        } else if (controller!.offset > 0.0 &&
            controller!.offset < sliderImageHeight) {
          // we need around half scrolling values
          if (controller!.offset < ((sliderImageHeight / 1.5))) {
            _animationController!
                .animateTo((controller!.offset / sliderImageHeight));
          } else {
            // we static set the just above half scrolling values "around == 0.64"
            _animationController!
                .animateTo((sliderImageHeight / 1.5) / sliderImageHeight);
          }
        }
      }
    });
    // user = UserProvider.getUser();
    onDateChanged(GlobalDate.current());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sliderImageHeight = MediaQuery.of(context).size.height * 0.39;
    return WillPopScope(
        child: AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext? context, Widget? child) {
            return FadeTransition(
              opacity: widget.animationController!,
              // FadeTransition and Transform : just for screen loading animation on fistTime
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 40 * (1.0 - widget.animationController!.value), 0.0),
                child: Scaffold(
                  backgroundColor: CustomTheme.backgroundColor,
                  body: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context!).size.height -
                          Dimensions.getScaledSize(
                              63) /*+
                      MediaQuery.of(context).padding.bottom*/
                      ,
                      child: Stack(
                        children: <Widget>[
                          // isNetworkAvailable
                          //     ? FutureBuilder<UserLoginModel>(
                          //         future: user,
                          //         builder: (context, snapshotUserLoginModel) {
                          //           if (snapshotUserLoginModel.data == null) {
                          //             return _getActivityCategoryViews([]);
                          //           } else if (snapshotUserLoginModel.hasData) {
                          //             print(
                          //                 'Data Showed 0 Farhan: ${snapshotUserLoginModel.data.sId}');
                          //             favoriteActivities = UserService
                          //                 .getFavoriteActivitiesForUser(
                          //                     snapshotUserLoginModel.data.sId);

                          //             return FutureBuilder<List<String>>(
                          //                 future: favoriteActivities,
                          //                 builder:
                          //                     (context, snapshotFavorites) {
                          //                   if (snapshotFavorites.hasData ||
                          //                       snapshotFavorites.data ==
                          //                           null) {
                          //                     print(
                          //                         'Data Showed 1 Farhan : ${snapshotFavorites.data}');
                          //                     return _getActivityCategoryViews(
                          //                         snapshotFavorites.data);
                          //                   } else if (snapshotFavorites
                          //                       .hasError) {
                          //                     return Padding(
                          //                       padding: EdgeInsets.only(
                          //                         top: Dimensions.getScaledSize(
                          //                             10.0),
                          //                         left:
                          //                             Dimensions.getScaledSize(
                          //                                 20.0),
                          //                         bottom:
                          //                             Dimensions.getScaledSize(
                          //                                 20.0),
                          //                         right:
                          //                             Dimensions.getScaledSize(
                          //                                 20.0),
                          //                       ),
                          //                       child: Text(
                          //                           '${snapshotFavorites.error}'),
                          //                     );
                          //                   }
                          //                   return Center(
                          //                       child:
                          //                           CircularProgressIndicator());
                          //                 });
                          //           } else if (snapshotUserLoginModel
                          //               .hasError) {
                          //             return Padding(
                          //               padding: EdgeInsets.only(
                          //                 top: Dimensions.getScaledSize(10.0),
                          //                 left: Dimensions.getScaledSize(20.0),
                          //                 bottom:
                          //                     Dimensions.getScaledSize(20.0),
                          //                 right: Dimensions.getScaledSize(20.0),
                          //               ),
                          //               child: Text(
                          //                   '${snapshotUserLoginModel.error}'),
                          //             );
                          //           }
                          //           return Center(
                          //             child: CircularProgressIndicator(),
                          //           );
                          //         },
                          //       )
                          //     :
                          Container(
                            child: Text('No Network'),
                            // NoNetworkScreen(
                            //   callback: () async {
                            //     bool isNetworkAvailable =
                            //         await NetworkUtils
                            //             .isNetworkAvailable();
                            //     if (isNetworkAvailable) {
                            //       this.setState(() {
                            //         this.isNetworkAvailable =
                            //             isNetworkAvailable;
                            //       });
                            //     }
                            //   },
                            // ),
                            padding: EdgeInsets.only(top: sliderImageHeight),
                          ),
                          // sliderUI with 3 images are moving
                          _sliderUi(),

                          //just gradient for see the time and battry Icon on "TopBar"
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: Dimensions.getScaledSize(80.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  CustomTheme.backgroundColor.withOpacity(0.4),
                                  CustomTheme.backgroundColor.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )),
                            ),
                          ),
                          // serachUI on Top  Positioned
                          Positioned(
                            top: MediaQuery.of(context).padding.top,
                            left: 0,
                            right: 0,
                            child: searchUi(),
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   child: GestureDetector(
                          //       // onVerticalDragEnd: (DragEndDetails details) {
                          //       //   if (details.primaryVelocity > 3) {
                          //       //     setState(() {
                          //       //       _searchViewVisible = false;
                          //       //     });
                          //       //   }
                          //       // },
                          //       child: FutureBuilder<UserLoginModel>(
                          //         future: user,
                          //         builder: (context, snapshot) {
                          //           if (snapshot.hasData) {
                          //             favoriteActivities = UserService
                          //                 .getFavoriteActivitiesForUser(
                          //                     snapshot.data.sId);

                          //             return FutureBuilder<List<String>>(
                          //                 future: favoriteActivities,
                          //                 builder:
                          //                     (context, snapshotFavorites) {
                          //                   List<String> fav = [];

                          //                   if (snapshotFavorites.hasData) {
                          //                     fav = snapshotFavorites.data;
                          //                   }
                          //                   eventBus.fire(OnSearchPopUpOpen(
                          //                       _searchViewVisible));
                          //                   return SearchPopupView(
                          //                     userData: snapshot.data,
                          //                     height: MediaQuery.of(context)
                          //                             .size
                          //                             .height -
                          //                         MediaQuery.of(context)
                          //                             .padding
                          //                             .top -
                          //                         MediaQuery.of(context)
                          //                                 .size
                          //                                 .height *
                          //                             0.18,
                          //                     visible: _searchViewVisible,
                          //                     onBackTap: () {
                          //                       setState(() {
                          //                         _searchViewVisible =
                          //                             !_searchViewVisible;
                          //                       });
                          //                     },
                          //                     favoriteList: fav,
                          //                   );
                          //                 });
                          //           }
                          //           eventBus.fire(
                          //               OnSearchPopUpOpen(_searchViewVisible));
                          //           return SearchPopupView(
                          //             userData: snapshot.data,
                          //             height: MediaQuery.of(context)
                          //                     .size
                          //                     .height -
                          //                 MediaQuery.of(context).padding.top -
                          //                 MediaQuery.of(context).size.height *
                          //                     0.18,
                          //             visible: _searchViewVisible,
                          //             onBackTap: () {
                          //               setState(() {
                          //                 _searchViewVisible =
                          //                     !_searchViewVisible;
                          //               });
                          //             },
                          //             favoriteList: [],
                          //           );
                          //         },
                          //       )),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        onWillPop: () async {
          if (_searchViewVisible) {
            setState(() {
              _searchViewVisible = !_searchViewVisible;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        });
  }

  Widget _sliderUi() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animationController!,
              builder: (BuildContext? context, Widget? child) {
                // we calculate the opacity between 0.64 to 1.0
                var opacity = 1.0 -
                    (_animationController!.value > 0.64
                        ? 1.0
                        : _animationController!.value);
                return SizedBox(
                  height: sliderImageHeight *
                              (1.0 - _animationController!.value) >=
                          MediaQuery.of(context!).size.height * 0.14
                      ? sliderImageHeight * (1.0 - _animationController!.value)
                      : MediaQuery.of(context).size.height * 0.14,
                  child: ActivityListSliderView(
                    opValue: opacity,
                    onSearchTap: () {
                      setState(() {
                        _searchViewVisible = !_searchViewVisible;
                      });
                    },
                    animationController: _animationController,
                  ),
                );
              },
            ),
            // SizedBox(
            //   height: Dimensions.getScaledSize(10.0),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: Dimensions.getScaledSize(24.0)),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: GestureDetector(
            //           onTap: () {
            //             _selectedDateChanges(SelectedDate.TODAY);
            //           },
            //           child: Container(
            //             height: Dimensions.getScaledSize(40.0),
            //             padding: EdgeInsets.all(Dimensions.getScaledSize(6.0)),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: CustomTheme.mediumGrey,
            //               ),
            //               borderRadius: BorderRadius.circular(
            //                   Dimensions.getScaledSize(8.0)),
            //               color: _selectedDate == SelectedDate.TODAY
            //                   ? CustomTheme.primaryColorDark
            //                   : Colors.white,
            //             ),
            //             child: Center(
            //               child: Text(
            //                 AppLocalizations.of(context).today,
            //                 style: TextStyle(
            //                   fontSize: Dimensions.getScaledSize(15.0),
            //                   fontWeight: FontWeight.bold,
            //                   color: _selectedDate == SelectedDate.TODAY
            //                       ? Colors.white
            //                       : CustomTheme.primaryColorDark,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         width: Dimensions.getScaledSize(10.0),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: GestureDetector(
            //           onTap: () {
            //             _selectedDateChanges(SelectedDate.TOMORROW);
            //           },
            //           child: Container(
            //             height: Dimensions.getScaledSize(40.0),
            //             padding: EdgeInsets.all(Dimensions.getScaledSize(6.0)),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: CustomTheme.mediumGrey,
            //               ),
            //               borderRadius: BorderRadius.circular(
            //                   Dimensions.getScaledSize(8.0)),
            //               color: _selectedDate == SelectedDate.TOMORROW
            //                   ? CustomTheme.primaryColorDark
            //                   : Colors.white,
            //             ),
            //             child: Center(
            //               child: Text(
            //                 AppLocalizations.of(context).tomorrow,
            //                 style: TextStyle(
            //                   fontSize: Dimensions.getScaledSize(15.0),
            //                   fontWeight: FontWeight.bold,
            //                   color: _selectedDate == SelectedDate.TOMORROW
            //                       ? Colors.white
            //                       : CustomTheme.primaryColorDark,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         width: Dimensions.getScaledSize(10.0),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: GestureDetector(
            //           onTap: () {
            //             _selectCustomDate();
            //           },
            //           child: Container(
            //             height: Dimensions.getScaledSize(40.0),
            //             padding: EdgeInsets.all(Dimensions.getScaledSize(6.0)),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: CustomTheme.mediumGrey,
            //               ),
            //               borderRadius: BorderRadius.circular(
            //                   Dimensions.getScaledSize(8.0)),
            //               color: _selectedDate == SelectedDate.CUSTOM
            //                   ? CustomTheme.primaryColorDark
            //                   : Colors.white,
            //             ),
            //             child: SvgPicture.asset(
            //               'lib/assets/images/calendar.svg',
            //               color: _selectedDate == SelectedDate.CUSTOM
            //                   ? Colors.white
            //                   : CustomTheme.primaryColorDark,
            //               height: Dimensions.getScaledSize(24.0),
            //               width: Dimensions.getScaledSize(24.0),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: Dimensions.getScaledSize(10.0),
            // ),
          ],
        ),
      ),
    );
  }

  Widget searchUi() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.getScaledSize(24.0),
        top: Dimensions.getScaledSize(16.0),
        right: Dimensions.getScaledSize(16.0),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: CustomTheme.grey,
                  offset: Offset(4, 4),
                  blurRadius: Dimensions.getScaledSize(16.0),
                ),
              ],
            ),
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                SvgPicture.asset(
                  'lib/assets/images/appventure_logo_pos.svg',
                  height: Dimensions.getScaledSize(24.0),
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Dimensions.getScaledSize(5.0),
                  ),
                  child: Text(
                    'ppventure',
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(22.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return _animationController!.value > 0.38
                  ? Opacity(
                      opacity:
                          _getSearchIconOpacity(_animationController!.value),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchViewVisible = !_searchViewVisible;
                          });
                        },
                        child: Icon(
                          Icons.search_outlined,
                          size: Dimensions.getScaledSize(28.0),
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          SizedBox(
            width: Dimensions.getScaledSize(6.0),
          ),
          NotificationView(
            negativePadding: true,
          ),
          SizedBox(
            width: Dimensions.getScaledSize(10.0),
          ),
          /*IconButton(
            icon: new Icon(
              Icons.notifications,
            ),
            iconSize: Dimensions.getScaledSize(32.0),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed(NotificationsScreen.route);
            },
          ),*/
        ],
      ),
    );
  }

  @override
  onDateChanged(DateTime dateTime) {
    setState(() {
      if (dateTime == null) {
        // _selectedDate = SelectedDate.NONE;
      } else if (GlobalDate.isToday(dateTime)) {
        // _selectedDate = SelectedDate.TODAY;
      } else if (GlobalDate.isTomorrow(dateTime)) {
        // _selectedDate = SelectedDate.TOMORROW;
      } else {
        // _selectedDate = SelectedDate.CUSTOM;
      }
    });
  }

  // Commenting because it's not used and dart shows error
/*  void _selectedDateChanges(SelectedDate selectedDate) {
    setState(() {
      if (_selectedDate == selectedDate) {
        _selectedDate = SelectedDate.NONE;
      } else {
        _selectedDate = selectedDate;
      }
    });

    if (_selectedDate == SelectedDate.NONE) {
      GlobalDate.set(null);
    }
    if (_selectedDate == SelectedDate.TODAY) {
      GlobalDate.setToday();
    } else if (_selectedDate == SelectedDate.TOMORROW) {
      GlobalDate.setTomorrow();
    }
  }*/

/*  void _selectCustomDate() {
    FocusScope.of(context).requestFocus(FocusNode());
    _showDateSelectorDialog(context: context);
  }*/

/*  void _showDateSelectorDialog({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialDate: GlobalDate.current(),
        onApplyClick: (DateTime date) {
          setState(() {
            if (date != null) {
              GlobalDate.set(date);
              onDateChanged(date);
            }
          });
        },
        onCancelClick: () {},
        usedForVendor: false,
      ),
    );
  }*/

  Widget _getActivityCategoryViews(List<String> favoriteIds) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: controller,
        addAutomaticKeepAlives: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(
          top: sliderImageHeight + Dimensions.getScaledSize(20.0),
        ),
        children: [
          ActivityListCategoryView(
            category: 'Outdoor',
            categoryId: '607d89db3b23a20eccaec989',
            favoriteIds: favoriteIds,
          ),
          SizedBox(
            height: Dimensions.getScaledSize(12.0),
          ),
          ActivityListCategoryView(
            category: 'Indoor',
            categoryId: '607d89f519b1aa0ed3345dc3',
            favoriteIds: favoriteIds,
          ),
          SizedBox(
            height: Dimensions.getScaledSize(12.0),
          ),
          ActivityListCategoryView(
            category: 'Action',
            categoryId: '5f9c5c3654babf6c5d6b2b20',
            favoriteIds: favoriteIds,
          ),
          SizedBox(
            height: Dimensions.getScaledSize(12.0),
          ),
          ActivityListCategoryView(
            category: 'Familie',
            categoryId: '5faa909e4e14857498ebdffe',
            favoriteIds: favoriteIds,
          ),
          SizedBox(
            height: Dimensions.getScaledSize(12.0),
          ),
          ActivityListCategoryView(
            category: 'Kurse und Workshops',
            categoryId: '607d8a0b19b1aa0ed3345dc5',
            favoriteIds: favoriteIds,
          ),
          SizedBox(
            height: Dimensions.getScaledSize(Platform.isAndroid ? 12.0 : 32.0),
          ),
        ],
      ),
    );
  }
}

double _getSearchIconOpacity(double animationControllerValue) {
  var opacity = (animationControllerValue - 0.38) * 5.0;

  if (opacity > 1.0)
    return 1.0;
  else if (opacity < 0.0)
    return 0.0;
  else
    return opacity;
}

enum SelectedDate {
  NONE,
  TODAY,
  TOMORROW,
  CUSTOM,
}

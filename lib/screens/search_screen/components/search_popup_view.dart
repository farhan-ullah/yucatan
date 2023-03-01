import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/activity_list_screen/activity_list_screen.dart';
import 'package:yucatan/screens/booking/components/calendarPopupView.dart';
import 'package:yucatan/screens/hotelDetailes/hotelDetailes.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/activity_multi_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/datefulWidget/DateStatefulWidget.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPopupView extends DateStatefulWidget {
  final double height;
  final bool visible;
  final Function onBackTap;

  SearchPopupView({
    required this.height,
    required this.visible,
    required this.onBackTap,
  });

  @override
  _SearchPopupViewState createState() => _SearchPopupViewState();
}

class _SearchPopupViewState extends DateState<SearchPopupView> {
  ActivityMultiResponse? activityMultiResponse;
  bool submitted = false;
  bool searched = false;
  SelectedDate? _selectedDate;
  List<String> _searchTerms = [];
  TextEditingController _searchTextController = TextEditingController();
  String? _searchTerm;

  @override
  void initState() {
    onDateChanged(GlobalDate.current());
    _searchTerms = _getSearchTerms();
    super.initState();
  }

  @override
  onDateChanged(DateTime dateTime) {
    setState(() {
      if (dateTime == null) {
        _selectedDate = SelectedDate.NONE;
      } else if (GlobalDate.isToday(dateTime)) {
        _selectedDate = SelectedDate.TODAY;
      } else if (GlobalDate.isTomorrow(dateTime)) {
        _selectedDate = SelectedDate.TOMORROW;
      } else {
        _selectedDate = SelectedDate.CUSTOM;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 1000,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getScaledSize(16.0),
          vertical: Dimensions.getScaledSize(8.0)),
      curve: Curves.fastLinearToSlowEaseIn,
      height: widget.visible ? widget.height : 0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Visibility(
        visible: widget.visible,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.onBackTap();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: Dimensions.getScaledSize(24.0),
                    color: CustomTheme.primaryColorDark,
                  ),
                ),
                SizedBox(
                  width: Dimensions.getScaledSize(8.0),
                ),
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (value) {
                        submitted = true;
                        _searchActivities();
                      },
                      onChanged: (value) {
                        setState(() {
                          _searchTerm = value;
                        });
                      },
                      controller: _searchTextController,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18),
                        color: CustomTheme.primaryColorDark,
                      ),
                      cursorColor: CustomTheme.primaryColorDark,
                      decoration: InputDecoration(
                        errorText: null,
                        hintText:
                            AppLocalizations.of(context)!.searchScreen_text,
                        hintStyle: TextStyle(
                          fontSize: Dimensions.getScaledSize(18),
                          color: CustomTheme.hintText,
                        ),
                        contentPadding: isNotNullOrEmpty(_searchTerm!)
                            ? EdgeInsets.only(
                                top: Dimensions.getScaledSize(2.0))
                            : EdgeInsets.only(
                                top: Dimensions.getScaledSize(5.0)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                    hideOnEmpty: true,
                    hideOnError: true,
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      elevation: 4,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                    ),
                    noItemsFoundBuilder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(Dimensions.getScaledSize(10.0)),
                        child: Text(
                            AppLocalizations.of(context)!.searchScreen_noItems),
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      return ( await ActivityService.getSuggestions(
                        query: pattern,
                        items: 10,
                      )!);
                    },
                    itemBuilder: (context, suggestion) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.getScaledSize(10.0),
                          vertical: Dimensions.getScaledSize(5.0),
                        ),
                        child: Text(
                          suggestion.toString(),
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(16),
                            color: CustomTheme.primaryColorDark,
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: ( suggestion) {
                      _searchTerm = suggestion.toString();
                      _searchTextController.text = suggestion.toString();
                      _searchActivities();
                    },
                  ),
                ),
                isNotNullOrEmpty(_searchTerm!)
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchTerm = '';
                            _searchTextController.text = '';
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: Dimensions.getScaledSize(24.0),
                          color: CustomTheme.primaryColorDark,
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: Dimensions.getScaledSize(8.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _selectedDateChanges(SelectedDate.TODAY);
                    },
                    child: Container(
                      height: Dimensions.getScaledSize(40.0),
                      padding: EdgeInsets.all(Dimensions.getScaledSize(6.0)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CustomTheme.mediumGrey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedDate == SelectedDate.TODAY
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.today,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(15),
                            fontWeight: FontWeight.bold,
                            color: _selectedDate == SelectedDate.TODAY
                                ? Colors.white
                                : CustomTheme.primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.getScaledSize(10),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _selectedDateChanges(SelectedDate.TOMORROW);
                    },
                    child: Container(
                      height: Dimensions.getScaledSize(40.0),
                      padding: EdgeInsets.all(Dimensions.getScaledSize(6.0)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CustomTheme.mediumGrey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedDate == SelectedDate.TOMORROW
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.tomorrow,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(15),
                            fontWeight: FontWeight.bold,
                            color: _selectedDate == SelectedDate.TOMORROW
                                ? Colors.white
                                : CustomTheme.primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.getScaledSize(10),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _selectCustomDate();
                    },
                    child: Container(
                      height: Dimensions.getScaledSize(40.0),
                      padding: EdgeInsets.all(Dimensions.getScaledSize(6.0)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CustomTheme.mediumGrey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedDate == SelectedDate.CUSTOM
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                      child: SvgPicture.asset(
                        'lib/assets/images/calendar.svg',
                        color: _selectedDate == SelectedDate.CUSTOM
                            ? Colors.white
                            : CustomTheme.primaryColorDark,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.getScaledSize(10.0),
            ),
            searched
                ? Container()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'lib/assets/images/search.png',
                              height: MediaQuery.of(context).size.height * 0.32,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(20.0),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .searchScreen_iWishText,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(20.0),
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColorDark,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(20.0),
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            spacing: Dimensions.getScaledSize(15),
                            runSpacing: Dimensions.getScaledSize(10.0),
                            children: [
                              ..._searchTerms.map(
                                (searchTerm) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchTextController.text = searchTerm;
                                      _searchTerm = searchTerm;
                                      _searchActivities();
                                    });
                                  },
                                  child: IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          Dimensions.getScaledSize(12.0)),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: CustomTheme.hintText,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          searchTerm,
                                          style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(18.0),
                                            color: CustomTheme.hintText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            submitted
                ? Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.getScaledSize(200.0),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : activityMultiResponse != null &&
                        activityMultiResponse!.data != null &&
                        activityMultiResponse!.data!.length > 0
                    ? Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ActivitySearchListViewItem(
                                activity: activityMultiResponse!.data![index],
                              );
                            },
                            itemCount: activityMultiResponse!.data!.length,
                            scrollDirection: Axis.vertical,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(searched
                            ? AppLocalizations.of(context)!
                                .searchScreen_noActivities
                            : ''),
                      ),
          ],
        ),
      ),
    );
  }

  void _searchActivities() async {
    setState(() {
      searched = true;
      submitted = true;
    });

    if (GlobalDate.current() != null) {
      String date = DateFormat('dd-MM-yy').format(GlobalDate.current());

      activityMultiResponse = await ActivityService.getActivitiesBySearchTerm(
        date: date,
        searchTerm: _searchTerm,
      );
    } else {
      activityMultiResponse = await ActivityService.getActivitiesBySearchTerm(
        searchTerm: _searchTerm,
      );
    }

    setState(() {
      submitted = false;
    });
  }

  List<String> _getSearchTerms() {
    return [
      'E-Bike',
      'Skiverleih',
      'Museum',
      'Action',
      'Entspannung',
    ];
  }

  void _selectedDateChanges(SelectedDate selectedDate) {
    setState(() {
      if (_selectedDate == selectedDate) {
        _selectedDate = SelectedDate.NONE;
      } else {
        _selectedDate = selectedDate;
      }
    });

    if (_selectedDate == SelectedDate.NONE) {
      GlobalDate.set(DateTime.now());
    }
    if (_selectedDate == SelectedDate.TODAY) {
      GlobalDate.setToday();
    } else if (_selectedDate == SelectedDate.TOMORROW) {
      GlobalDate.setTomorrow();
    }
  }

  void _selectCustomDate() {
    FocusScope.of(context).requestFocus(FocusNode());
    _showDateSelectorDialog(context: context);
  }

  void _showDateSelectorDialog({BuildContext? context}) {
    showDialog(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialDate: GlobalDate.current(),
        onApplyClick: (DateTime date) {
          setState(() {
            if (date != null) {
              GlobalDate.set(date);
              _searchActivities();
            }
          });
        },
        onCancelClick: () {},
        usedForVendor: false,
      ),
    );
  }
}

class ActivitySearchListViewItem extends StatelessWidget {
  final ActivityModel? activity;

  ActivitySearchListViewItem({this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(24.0),
            top: Dimensions.getScaledSize(8.0),
            bottom: Dimensions.getScaledSize(16.0),
            right: Dimensions.getScaledSize(24.0)),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomTheme.mediumGrey,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: CustomTheme.backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: Dimensions.getScaledSize(6.0),
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HotelDetailes(
                        //TODO
                        isFavorite: false,
                        //hotelData: activity,
                        activityId: activity!.sId!,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: Dimensions.getHeight(percentage: 18.0),
                                child: loadCachedNetworkImage(
                                  activity!.thumbnail!.publicUrl!,
                                  height:
                                      Dimensions.getHeight(percentage: 20.0),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: Dimensions.getHeight(percentage: 9.0),
                                  width: Dimensions.getWidth(percentage: 75),
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
                                  width: Dimensions.getWidth(percentage: 75.0),
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
                                          height:
                                              Dimensions.getScaledSize(40.0),
                                          width: Dimensions.getWidth(
                                              percentage: 75),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "${activity!.title!.trim()}",
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      Dimensions.getScaledSize(
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
                        ],
                      ),
                      Container(
                        //color: CustomTheme.backgroundColor,
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
                                      /*Text(
                                        activity.title,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              Dimensions.getScaledSize(17.0),
                                        ),
                                      ),*/
                                      /*Text(
                                        activity.vendor.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(13.0),
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      ),*/
                                      SizedBox(
                                        height: Dimensions.getScaledSize(5.0),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
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
                                                          .getScaledSize(12.0),
                                                      color: CustomTheme
                                                          .primaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: Dimensions
                                                          .getScaledSize(5),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${activity!.location!.zipcode} ${activity!.location!.city} ',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: Dimensions
                                                                .getScaledSize(
                                                                    13.0),
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.8)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: Dimensions
                                                          .getScaledSize(4.0)),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SmoothStarRating(
                                                        allowHalfRating: true,
                                                        starCount: 1,
                                                        rating: 1,
                                                        /*rating: activity.reviewAverageRating !=null
                                                            ? activity.reviewAverageRating
                                                            : 0,*/
                                                        size: Dimensions
                                                            .getScaledSize(
                                                                20.0),
                                                        color: CustomTheme
                                                            .accentColor3,
                                                        borderColor: CustomTheme
                                                            .primaryColor,
                                                      ),
                                                      activity!.reviewCount! > 0
                                                          ? Text(
                                                              " ${activity!.reviewAverageRating.toString().replaceAll('.', ',')}",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            )
                                                          : Text(
                                                              " ${AppLocalizations.of(context)}",
                                                              style: TextStyle(
                                                                fontSize: Dimensions
                                                                    .getScaledSize(
                                                                        13.0),
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    fontSize: Dimensions
                                                        .getScaledSize(13.0),
                                                    color: Colors.grey
                                                        .withOpacity(0.8)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${AppLocalizations.of(context)!.commonWords_from} ",
                                                    style: TextStyle(
                                                        fontSize: Dimensions
                                                            .getScaledSize(
                                                                13.0),
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                  Text(
                                                    "${formatPriceDouble(activity!.priceFrom!)}€",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .getScaledSize(21.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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

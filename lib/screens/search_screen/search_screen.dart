import 'package:appventure/components/custom_app_bar.dart';
import 'package:appventure/models/activity_model.dart';
import 'package:appventure/screens/activity_list_screen/activity_list_screen.dart';
import 'package:appventure/screens/booking/components/calendarPopupView.dart';
import 'package:appventure/screens/hotelDetailes/hotelDetailes.dart';
import 'package:appventure/services/activity_service.dart';
import 'package:appventure/services/response/activity_multi_response.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/StringUtils.dart';
import 'package:appventure/utils/datefulWidget/DateStatefulWidget.dart';
import 'package:appventure/utils/datefulWidget/GlobalDate.dart';
import 'package:appventure/utils/networkImage/network_image_loader.dart';
import 'package:appventure/utils/price_format_utils.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends DateStatefulWidget {
  static final route = "/search";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends DateState<SearchScreen> {
  ActivityMultiResponse activityMultiResponse;
  bool submitted = false;
  bool searched = false;
  SelectedDate _selectedDate;
  List<String> _searchTerms = [];
  TextEditingController _searchTextController = TextEditingController();
  String _searchTerm;

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
    return Scaffold(
      backgroundColor: CustomTheme.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).searchScreen_title,
        appBar: AppBar(),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.getScaledSize(12.0),
              bottom: Dimensions.getScaledSize(12.0),
              left: Dimensions.getScaledSize(24.0),
              right: Dimensions.getScaledSize(24.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      _selectedDateChanges(SelectedDate.TODAY);
                      _searchActivities();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (state) => _selectedDate == SelectedDate.TODAY
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).today,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(15.0),
                        fontWeight: FontWeight.bold,
                        color: _selectedDate == SelectedDate.TODAY
                            ? Colors.white
                            : CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.getScaledSize(10.0),
                ),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      _selectedDateChanges(SelectedDate.TOMORROW);
                      _searchActivities();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (state) => _selectedDate == SelectedDate.TOMORROW
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).tomorrow,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(15.0),
                        fontWeight: FontWeight.bold,
                        color: _selectedDate == SelectedDate.TOMORROW
                            ? Colors.white
                            : CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.getScaledSize(10.0),
                ),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      _selectCustomDate();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (state) => _selectedDate == SelectedDate.CUSTOM
                            ? CustomTheme.primaryColorDark
                            : Colors.white,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'lib/assets/images/calendar.svg',
                      color: _selectedDate == SelectedDate.CUSTOM
                          ? Colors.white
                          : CustomTheme.primaryColorDark,
                      height: Dimensions.getScaledSize(24.0),
                      width: Dimensions.getScaledSize(24.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
                top: 0,
                bottom: 0),
            child: Container(
              decoration: BoxDecoration(
                color: CustomTheme.mediumGrey,
                borderRadius:
                    BorderRadius.circular(Dimensions.getScaledSize(5.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: CustomTheme.grey,
                    blurRadius: Dimensions.getScaledSize(8.0),
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.getScaledSize(16.0),
                    right: Dimensions.getScaledSize(16.0)),
                child: Container(
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _searchActivities();
                          },
                          child: Icon(
                            FontAwesomeIcons.search,
                            size: Dimensions.getScaledSize(18.0),
                            color: CustomTheme.primaryColor,
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
                                _searchTerm = value;
                              },
                              controller: _searchTextController,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(16.0),
                              ),
                              cursorColor: CustomTheme.primaryColor,
                              decoration: new InputDecoration(
                                errorText: null,
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)
                                    .searchScreen_text,
                                hintStyle: TextStyle(
                                  color: CustomTheme.disabledColor,
                                ),
                              ),
                            ),
                            hideOnEmpty: true,
                            hideOnError: true,
                            noItemsFoundBuilder: (context) {
                              return Padding(
                                padding: EdgeInsets.all(
                                  Dimensions.getScaledSize(10.0),
                                ),
                                child: Text(AppLocalizations.of(context)
                                    .searchScreen_noItems),
                              );
                            },
                            suggestionsCallback: (pattern) async {
                              return await ActivityService.getSuggestions(
                                query: pattern,
                                items: 10,
                              );
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              _searchTerm = suggestion;
                              _searchTextController.text = suggestion;
                              _searchActivities();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.getScaledSize(10.0),
          ),
          searched
              ? Container()
              : SingleChildScrollView(
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
                        height: Dimensions.getScaledSize(10.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context).searchScreen_iWishText,
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
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          spacing: Dimensions.getScaledSize(15.0),
                          runSpacing: Dimensions.getScaledSize(20.0),
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
                                        color: CustomTheme.mediumGrey,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.getScaledSize(5.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        searchTerm,
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(18.0),
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
                    ],
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
                      activityMultiResponse.data != null &&
                      activityMultiResponse.data.length > 0
                  ? Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ActivitySearchListViewItem(
                              activity: activityMultiResponse.data[index],
                            );
                          },
                          itemCount: activityMultiResponse.data.length,
                          scrollDirection: Axis.vertical,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(searched
                          ? AppLocalizations.of(context)
                              .searchScreen_noActivities
                          : ''),
                    ),
        ],
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
      GlobalDate.set(null);
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

  void _showDateSelectorDialog({BuildContext context}) {
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
  final ActivityModel activity;

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
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.getScaledSize(16.0))),
                color: CustomTheme.backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: CustomTheme.grey,
                    offset: Offset(4, 4),
                    blurRadius: Dimensions.getScaledSize(16.0),
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
                        activityId: activity.sId,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.getScaledSize(16.0))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: Dimensions.getScaledSize(140.0),
                        child: loadCachedNetworkImage(
                          isNotNullOrEmpty(activity.thumbnail?.publicUrl)
                              ? activity.thumbnail?.publicUrl
                              : "",
                          height: Dimensions.getScaledSize(140.0),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        color: CustomTheme.backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: Dimensions.getScaledSize(8.0),
                                    top: Dimensions.getScaledSize(8.0),
                                    bottom: Dimensions.getScaledSize(8.0),
                                    right: Dimensions.getScaledSize(8.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        activity.title,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              Dimensions.getScaledSize(17.0),
                                        ),
                                      ),
                                      Text(
                                        activity.vendor.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(13.0),
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      ),
                                      SizedBox(
                                        height: Dimensions.getScaledSize(12.0),
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
                                                          .getScaledSize(5.0),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${activity.location.zipcode} ${activity.location.city} ',
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
                                                        starCount: 5,
                                                        rating: activity
                                                                    .reviewAverageRating !=
                                                                null
                                                            ? activity
                                                                .reviewAverageRating
                                                            : 0,
                                                        size: Dimensions
                                                            .getScaledSize(
                                                                20.0),
                                                        color: CustomTheme
                                                            .primaryColor,
                                                        borderColor: CustomTheme
                                                            .primaryColor,
                                                      ),
                                                      activity.reviewCount > 0
                                                          ? Text(
                                                              " ${activity.reviewAverageRating.toString().replaceAll('.', ',')}",
                                                              style: TextStyle(
                                                                  fontSize: Dimensions
                                                                      .getScaledSize(
                                                                          14.0),
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            )
                                                          : Container(),
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
                                                AppLocalizations.of(context)
                                                    .searchScreen_availableFrom,
                                                style: TextStyle(
                                                    fontSize: Dimensions
                                                        .getScaledSize(13.0),
                                                    color: Colors.grey
                                                        .withOpacity(0.8)),
                                              ),
                                              Text(
                                                formatPriceDouble(
                                                    activity.priceFrom),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Dimensions
                                                        .getScaledSize(21.0)),
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

import 'dart:async';

import 'package:yucatan/models/local_search_model.dart';
import 'package:yucatan/screens/search_screen/components/search_activity_item_view.dart';
import 'package:yucatan/screens/search_screen/components/search_history_view.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/response/activity_multi_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPopupView extends StatefulWidget {
  final double height;
  final bool visible;
  final Function onBackTap;
  final List<String> favoriteList;
  final UserLoginModel? userData;

  SearchPopupView({
    required this.height,
    required this.visible,
    required this.onBackTap,
    required this.favoriteList,
    this.userData,
  });

  @override
  _SearchPopupViewState createState() => _SearchPopupViewState();
}

class _SearchPopupViewState extends State<SearchPopupView>
    with WidgetsBindingObserver {
  Future<ActivityMultiResponse>? activityMultiResponse;
  List<String> _searchTerms = [];
  TextEditingController _searchTextController = TextEditingController();
  List _suggestionList = [];
  List<String> _localSearchHistory = [];
  bool _isSearching = false;
  bool _isActivitySearching = false;
  static const MAX_LAST_SEARCH = 6;
  bool _isSearchingSuggestion = false;
  Timer? _debounce;
  FocusNode? _searchFocusNode;

  @override
  void initState() {
    _searchFocusNode = FocusNode();
    _searchTerms = _getSearchTerms();
    checkLocalHistory();
    eventBus.on<OnSearchPopUpOpen>().listen((event) {
      if (event.isSearchPopWidgetVisible) {
        FocusScope.of(context).requestFocus(_searchFocusNode);
        _searchFocusNode!.addListener(() {
          _suggestionList.clear();
          setState(() {
            _isSearching = true;
          });
        });
      }
    });
    super.initState();
  }

  /*@override
  void didUpdateWidget(covariant SearchPopupView oldWidget) {
    */ /*if (!oldWidget.visible && widget.visible) _searchFocusNode.requestFocus();
    if (!oldWidget.visible && widget.visible && mounted) checkLocalHistory();*/ /*
    super.didUpdateWidget(oldWidget);
  }*/

  @override
  void dispose() {
    if (_searchTextController != null) _searchTextController.dispose();
    if (_searchFocusNode != null) _searchFocusNode!.dispose();
    super.dispose();
  }

  void checkLocalHistory() {
    _getLocalSearchHistory().then((value) {
      setState(() {
        value.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
        // _localSearchHistory = value.map((e) => e.query).toSet().toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 1000,
      ),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getScaledSize(16.0)),
      curve: Curves.fastLinearToSlowEaseIn,
      height: widget.visible ? widget.height : 0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimensions.getScaledSize(16.0)),
            topLeft: Radius.circular(Dimensions.getScaledSize(16.0))),
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
                    _isSearching = false;
                    _isSearchingSuggestion = false;
                    _isActivitySearching = false;
                    _searchTextController.text = '';
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
                    child: TextField(
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  enabled: !_isActivitySearching,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(18),
                    color: CustomTheme.primaryColorDark,
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(Duration(milliseconds: 500), () {
                      /*if(!_isSearching && value.isNotEmpty){
                        setState(() {
                          _isSearching = true;
                        });
                      }*/
                      _searchSuggestion(value);
                    });
                  },
                  onTap: () {
                    _suggestionList.clear();
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _isSearchingSuggestion = true;
                    });
                    _searchSuggestion(value);
                  },
                  /*onSubmitted: (value) {
                    setState(() {
                      _isSearchingSuggestion = true;
                    });
                    _searchSuggestion(value);
                  },*/
                  controller: _searchTextController,
                  minLines: 1,
                  decoration: InputDecoration(
                    errorText: null,
                    hintText:
                        AppLocalizations.of(context)!.searchPopupView_title,
                    hintStyle: TextStyle(
                      fontSize: Dimensions.getScaledSize(15),
                      color: CustomTheme.hintText,
                    ),
                    contentPadding:
                        EdgeInsets.only(top: Dimensions.getScaledSize(2.0)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                )),
                _isSearching
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchTextController.text = '';
                            if (!_searchFocusNode!.hasFocus) {
                              _isSearching = false;
                            }
                            _isActivitySearching = false;
                          });
                          checkLocalHistory();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.all(Dimensions.getScaledSize(4.0)),
                          decoration: BoxDecoration(
                            color: CustomTheme.mediumGrey,
                            borderRadius: BorderRadius.circular(
                              Dimensions.getScaledSize(16.0),
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: Dimensions.getScaledSize(20.0),
                            color: CustomTheme.darkGrey,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: Dimensions.getScaledSize(8.0),
            ),
            !_isActivitySearching
                ? _isSearching
                    ? Expanded(
                        child: _isSearchingSuggestion
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : _suggestionList.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return HistoryView(
                                        data: _suggestionList[index],
                                        isHistoryView: false,
                                        callback: () {
                                          setState(() {
                                            _searchTextController.text =
                                                _suggestionList[index];
                                            _searchActivities(
                                                _suggestionList[index]);
                                          });
                                        },
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: _suggestionList.length,
                                  )
                                : _getNoResultWidget(true),
                      )
                    : Expanded(
                        child: _getNoResultWidget(false),
                      )
                : Container(),
            _isActivitySearching
                ? Expanded(
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Keine Aktivitäten gefunden'),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          ActivityMultiResponse model =
                              snapshot.data as ActivityMultiResponse;
                          return model.data!.isNotEmpty
                              ? ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: Dimensions.getScaledSize(5),
                                      ),
                                      child: SearchActivityItemView(
                                        userData: widget.userData!,
                                        activity: model.data![index],
                                        isfav: widget.favoriteList
                                            .contains(model.data![index].sId),
                                        onFavoriteChangedCallback: (activity) {
                                          if (mounted) {
                                            setState(() {
                                              if (widget.favoriteList
                                                  .contains(activity.sId))
                                                widget.favoriteList
                                                    .remove(activity.sId);
                                              else {
                                                widget.favoriteList
                                                    .add(activity.sId!);
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).padding.bottom +
                                            Dimensions.getScaledSize(60),
                                  ),
                                  itemCount: model.data!.length,
                                )
                              : _getNoResultWidget(true);
                        }

                        return Container();
                      },
                      future: activityMultiResponse,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _getNoResultWidget(bool postSearch) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimensions.getScaledSize(20.0),
          ),
          _localSearchHistory.isNotEmpty
              ? SearchHistoryView(_localSearchHistory, checkLocalHistory,
                  (query) {
                  setState(() {
                    _searchTextController.text = query;
                  });
                  _searchActivities(query);
                })
              : Column(
                  children: [
                    Text(
                      'Ooops!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.getScaledSize(16.0),
                        letterSpacing: CustomTheme.letterSpacing,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(16.0),
                    ),
                    Text(
                      postSearch
                          ? 'Keine Aktivität gefunden'
                          : 'Keine Aktivität gesucht',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(14.0),
                        letterSpacing: CustomTheme.letterSpacing,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(30.0),
                    ),
                    Center(
                      /*child: Image.asset(
                        'lib/assets/images/search.png',
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      ),*/
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width,
                        child: RiveAnimation(
                          riveFileName: 'search_animiert.riv',
                          riveAnimationName: 'Animation 1',
                          placeholderImage: 'lib/assets/images/search.png',
                          startAnimationAfterMilliseconds: 0,
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: Dimensions.getScaledSize(40.0),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aktivitäten in lhrer Nähe',
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(20.0),
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              SizedBox(
                height: Dimensions.getScaledSize(16.0),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                spacing: Dimensions.getScaledSize(8.0),
                runSpacing: Dimensions.getScaledSize(8.0),
                children: [
                  ..._searchTerms.map(
                    (searchTerm) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchTextController.text = searchTerm;
                          _searchActivities(searchTerm);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.getScaledSize(12.0),
                          vertical: Dimensions.getScaledSize(6.0),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: CustomTheme.primaryColorLight.withOpacity(0.1),
                          border: Border.fromBorderSide(BorderSide.none),
                          borderRadius: BorderRadius.circular(
                            Dimensions.getScaledSize(8.0),
                          ),
                        ),
                        child: Text(
                          searchTerm,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(14.0),
                            color: CustomTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void _searchActivities(String activityQuery) async {
    setState(() {
      _isActivitySearching = true;
      _isSearching = true;
    });

    if (GlobalDate.current() != null) {
      String date = DateFormat('dd-MM-yy').format(GlobalDate.current());

      activityMultiResponse = ActivityService.getActivitiesBySearchTerm(
        date: date,
        searchTerm: activityQuery,
      );
    } else {
      activityMultiResponse = ActivityService.getActivitiesBySearchTerm(
        searchTerm: activityQuery,
      );
    }
  }

  List<String> _getSearchTerms() {
    return [
      'eBike',
      'Museum',
      'Action',
      'Rafting',
      'Wandern',
      'Klettern',
      'Entspannung',
      'Workshop',
      'Kunst',
      'Natur'
    ];
  }

  _searchSuggestion(String query) async {
    setState(() {
      _isSearchingSuggestion = true;
    });

    _saveQuery(query);
    ActivityService.getSuggestions(
      query: query,
      items: 10,
    )!.then((value) {
      // try {
      //   FocusScope.of(context).requestFocus(FocusNode());
      // } catch (e) {}
      setState(() {
        _suggestionList = value!;
        _isSearchingSuggestion = false;
      });
    });
  }

  _saveQuery(String query) async {
    if (query.isEmpty) {
      return;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentIndex = sharedPreferences.getInt("Local_Search") ?? 0;

    LocalSearchModel model = LocalSearchModel()
      ..index = currentIndex
      ..query = query
      ..dateTime = DateTime.now();

    HiveService.setLastSearchQuery(model);
    if (currentIndex < MAX_LAST_SEARCH - 1) {
      int nextIndex = currentIndex + 1;
      sharedPreferences.setInt("Local_Search", nextIndex);
    } else {
      sharedPreferences.setInt("Local_Search", 0);
    }
  }

  Future<List<LocalSearchModel>> _getLocalSearchHistory() async {
    return await HiveService.getLastSearchQuery();
  }
}

import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/screens/booking/components/calendarPopupView.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_bloc/vendor_demand_bloc.dart';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_bloc/date_options_bloc.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_date_button.dart';
import 'package:yucatan/services/connection/NetworkObserver.dart';
import 'package:yucatan/services/response/product_demand_response.dart';
import 'package:yucatan/services/service_locator.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/common_widgets.dart';
import 'package:yucatan/utils/datefulWidget/DateStatefulWidget.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/image_util.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VendorDemandScreen extends DateStatefulWidget {
  static final route = "/vendor/demand";

  @override
  _ProviderRequirementState createState() {
    return _ProviderRequirementState();
  }
}

class _ProviderRequirementState extends DateState<VendorDemandScreen> {
  final NetworkObserver network = getIt.get<NetworkObserver>();
  SelectedDate _selectedDate;
  double borderRadius = 10;
  double celldiff = 8;
  DateParameters dateParameters = new DateParameters();
  //ProductDemandResponse productsResponse;
  //bool showLoader = false;
  List<ProductDemand> productsList = [];
  //bool isNetworkAvailable = true;
  final vendorDemandBloc = getIt<VendorDemandBloc>();
  final dateOptionsBloc = getIt<DateOptionsBloc>();

  @override
  void initState() {
    super.initState();
    if (!this.network.offline) {
      onDateOptionClicked(SelectedDate.TODAY);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !this.network.offline
          ? CustomTheme.vendorMenubackground
          : Colors.white,
      appBar: CustomAppBar(
        centerTitle: true,
        title: AppLocalizations.of(context)!.vendor_demandScreen_title,
        appBar: AppBar(),
        backgroundColor: CustomTheme.primaryColorLight,
        actions: [
          Container(
            margin:
                EdgeInsets.fromLTRB(0, 0, Dimensions.getScaledSize(20.0), 0),
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).pushNamed(NotificationsScreen.route);
              },
              child: NotificationView(
                defaultIcon: false,
                color: Colors.white,
                icon: Icons.notifications_outlined,
                negativePadding: false,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<SelectedDate>(
              stream: dateOptionsBloc.dateOptionStream,
              builder: (context, snapshot) {
                if (this.network.offline) {
                  return Container();
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Expanded(
                        child: Container(child: CommonWidget.showSpinner()));
                  default:
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      _selectedDate = snapshot.data;
                      return Container(
                        color: !this.network.offline
                            ? CustomTheme.vendorMenubackground
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: Dimensions.getScaledSize(12.0),
                            bottom: 0,
                            left: Dimensions.getScaledSize(15.0),
                            right: Dimensions.getScaledSize(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              VendorBookingDateButton(
                                  text: AppLocalizations.of(context)!.today,
                                  onTap: () =>
                                      onDateOptionClicked(SelectedDate.TODAY),
                                  selected: _selectedDate == SelectedDate.TODAY,
                                  fontSize: Dimensions.getScaledSize(14.0),
                                  height: Dimensions.getScaledSize(40.0),
                                  width: double.infinity,
                                  color: CustomTheme.primaryColorLight),
                              SizedBox(
                                width: Dimensions.getScaledSize(celldiff),
                              ),
                              VendorBookingDateButton(
                                  text: AppLocalizations.of(context)!.tomorrow,
                                  onTap: () => onDateOptionClicked(
                                      SelectedDate.TOMORROW),
                                  selected:
                                      _selectedDate == SelectedDate.TOMORROW,
                                  fontSize: Dimensions.getScaledSize(14.0),
                                  height: Dimensions.getScaledSize(40.0),
                                  width: double.infinity,
                                  color: CustomTheme.primaryColorLight),
                              SizedBox(
                                width: Dimensions.getScaledSize(celldiff),
                              ),
                              VendorBookingDateButton(
                                  text: AppLocalizations.of(context)!
                                      .commonWords_week,
                                  onTap: () =>
                                      onDateOptionClicked(SelectedDate.WEEK),
                                  selected: _selectedDate == SelectedDate.WEEK,
                                  fontSize: Dimensions.getScaledSize(14.0),
                                  height: Dimensions.getScaledSize(40.0),
                                  width: double.infinity,
                                  color: CustomTheme.primaryColorLight),
                              SizedBox(
                                width: Dimensions.getScaledSize(celldiff),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectCustomDate();
                                },
                                child: Container(
                                  height: Dimensions.getScaledSize(40.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: CustomTheme.primaryColorLight,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'lib/assets/images/calendar.svg',
                                      color: Colors.white,
                                      height: Dimensions.getScaledSize(24),
                                      width: Dimensions.getScaledSize(24),
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
              }),
          StreamBuilder<ProductDemandResponse>(
              stream: vendorDemandBloc.vendorDemandStream,
              builder: (context, snapshot) {
                if (this.network.offline) {
                  return Expanded(
                      child:
                          Container(child: Center(child: showPlaceholder())));
                }
                if (snapshot.data == null) {
                  return Expanded(
                      child: Container(child: CommonWidget.showSpinner()));
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Expanded(
                        child: Container(child: CommonWidget.showSpinner()));
                  default:
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      productsList = snapshot.data.productsList;
                      if (productsList.isEmpty) {
                        return showEmptyView();
                      } else {
                        return Container(
                          width: double.infinity,
                          color: !this.network.offline
                              ? CustomTheme.vendorMenubackground
                              : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                  Dimensions.getScaledSize(15.0),
                                  Dimensions.getScaledSize(10.0),
                                  Dimensions.getScaledSize(15.0),
                                  Dimensions.getScaledSize(15.0),
                                ),
                                width: double
                                    .infinity, //To make it use as much space as it wants
                                height: Dimensions.getHeight(percentage: 78),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(borderRadius),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(
                                          Dimensions.getScaledSize(20.0)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .commonWords_products,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      15.0),
                                              color:
                                                  CustomTheme.primaryColorLight,
                                              fontFamily:
                                                  CustomTheme.fontFamily,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .vendor_table_count,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      15.0),
                                              color:
                                                  CustomTheme.primaryColorLight,
                                              fontFamily:
                                                  CustomTheme.fontFamily,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: productsList.length,
                                        //physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return providerListRow(
                                              "${productsList[index].title}",
                                              "${productsList[index].quantity}",
                                              true);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                }
              }),
        ],
      ),
    );
  }

  Widget showEmptyView() {
    return Expanded(
      child: Container(
        color: CustomTheme.vendorMenubackground,
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Text(
          AppLocalizations.of(context)!.vendor_demandScreen_noDemand,
          style: TextStyle(color: CustomTheme.primaryColorLight),
        )),
      ),
    );
  }

  Widget showPlaceholder() {
    return ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
      if (!this.network.offline) {
        onDateOptionClicked(SelectedDate.TODAY);
      }
    });
  }

  Widget providerListRow(String text, String number, bool showDivider) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimensions.getScaledSize(20.0), 0, Dimensions.getScaledSize(20.0), 0),
      height: 50,
      child: Center(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: Dimensions.getScaledSize(15.0),
                        color: CustomTheme.primaryColorLight,
                        fontFamily: CustomTheme.fontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  width: Dimensions.getScaledSize(5.0),
                ),
                Text(
                  number,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: Dimensions.getScaledSize(15.0),
                      color: CustomTheme.primaryColorLight,
                      fontFamily: CustomTheme.fontFamily,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.getScaledSize(5.0),
            ),
            Visibility(
              visible: showDivider,
              child: Divider(
                color: CustomTheme.primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDateOptionClicked(SelectedDate dateValue) async {
    if (dateValue == SelectedDate.TODAY) {
      _selectedDate = SelectedDate.TODAY;
      dateParameters.getTodayParams();
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    } else if (dateValue == SelectedDate.TOMORROW) {
      _selectedDate = SelectedDate.TOMORROW;
      dateParameters.getTomorrowParams();
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    } else if (dateValue == SelectedDate.WEEK) {
      _selectedDate = SelectedDate.WEEK;
      dateParameters.getWeekParams();
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    } else if (dateValue == SelectedDate.CUSTOM) {
      _selectedDate = SelectedDate.CUSTOM;
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    }
  }

  @override
  onDateChanged(DateTime dateTime) async {
    if (dateTime == null) {
    } else if (GlobalDate.isToday(dateTime)) {
      _selectedDate = SelectedDate.TODAY;
      dateParameters.getTodayParams();
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    } else if (GlobalDate.isTomorrow(dateTime)) {
      _selectedDate = SelectedDate.TOMORROW;
      dateParameters.getTomorrowParams();
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    } else {
      _selectedDate = SelectedDate.CUSTOM;
      dateParameters.getCustomParams(dateTime);
      dateOptionsBloc.updateSelectedDate(_selectedDate);
      dateOptionsBloc.eventSink.add(DateOptionsAction.SelectedDate);
      vendorDemandBloc.updateDateParams(dateParameters);
      vendorDemandBloc.eventSink
          .add(VendorDemandBlocAction.FetchVendorDemandData);
    }
  }

  void rebuildUI() {
    setState(() {});
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
        minimumDate: DateTime.now().subtract(Duration(days: 730)),
        initialDate: GlobalDate.current(),
        onApplyClick: (DateTime date) {
          setState(() {
            if (date != null) {
              GlobalDate.set(date);
            }
          });
        },
        onCancelClick: () {},
        usedForVendor: true,
      ),
    );
  }

  /*Widget _showLoader(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }*/
}

class DateParameters {
  DateTime _fromDate;
  DateTime _toDate;

  void getTodayParams() {
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day);
    _toDate = _fromDate;
  }

  void getTomorrowParams() {
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day + 1);
    _toDate = _fromDate;
  }

  /*
  * Week dates would be:
    dateFrom: 2021-03-22T00:00:00
    dateTo: 2021-03-29T00:00:00
  * */
  void getWeekParams() {
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day);
    _toDate = DateTime(_fromDate.year, _fromDate.month, _fromDate.day + 7);
  }

  void getCustomParams(DateTime customDateTime) {
    _fromDate =
        DateTime(customDateTime.year, customDateTime.month, customDateTime.day);
    _toDate = _fromDate;
  }

  get toDate {
    return _toDate.toIso8601String();
  }

  set toDate(value) {
    _toDate = value;
  }

  get fromDate {
    return _fromDate.toIso8601String();
  }

  set fromDate(value) {
    _fromDate = value;
  }
}

enum SelectedDate {
  TODAY,
  TOMORROW,
  WEEK,
  CUSTOM,
}

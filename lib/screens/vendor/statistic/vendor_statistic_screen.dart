import 'package:yucatan/components/BaseState.dart';
import 'package:yucatan/services/statistic_service.dart';
import 'package:yucatan/utils/image_util.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_date_button.dart';
import 'package:yucatan/services/response/vendor_booking_statistic_single_response_entity.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/models/vendor_booking_statistic_model.dart';
import 'package:intl/intl.dart';

class VendorStatisticScreen extends StatefulWidget {
  static const route = '/vendorstatisticscreen';
  @override
  createState() {
    return _VendorStatisticScreenState();
  }
}

enum SelectedPeriod { WEEK, MONTH, YEAR, ALL, NONE }

enum StatisticPreviewMode { AMOUNT, REVENUE }

class _VendorStatisticScreenState extends BaseState<VendorStatisticScreen> {
  //DateTime _selectedDate;
  DateTime _dateFrom;
  DateTime _dateTo;
  SelectedPeriod _selectedPeriod;
  final buttonColor = Color(0xFF0071B8);
  Future<VendorBookingStatisticSingleResponseEntity> bookingStatistic;
  int _numberOfDays;
  int totalBookingAmount = 0;
  double totalRevenue = 0;
  double currentValue;
  List<DailyRevenueItem> revenueItems = [];
  double maxRevenue = 0;
  double minRevenue = double.infinity;
  int maxBookingAmount = 0;
  StatisticPreviewMode _statisticPreviewMode;
  VendorBookingStatisticModel statistic;

  getStatistics() {
    bookingStatistic = StatisticService.getVendorDetailedStatistic(
            getDateString(_dateFrom), getDateString(_dateTo))
        .then((response) {
      if (response.status == 200) {
        statistic = response.data;
        totalBookingAmount = statistic.numberOfBookings;
        totalRevenue = statistic.revenue;
        revenueItems = [];
        maxBookingAmount = 0;
        maxRevenue = 0.0;
        minRevenue = double.infinity;

        currentValue = _statisticPreviewMode == StatisticPreviewMode.REVENUE
            ? totalRevenue
            : totalBookingAmount.toDouble();

        DateTime dateToAdd = _dateFrom;

        statistic.dailyRevenueItems.forEach((dailyRevenueItem) {
          if (dailyRevenueItem.bookingAmount > maxBookingAmount)
            maxBookingAmount = dailyRevenueItem.bookingAmount;
          if (dailyRevenueItem.revenue > maxRevenue)
            maxRevenue = dailyRevenueItem.revenue;
          if (dailyRevenueItem.revenue < minRevenue)
            minRevenue = dailyRevenueItem.revenue;
          while (!dateToAdd.isAtSameMomentAs(dailyRevenueItem.date) &&
              revenueItems.length < _numberOfDays) {
            revenueItems.add(DailyRevenueItem(
                bookingAmount: 0, revenue: 0.0, date: dateToAdd));
            dateToAdd = dateToAdd.add(Duration(days: 1));
          }
          dateToAdd = dailyRevenueItem.date.add(Duration(days: 1));

          revenueItems.add(dailyRevenueItem);
        });
        while (!dateToAdd.isAtSameMomentAs(_dateTo.add(Duration(days: 1))) &&
            revenueItems.length < _numberOfDays) {
          revenueItems.add(DailyRevenueItem(
              bookingAmount: 0, revenue: 0.0, date: dateToAdd));
          dateToAdd = dateToAdd.add(Duration(days: 1));
        }
      }
      return response;
    });
  }

  DateTime getCurrentDate() {
    DateTime now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day);
  }

  getDateString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void initState() {
    _statisticPreviewMode = StatisticPreviewMode.REVENUE;
    _selectedPeriod = SelectedPeriod.WEEK;
    _dateTo = getCurrentDate();
    currentValue = 0.0;
    _dateFrom = _dateTo.subtract(Duration(days: 7));
    _numberOfDays = 7;
    getStatistics();
    super.initState();
  }

  void _selectedDateChanges(SelectedPeriod selectedPeriod) {
    if (!mounted) {
      return;
    }
    if (_selectedPeriod == selectedPeriod) {
      _selectedPeriod = SelectedPeriod.NONE;
    } else
      _selectedPeriod = selectedPeriod;

    _dateTo = getCurrentDate();
    switch (_selectedPeriod) {
      case SelectedPeriod.WEEK:
        _dateFrom = _dateTo.subtract(Duration(days: 7));
        _numberOfDays = 8;
        break;
      case SelectedPeriod.MONTH:
        _dateFrom = _dateTo.subtract(Duration(days: 31));
        _numberOfDays = 32;
        break;
      case SelectedPeriod.YEAR:
        _dateFrom = _dateTo.subtract(Duration(days: 365));
        _numberOfDays = 366;
        break;
      case SelectedPeriod.ALL:
        _dateFrom = _dateTo.subtract(Duration(days: 365));
        _numberOfDays = 366;
        break;
      case SelectedPeriod.NONE:
        _dateFrom = _dateTo.subtract(Duration(days: 11));
        _numberOfDays = 11;
        break;
    }

    setState(() {
      getStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFBDD4E1),
        //ADD app Locallization
        appBar: AppBar(
          centerTitle: true,
          title:
              Text(AppLocalizations.of(context)!.vendorStatisticScreen_title),
          actions: [
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, Dimensions.getScaledSize(15.0), 0),
                child: NotificationView(
                  negativePadding: false,
                )),
          ],
        ),
        body: this.network.offline
            ? getPlaceholderVeiw()
            : SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.getScaledSize(18)),
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.getScaledSize(20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VendorBookingDateButton(
                            text:
                                AppLocalizations.of(context)!.commonWords_week,
                            onTap: () =>
                                _selectedDateChanges(SelectedPeriod.WEEK),
                            selected: _selectedPeriod == SelectedPeriod.WEEK,
                            fontSize: Dimensions.getScaledSize(14.0),
                            height: Dimensions.getScaledSize(40.0),
                            width: double.infinity,
                            color: buttonColor),
                        SizedBox(width: Dimensions.getScaledSize(8.0)),
                        VendorBookingDateButton(
                            text:
                                AppLocalizations.of(context)!.commonWords_month,
                            onTap: () =>
                                _selectedDateChanges(SelectedPeriod.MONTH),
                            selected: _selectedPeriod == SelectedPeriod.MONTH,
                            fontSize: Dimensions.getScaledSize(14.0),
                            height: Dimensions.getScaledSize(40.0),
                            width: double.infinity,
                            color: buttonColor),
                        SizedBox(width: Dimensions.getScaledSize(8.0)),
                        VendorBookingDateButton(
                            text:
                                AppLocalizations.of(context)!.commonWords_year,
                            onTap: () =>
                                _selectedDateChanges(SelectedPeriod.YEAR),
                            selected: _selectedPeriod == SelectedPeriod.YEAR,
                            fontSize: Dimensions.getScaledSize(14.0),
                            height: Dimensions.getScaledSize(40.0),
                            width: double.infinity,
                            color: buttonColor),
                        SizedBox(width: Dimensions.getScaledSize(8.0)),
                        VendorBookingDateButton(
                            text: AppLocalizations.of(context)!.commonWords_all,
                            onTap: () =>
                                _selectedDateChanges(SelectedPeriod.ALL),
                            selected: _selectedPeriod == SelectedPeriod.ALL,
                            fontSize: Dimensions.getScaledSize(14.0),
                            height: Dimensions.getScaledSize(40.0),
                            width: double.infinity,
                            color: buttonColor),
                      ],
                    ),
                    SizedBox(height: Dimensions.getScaledSize(20.0)),
                    FutureBuilder<VendorBookingStatisticSingleResponseEntity>(
                      future: bookingStatistic,
                      builder: (context, snapshodStatistics) {
                        if (snapshodStatistics.connectionState ==
                            ConnectionState.waiting) return getShimmer(context);
                        // return Container(
                        //   width: double.infinity,
                        //   padding: EdgeInsets.only(
                        //       top: Dimensions.getHeight(percentage: 50.0) -
                        //           Scaffold.of(context).appBarMaxHeight),
                        //   child: Center(
                        //     child: CircularProgressIndicator(),
                        //   ),
                        // );

                        if (snapshodStatistics.hasData) {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.getScaledSize(18.0)),
                                    color: Colors.white,
                                  ),
                                  constraints: BoxConstraints(
                                      minHeight:
                                          Dimensions.getHeight(percentage: 70)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.getScaledSize(15)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height:
                                                Dimensions.getScaledSize(20)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width:
                                                  Dimensions.getScaledSize(200),
                                              height:
                                                  Dimensions.getScaledSize(45),
                                              child: Text(
                                                _statisticPreviewMode ==
                                                        StatisticPreviewMode
                                                            .REVENUE
                                                    ? formatPriceDoubleWithCurrency(
                                                        currentValue)
                                                    : "${formatInteger(currentValue)} ${AppLocalizations.of(context)!.vendorStatisticScreen_piece}",
                                                style: TextStyle(
                                                    color: buttonColor,
                                                    fontSize: Dimensions
                                                        .getScaledSize(24.0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                if (_statisticPreviewMode ==
                                                    StatisticPreviewMode
                                                        .REVENUE) {
                                                  _statisticPreviewMode =
                                                      StatisticPreviewMode
                                                          .AMOUNT;
                                                  currentValue =
                                                      totalBookingAmount
                                                          .toDouble();
                                                } else {
                                                  _statisticPreviewMode =
                                                      StatisticPreviewMode
                                                          .REVENUE;
                                                  currentValue = totalRevenue;
                                                }
                                                setState(() {});
                                              },
                                              child: Text(
                                                _statisticPreviewMode ==
                                                        StatisticPreviewMode
                                                            .REVENUE
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .vendorStatisticScreen_revenue
                                                    : AppLocalizations.of(
                                                            context)
                                                        .vendorStatisticScreen_sales,
                                                style: TextStyle(
                                                    color: CustomTheme
                                                        .primaryColorLight),
                                              ),
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .getScaledSize(
                                                                  7)),
                                                    ),
                                                  ),
                                                  side:
                                                      MaterialStateProperty.all(
                                                    BorderSide(
                                                      color: CustomTheme
                                                          .mediumGrey,
                                                      width: Dimensions
                                                          .getScaledSize(2.0),
                                                    ),
                                                  ),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          Size(
                                                              Dimensions
                                                                  .getScaledSize(
                                                                      110),
                                                              Dimensions
                                                                  .getScaledSize(
                                                                      45)))),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.getScaledSize(30.0)),
                                        Container(
                                          height: Dimensions.getHeight(
                                              percentage: 30),
                                          width: double.infinity,
                                          child: LineChart(
                                            LineChartData(
                                              lineTouchData: LineTouchData(
                                                touchTooltipData:
                                                    LineTouchTooltipData(
                                                        fitInsideHorizontally:
                                                            true,
                                                        fitInsideVertically:
                                                            true,
                                                        getTooltipItems:
                                                            (List<LineBarSpot>
                                                                spots) {
                                                          return spots
                                                              .map(
                                                                (spot) =>
                                                                    LineTooltipItem(
                                                                  getToolTipText(spot
                                                                      .x
                                                                      .toInt()),
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )
                                                              .toList();
                                                        }),
                                                getTouchedSpotIndicator:
                                                    getTouchedSpotIndcator,
                                                getTouchLineEnd:
                                                    (LineChartBarData barData,
                                                        int index) {
                                                  return _statisticPreviewMode ==
                                                          StatisticPreviewMode
                                                              .REVENUE
                                                      ? (1.1 * maxRevenue)
                                                      : (1.1 *
                                                          maxBookingAmount);
                                                },
                                                touchCallback: handleTouch,
                                              ),
                                              lineBarsData: [
                                                getLineChartBarData(
                                                    revenueItems)
                                              ],
                                              gridData: FlGridData(show: false),
                                              borderData:
                                                  FlBorderData(show: false),
                                              axisTitleData:
                                                  FlAxisTitleData(show: false),
                                              titlesData:
                                                  FlTitlesData(show: false),
                                              extraLinesData: ExtraLinesData(
                                                  horizontalLines: [
                                                    getHorizontalLine()
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.getScaledSize(20.0)),
                                        ...(statistic?.activityBookingDataList
                                            ?.map(
                                              (e) => _VendorStatisticActivity(
                                                activity: e,
                                                statisticPreviewMode:
                                                    _statisticPreviewMode,
                                              ),
                                            )
                                            ?.toList())
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom +
                                          Dimensions.getScaledSize(20.0),
                                ),
                              ]);
                        }

                        if (snapshodStatistics.hasError)
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                top: Dimensions.getHeight(percentage: 50.0) -
                                    Scaffold.of(context).appBarMaxHeight),
                            child: Center(
                              child: Text(AppLocalizations.of(context)
                                  .commonWords_error),
                            ),
                          );

                        return getShimmer(context);
                      },
                    ),
                  ],
                ),
              )));
  }

  Widget getPlaceholderVeiw() {
    return Container(
        height: double.infinity,
        color: Colors.white,
        child: ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
          if (!this.network.offline) {
            setState(() {
              getStatistics();
            });
          }
        }));
  }

  getToolTipText(int xIndex) {
    return DateFormat('E dd.MM.yyyy', "de-DE")
        .format(
          _dateFrom.add(
            Duration(days: xIndex),
          ),
        )
        .replaceFirst('.', ',');
  }

  getHorizontalLine() {
    return HorizontalLine(
        y: _statisticPreviewMode == StatisticPreviewMode.REVENUE
            ? totalRevenue / _numberOfDays
            : totalBookingAmount.toDouble() / _numberOfDays,
        color: CustomTheme.mediumGrey,
        dashArray: [
          Dimensions.getScaledSize(7).toInt(),
          Dimensions.getScaledSize(7).toInt(),
        ],
        strokeWidth: Dimensions.getScaledSize(3));
  }

  handleTouch(LineTouchResponse lineTouch) {
    final desiredTouch = lineTouch.touchInput is! PointerExitEvent &&
        lineTouch.touchInput is! PointerUpEvent;

    if (desiredTouch && lineTouch.lineBarSpots != null) {
      final value = lineTouch.lineBarSpots[0].y;
      setState(() {
        currentValue = value;
      });
    } else {
      currentValue = _statisticPreviewMode == StatisticPreviewMode.REVENUE
          ? totalRevenue
          : totalBookingAmount.toDouble();
      setState(() {});
    }
  }

  List<TouchedSpotIndicatorData> getTouchedSpotIndcator(
      LineChartBarData barData, List<int> spotIndexes) {
    return spotIndexes
        .map((index) => TouchedSpotIndicatorData(
              FlLine(color: CustomTheme.mediumGrey),
              FlDotData(show: false),
            ))
        .toList();
  }

  getLineChartBarData(List<DailyRevenueItem> items) {
    return LineChartBarData(
      spots: _statisticPreviewMode == StatisticPreviewMode.AMOUNT
          ? List<FlSpot>.generate(
              items.length,
              (index) => FlSpot(index.toDouble(),
                  items.elementAt(index).bookingAmount.toDouble()))
          : List<FlSpot>.generate(
              items.length,
              (index) =>
                  FlSpot(index.toDouble(), items.elementAt(index).revenue)),
      colors: _statisticPreviewMode == StatisticPreviewMode.REVENUE
          ? [CustomTheme.accentColor2]
          : [CustomTheme.accentColor1],
      isCurved: false,
      dotData: FlDotData(show: false),
    );
  }
}

class _VendorStatisticActivity extends StatelessWidget {
  final ActivityBookingDataItem activity;
  final StatisticPreviewMode statisticPreviewMode;

  _VendorStatisticActivity({
    required this.activity,
    required this.statisticPreviewMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: Dimensions.getScaledSize(1),
          color: CustomTheme.mediumGrey,
        ),
        SizedBox(height: Dimensions.getScaledSize(10.0)),
        Text(
          activity.activityTitle,
          style: TextStyle(
              color: CustomTheme.primaryColorLight,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.getScaledSize(16),
              letterSpacing: CustomTheme.letterSpacing),
        ),
        ...(activity.productDataList
            .map(
              (e) => _VendorStatisticProductRow(
                productDataItem: e,
                statisticPreviewMode: statisticPreviewMode,
              ),
            )
            .toList())
      ],
    );
  }
}

class _VendorStatisticProductRow extends StatelessWidget {
  final ProductDataItem productDataItem;
  final StatisticPreviewMode statisticPreviewMode;
  _VendorStatisticProductRow({
    required this.productDataItem,
    required this.statisticPreviewMode,
  });

  rowTableTextStyle() {
    return TextStyle(
      color: CustomTheme.primaryColorLight,
      fontSize: Dimensions.getScaledSize(14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Dimensions.getScaledSize(10.0)),
      child: statisticPreviewMode == StatisticPreviewMode.REVENUE
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    formatInteger(productDataItem.bookingAmount),
                    style: rowTableTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: Dimensions.getScaledSize(10.0)),
                Expanded(
                  flex: 6,
                  child: Text(
                    productDataItem.productTitle,
                    style: rowTableTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    formatPriceDoubleWithCurrency(productDataItem.revenue),
                    style: rowTableTextStyle(),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    productDataItem.productTitle,
                    style: rowTableTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "${formatInteger(productDataItem.bookingAmount)} ${AppLocalizations.of(context)!.vendorStatisticScreen_piece}",
                    style: rowTableTextStyle(),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}

getShimmer(context) {
  /*var dateButtonWidth =
      (MediaQuery.of(context).size.width - Dimensions.getScaledSize(62)) / 4;*/
  var chartWidth =
      (MediaQuery.of(context).size.width - Dimensions.getScaledSize(36));
  return Container(
    // padding: EdgeInsets.symmetric(horizontal: Dimensions.getScaledSize(18)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: Dimensions.getScaledSize(20.0)),
        // Row(
        //   children: [
        //     ImageUtil.showShimmerPlaceholder(
        //         width: dateButtonWidth, height: Dimensions.getScaledSize(40.0)),
        //     SizedBox(width: Dimensions.getScaledSize(8.0)),
        //     ImageUtil.showShimmerPlaceholder(
        //         width: dateButtonWidth, height: Dimensions.getScaledSize(40.0)),
        //     SizedBox(width: Dimensions.getScaledSize(8.0)),
        //     ImageUtil.showShimmerPlaceholder(
        //         width: dateButtonWidth, height: Dimensions.getScaledSize(40.0)),
        //     SizedBox(width: Dimensions.getScaledSize(8.0)),
        //     ImageUtil.showShimmerPlaceholder(
        //         width: dateButtonWidth, height: Dimensions.getScaledSize(40.0)),
        //   ],
        // ),
        // SizedBox(height: Dimensions.getScaledSize(20.0)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.getScaledSize(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageUtil.showShimmerPlaceholder(
                    width: Dimensions.getScaledSize(200),
                    height: Dimensions.getScaledSize(45.0)),
                ImageUtil.showShimmerPlaceholder(
                    width: Dimensions.getScaledSize(110),
                    height: Dimensions.getScaledSize(45.0)),
              ],
            ),
            SizedBox(height: Dimensions.getScaledSize(30.0)),
            ImageUtil.showShimmerPlaceholder(
                width: chartWidth,
                height: Dimensions.getHeight(percentage: 30)),
            SizedBox(height: Dimensions.getScaledSize(20.0)),
            ImageUtil.showShimmerPlaceholder(
                width: chartWidth,
                height: Dimensions.getHeight(percentage: 10)),
            SizedBox(height: Dimensions.getScaledSize(10.0)),
            ImageUtil.showShimmerPlaceholder(
                width: chartWidth,
                height: Dimensions.getHeight(percentage: 10)),
          ],
        ),
      ],
    ),
  );
}

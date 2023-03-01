import 'package:yucatan/components/BaseState.dart';
import 'package:yucatan/models/vendor_booking_statistic_model.dart';
import 'package:yucatan/services/response/vendor_booking_statistic_single_response_entity.dart';
import 'package:yucatan/services/service_locator.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'line_graph_bloc/line_graph_bloc.dart';

class VendorStatisticGraph extends StatefulWidget {
  @override
  _VendorStatisticGraphState createState() => _VendorStatisticGraphState();
}

class _VendorStatisticGraphState extends BaseState<VendorStatisticGraph> {
  /*DateTime _dateFrom;
  DateTime _dateTo;*/
  List<DailyRevenueItem>? fullItemsList;
  VendorBookingStatisticSingleResponseEntity?
      vendorBookingStatisticSingleResponseEntity;
  //int _numberOfDays = 8;
  //double _maxRevenue = 100;
  //int _maxBookingAmount = 0;
  final lineGraphBloc = getIt.get<LineGraphBloc>();

  /*Future<VendorBookingStatisticSingleResponseEntity> getStatisticsAndFillDates() {
    return StatisticService.getVendorDetailedStatistic(getDateString(_dateFrom), getDateString(_dateTo))
        .then((response) {
      if (response.status == 200) {
        fullItemsList = [];
        _maxRevenue = 0;
        _maxBookingAmount = 0;
        fullItemsList = getItemsForAllDates(response.data.dailyRevenueItems);
        if (_maxRevenue == 0) _maxRevenue = 100;
      }
      return response;
    });
  }*/

  @override
  void initState() {
    super.initState();
    /*_dateTo = getCurrentDate();
    _dateFrom = _dateTo.subtract(Duration(days: 7));*/
    //_numberOfDays = 8;
    lineGraphBloc.eventSink.add(LineGraphAction.FetchGraphData);
  }

  final touchTooltipTextStyle = TextStyle(
    fontSize: Dimensions.getScaledSize(14),
    fontWeight: FontWeight.bold,
    color: CustomTheme.accentColor2,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VendorBookingStatisticSingleResponseEntity>(
      stream: lineGraphBloc.lineGraphStream,
      builder: (BuildContext context,
          AsyncSnapshot<VendorBookingStatisticSingleResponseEntity> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      CustomTheme.theme.primaryColorDark)),
            );
          default:
            if (snapshot.hasError) {
              return const Center(child: Text(''));
            } else {
              this.vendorBookingStatisticSingleResponseEntity = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!
                              .vendor_dashboardScreen_weeklyStatistics,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Dimensions.getScaledSize(16.0),
                              color: CustomTheme.primaryColorLight,
                              fontFamily: CustomTheme.fontFamily,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (touchedSpots) {
                              return touchedSpots
                                  .map((LineBarSpot touchedSpot) {
                                return LineTooltipItem(
                                    '${formatPriceDouble(touchedSpot.y)} €',
                                    touchTooltipTextStyle); //TODO: update endpoint to also return currency and replace the hardocded '€' symbol with it
                              }).toList();
                            }),
                            getTouchedSpotIndicator: (barData, spotIndexes) => [
                              TouchedSpotIndicatorData(
                                FlLine(
                                  strokeWidth: Dimensions.getScaledSize(2),
                                  color: CustomTheme.accentColor2,
                                ),
                                FlDotData(
                                  getDotPainter: (
                                    FlSpot spot,
                                    double xPercentage,
                                    LineChartBarData bar,
                                    int index,
                                  ) =>
                                      FlDotCirclePainter(
                                    radius: Dimensions.getScaledSize(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          lineBarsData: [
                            getLineChartBarData(vendorBookingStatisticSingleResponseEntity
                                !.fullItemsList!)
                          ],
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              bottom: BorderSide(
                                color: Color(0xff4e4965),
                                width: 1,
                              ),
                              left: BorderSide(
                                color: Color(0xff4e4965),
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.transparent,
                              ),
                              top: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          titlesData: FlTitlesData(

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                interval:
                                (vendorBookingStatisticSingleResponseEntity
                                    !.maxRevenue /
                                    5.0)
                                    .round()
                                    .toDouble(),

                                // getTitles: (value) {
                                //   return "${value.round()} €";
                                // },
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //child: showStatisticGraph(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .vendor_dashboardScreen_sales,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(14.0),
                                    color: CustomTheme.primaryColorLight,
                                    fontFamily: CustomTheme.fontFamily,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  formatPriceDoubleWithCurrency(vendorBookingStatisticSingleResponseEntity!.data!.revenue!),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(16.0),
                                      color: CustomTheme.primaryColorLight,
                                      fontFamily: CustomTheme.fontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .vendor_dashboardScreen_count,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(14.0),
                                    color: CustomTheme.primaryColorLight,
                                    fontFamily: CustomTheme.fontFamily,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${vendorBookingStatisticSingleResponseEntity!.data!.numberOfBookings} Stk.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(16.0),
                                      color: CustomTheme.primaryColorLight,
                                      fontFamily: CustomTheme.fontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            }
        }
      },
    );
  }

  getLineChartBarData(List<DailyRevenueItem> items) {
    List<FlSpot> spotsList = [];
    for (int i = 0; i < items.length; i++) {
      DailyRevenueItem dailyRevenueItem = items[i];
      spotsList.add(FlSpot(i.toDouble(), dailyRevenueItem.revenue!));
    }
    return LineChartBarData(
      spots: spotsList,
      color: CustomTheme.accentColor2,
      // [CustomTheme.accentColor2],
      isCurved: false,
      dotData: FlDotData(show: false),
    );
  }

  /*getDateString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  DateTime getCurrentDate() {
    DateTime now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day);
  }*/

  /*List<DailyRevenueItem> getItemsForAllDates(List<DailyRevenueItem> items) {
    List<DailyRevenueItem> fullList = [];
    DateTime dateToAdd = _dateFrom;

    items.forEach((dailyRevenueItem) {
      if (dailyRevenueItem.revenue > _maxRevenue)
        _maxRevenue = dailyRevenueItem.revenue;

      if (dailyRevenueItem.bookingAmount > _maxBookingAmount)
        _maxBookingAmount = dailyRevenueItem.bookingAmount;
      while (!dateToAdd.isAtSameMomentAs(dailyRevenueItem.date) &&
          fullList.length < _numberOfDays) {
        fullList.add(
            DailyRevenueItem(bookingAmount: 0, revenue: 0.0, date: dateToAdd));
        dateToAdd = dateToAdd.add(Duration(days: 1));
      }
      dateToAdd = dailyRevenueItem.date.add(Duration(days: 1));
      fullList.add(dailyRevenueItem);
    });
    while (!dateToAdd.isAtSameMomentAs(_dateTo.add(Duration(days: 1))) &&
        fullList.length < _numberOfDays) {
      fullList.add(
          DailyRevenueItem(bookingAmount: 0, revenue: 0.0, date: dateToAdd));
      dateToAdd = dateToAdd.add(Duration(days: 1));
    }
    return fullList;
  }*/
}

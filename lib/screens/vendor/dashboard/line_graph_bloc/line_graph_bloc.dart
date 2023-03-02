import 'dart:async';
import 'package:yucatan/models/vendor_booking_statistic_model.dart';
import 'package:yucatan/services/response/vendor_booking_statistic_single_response_entity.dart';
import 'package:yucatan/services/statistic_service.dart';
import 'package:rxdart/rxdart.dart';

enum LineGraphAction { FetchGraphData }

class LineGraphBloc {
  //This StreamController is used to update the state of widgets
  StreamController<VendorBookingStatisticSingleResponseEntity>
      _stateStreamController = new BehaviorSubject();
  StreamSink<VendorBookingStatisticSingleResponseEntity> get _lineGraphSink =>
      _stateStreamController.sink;
  Stream<VendorBookingStatisticSingleResponseEntity> get lineGraphStream =>
      _stateStreamController.stream;

  //user input event StreamController
  StreamController<LineGraphAction> _eventStreamController =
      new BehaviorSubject();
  StreamSink<LineGraphAction> get eventSink => _eventStreamController.sink;
  Stream<LineGraphAction> get _eventStream => _eventStreamController.stream;

  DateTime? _dateFrom;
  DateTime? _dateTo;
  int _numberOfDays = 8;
  double _maxRevenue = 100;
  int _maxBookingAmount = 0;
  List<DailyRevenueItem>? fullItemsList;

  LineGraphBloc() {
    _eventStream.listen((event) async {
      if (event == LineGraphAction.FetchGraphData) {
        _dateTo = getCurrentDate();
        _dateFrom = _dateTo!.subtract(Duration(days: 7));
        VendorBookingStatisticSingleResponseEntity? response =
            await StatisticService.getVendorDetailedStatistic(
                getDateString(_dateFrom!), getDateString(_dateTo!));
        if (response!.status == 200) {
          fullItemsList = [];
          _maxRevenue = 0;
          _maxBookingAmount = 0;
          fullItemsList =
              getItemsForAllDates(response.data!.dailyRevenueItems!);
          if (_maxRevenue == 0) _maxRevenue = 100;
          fullItemsList =
              getItemsForAllDates(response.data!.dailyRevenueItems!);
          response.fullItemsList = fullItemsList;
          response.maxRevenue = _maxRevenue;
        }
        _lineGraphSink.add(response);
      }
    });
  }

  getDateString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  DateTime getCurrentDate() {
    DateTime now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day);
  }

  List<DailyRevenueItem> getItemsForAllDates(List<DailyRevenueItem> items) {
    List<DailyRevenueItem> fullList = [];
    DateTime dateToAdd = _dateFrom!;

    items.forEach((dailyRevenueItem) {
      if (dailyRevenueItem.revenue! > _maxRevenue)
        _maxRevenue = dailyRevenueItem.revenue!;

      if (dailyRevenueItem.bookingAmount! > _maxBookingAmount)
        _maxBookingAmount = dailyRevenueItem.bookingAmount!;
      while (!dateToAdd.isAtSameMomentAs(dailyRevenueItem.date!) &&
          fullList.length < _numberOfDays) {
        fullList.add(
            DailyRevenueItem(bookingAmount: 0, revenue: 0.0, date: dateToAdd));
        dateToAdd = dateToAdd.add(Duration(days: 1));
      }
      dateToAdd = dailyRevenueItem.date!.add(Duration(days: 1));
      fullList.add(dailyRevenueItem);
    });
    while (!dateToAdd.isAtSameMomentAs(_dateTo!.add(Duration(days: 1))) &&
        fullList.length < _numberOfDays) {
      fullList.add(
          DailyRevenueItem(bookingAmount: 0, revenue: 0.0, date: dateToAdd));
      dateToAdd = dateToAdd.add(Duration(days: 1));
    }
    return fullList;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

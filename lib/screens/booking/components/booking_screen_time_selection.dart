import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/booking/components/booking_screen_time_slot_item.dart';
import 'package:yucatan/screens/booking/components/booking_screen_time_slot_item_model.dart';
import 'package:yucatan/screens/booking/components/customCalendar.dart';
import 'package:yucatan/screens/booking/util/booking_time_quota_util.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingScreenTimeSelection extends StatefulWidget {
  final Product product;
  final Function(BookingScreenTimeSlotItemModel bookingScreenTimeSlotItemModel)
      onTimeSlotSelected;
  final ProductCategory category;
  final ProductSubCategory subCategory;
  final DateTime specificDate;
  final Function(
          List<BookingScreenTimeSlotItemModel> bookingScreenTimeSlotItemModels)
      onAvailableTimeSlotsChanged;

  BookingScreenTimeSelection({
    required this.product,
    required this.onTimeSlotSelected,
    required this.category,
    required this.subCategory,
    this.specificDate,
    required this.onAvailableTimeSlotsChanged,
  });

  @override
  _BookingScreenTimeSelectionState createState() =>
      _BookingScreenTimeSelectionState();
}

class _BookingScreenTimeSelectionState
    extends State<BookingScreenTimeSelection> {
  DateTime _selectedDate;
  List<DateTime> _closedDates = [];
  List<DateTime> _notAvailableDates = [];
  List<BookingScreenTimeSlotItemModel> _allTimeSlots = [];
  List<BookingScreenTimeSlotItemModel> _timeSlotsForDate = [];

  var maxDate = DateTime(
    DateTime.now().year + 2,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    //Notify booking screen view
    widget.onAvailableTimeSlotsChanged([]);

    _selectedDate = widget.specificDate;
    _initTimeSelection();

    //If there is no specific date yet, automatically select the next available date
    if (widget.specificDate == null) {
      var currentDate = DateTime.now();

      _closedDates
          .takeWhile((element) => GlobalDate.isSameDay(element, currentDate))
          .forEach((element) {
        currentDate = currentDate.add(
          Duration(
            days: 1,
          ),
        );
      });

      if (currentDate.isAfter(maxDate) == false) _selectedDate = currentDate;
    }

    if (_selectedDate != null) {
      _onDateSelected(_selectedDate, false);
    }
    super.initState();
  }

  @override
  void dispose() {
    //Notify booking screen view
    widget.onAvailableTimeSlotsChanged([]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.bottom -
            AppBar().preferredSize.height -
            Dimensions.getScaledSize(65),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getScaledSize(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.getScaledSize(2),
            ),
            CustomCalendarView(
              initialDate: _selectedDate,
              minimumDate: DateTime.now(),
              maximumDate: maxDate,
              startEndDateChange: (DateTime dateData) {
                _onDateSelected(dateData, true);
              },
              closedDates: _closedDates,
              notAvailableDates: _notAvailableDates,
              usedForVendor: false,
            ),
            SizedBox(
              height: Dimensions.getScaledSize(20),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(14),
                right: Dimensions.getScaledSize(14),
              ),
              child: Text(
                _selectedDate == null
                    ? AppLocalizations.of(context)!.bookingScreen_chooseDate
                    : widget.product.timeSlots != null &&
                            widget.product.timeSlots.hasTimeSlots
                        ? _timeSlotsForDate.length > 0 &&
                                _timeSlotsForDate[0].timeString == null
                            ? DateFormat('EEEE, dd. LLLL yyyy', 'de-DE')
                                .format(_selectedDate)
                            : AppLocalizations.of(context)
                                .bookingScreen_chooseTime
                        : DateFormat('EEEE, dd. LLLL yyyy', 'de-DE')
                            .format(_selectedDate),
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(14),
                  color: CustomTheme.primaryColorDark,
                ),
              ),
            ),
            widget.product.timeSlots != null &&
                    widget.product.timeSlots.hasTimeSlots &&
                    _timeSlotsForDate.length > 0
                ? Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: Dimensions.getScaledSize(5),
                        left: Dimensions.getScaledSize(14),
                        right: Dimensions.getScaledSize(14),
                        bottom: MediaQuery.of(context).padding.bottom +
                            Dimensions.getScaledSize(15),
                      ),
                      itemCount: _timeSlotsForDate.length,
                      itemBuilder: (context, index) {
                        if (_hideTimeSelection(index)) {
                          return Container();
                        }

                        return BookingScreenTimeSlotItem(
                          timeSlotItemModel: _timeSlotsForDate[index],
                          hasTime: _timeSlotsForDate[index].timeString == null
                              ? false
                              : true,
                          onSelected: (
                            BookingScreenTimeSlotItemModel timeSlotItemModel,
                          ) {
                            _onTimeSlotSelected(timeSlotItemModel);
                          },
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.getScaledSize(5),
                      horizontal: Dimensions.getScaledSize(14),
                    ),
                    child: _selectedDate != null
                        ? BookingScreenTimeSlotItem(
                            timeSlotItemModel: BookingScreenTimeSlotItemModel(
                              dateTime: _selectedDate,
                              timeString: null,
                              remainingQuota:
                                  BookingTimeQuotaUtil.getDailyAvailableQuota(
                                widget.product,
                                _selectedDate,
                                null,
                                widget.category,
                                widget.subCategory,
                              ),
                            ),
                            hasTime: false,
                            onSelected: (
                              BookingScreenTimeSlotItemModel timeSlotItemModel,
                            ) {
                              _onTimeSlotSelected(timeSlotItemModel);
                            },
                          )
                        : Container(),
                  ),
          ],
        ),
      ),
    );
  }

  ///Inititalize time selection screen
  void _initTimeSelection() {
    if (widget.product.timeSlots != null &&
        widget.product.timeSlots.hasTimeSlots)
      return _initTimeSelectionWithTimeSlots();

    if (widget.specificDate != null) _fillClosedDates();
  }

  //Init time selection from time slots
  void _initTimeSelectionWithTimeSlots() {
    _fillClosedDates();

    //Loop through specific time slots
    widget.product.timeSlots.special?.forEach(
      (specificTimeSlotElement) {
        //Update fields
        _updateDateAndTimeSlotArrays(
          specificTimeSlotElement.date,
          specificTimeSlotElement.hours,
        );
      },
    );

    //Loop through regular time slots
    widget.product.timeSlots.regular?.forEach(
      (regularTimeSlotElement) {
        //Process regular time slots
        _processRegularTimeSlot(regularTimeSlotElement);
      },
    );

    //Adjust closed dates
    _adjustClosedDates();
  }

  ///Fill _closedDates with data
  void _fillClosedDates() {
    //Fill _closedDates with every day over the next 2 years
    _closedDates = List<DateTime>.generate(732, (index) {
      var nextDate = DateTime.now().add(
        Duration(days: index),
      );

      if (widget.specificDate != null) {
        if (GlobalDate.isSameDay(nextDate, widget.specificDate)) return null;
      }

      //If date is after now + 2 years, set to null
      if (nextDate.isAfter(
        maxDate.add(
          Duration(
            days: 1,
          ),
        ),
      ))
        return null;
      else
        return nextDate;
    }).toList();

    //Remove any nulls from _closedDates. If no leap year, there can be nulls
    _closedDates.removeWhere((element) => element == null);
  }

  ///Remove date from _closedDates
  void _removeFromClosedDates(DateTime dateTime) {
    //Remove date from _closedDates
    _closedDates.removeWhere(
      (closedDateElement) => GlobalDate.isSameDay(
        closedDateElement,
        dateTime,
      ),
    );
  }

  ///Add date to _notAvailableDates if quota is used up
  void _addNotAvailableTimeSlotIfQuotaUsedUp(DateTime dateTime,
      List<ProductTimeSlotsDayHour> productTimeSlotsDayHours) {
    var remainingDailyQuota = BookingTimeQuotaUtil.getDailyAvailableQuota(
        widget.product, dateTime, null, widget.category, widget.subCategory);

    if (remainingDailyQuota != null) {
      if (remainingDailyQuota == 0) {
        _notAvailableDates.add(dateTime);
      }
      return;
    }

    if (productTimeSlotsDayHours.length == 0) {
      var maxQuota = BookingTimeQuotaUtil.getMaxQuota(
        widget.product,
        dateTime,
        null,
        widget.category,
        widget.subCategory,
      );

      if (maxQuota != null && maxQuota < 0) return;

      var remainingQuota = BookingTimeQuotaUtil.getRemainingQuota(
          widget.product, maxQuota, dateTime, null);

      if (remainingQuota == 0) {
        _notAvailableDates.add(dateTime);
      }

      return;
    }

    //Check if quota is used up
    bool isQuotaUsedUp =
        productTimeSlotsDayHours.every((productTimeSlotsDayHoursElement) {
      if (productTimeSlotsDayHoursElement.quota != null &&
          productTimeSlotsDayHoursElement.quota < 0) return false;

      var maxQuota = BookingTimeQuotaUtil.getMaxQuota(
        widget.product,
        dateTime,
        productTimeSlotsDayHoursElement.time,
        widget.category,
        widget.subCategory,
      );

      return BookingTimeQuotaUtil.getRemainingQuota(widget.product, maxQuota,
                  dateTime, productTimeSlotsDayHoursElement.time) ==
              0
          ? true
          : false;
    });

    //Add to _notAvailableDates
    if (isQuotaUsedUp) {
      _notAvailableDates.add(dateTime);
    }
  }

  ///Add element to _allTimeSlots from date and hours
  void _addTimeSlot(DateTime dateTime,
      List<ProductTimeSlotsDayHour> productTimeSlotsDayHours) {
    var remainingQuota = BookingTimeQuotaUtil.getDailyAvailableQuota(
      widget.product,
      dateTime,
      null,
      widget.category,
      widget.subCategory,
    );

    if (productTimeSlotsDayHours == null ||
        productTimeSlotsDayHours.length == 0) {
      if (remainingQuota == null) {
        remainingQuota = BookingTimeQuotaUtil.getRemainingQuota(
          widget.product,
          BookingTimeQuotaUtil.getMaxQuota(
            widget.product,
            dateTime,
            null,
            widget.category,
            widget.subCategory,
          ),
          dateTime,
          null,
        );

        //Generate local timeSlot
        var timeSlot = BookingScreenTimeSlotItemModel(
          dateTime: dateTime,
          timeString: null,
          remainingQuota: remainingQuota,
        );

        //Add to _allTimeSlots
        _allTimeSlots.add(timeSlot);

        return;
      }
    }

    //Loop trough hours. Generate 1 element in _allTimeSlots for each hour
    productTimeSlotsDayHours.forEach((
      productTimeSlotsDayHoursElement,
    ) {
      var remainingQuotaForTime;

      if (remainingQuota == null)
        remainingQuotaForTime = BookingTimeQuotaUtil.getRemainingQuota(
          widget.product,
          BookingTimeQuotaUtil.getMaxQuota(
            widget.product,
            dateTime,
            productTimeSlotsDayHoursElement.time,
            widget.category,
            widget.subCategory,
          ),
          dateTime,
          productTimeSlotsDayHoursElement.time,
        );

      //Generate local timeSlot
      var timeSlot = BookingScreenTimeSlotItemModel(
        dateTime: dateTime,
        timeString: productTimeSlotsDayHoursElement.time,
        remainingQuota:
            remainingQuota == null ? remainingQuotaForTime : remainingQuota,
      );

      //Add to _allTimeSlots
      _allTimeSlots.add(timeSlot);
    });
  }

  ///Update _closedDates, _notAvailableDates and _allTimeSlots
  void _updateDateAndTimeSlotArrays(DateTime dateTime,
      List<ProductTimeSlotsDayHour> productTimeSlotsDayHours) {
    //If date is already selected, skip for dates that are not the same
    if (widget.specificDate != null &&
        GlobalDate.isSameDay(widget.specificDate, dateTime) == false) return;

    //Remove from _closedDates
    _removeFromClosedDates(dateTime);

    //Add to _notAvailableDates if quota is used up
    _addNotAvailableTimeSlotIfQuotaUsedUp(
      dateTime,
      productTimeSlotsDayHours,
    );

    //Add to _allTimeSlots
    _addTimeSlot(
      dateTime,
      productTimeSlotsDayHours,
    );
  }

  ///Process regular time slot
  void _processRegularTimeSlot(
      ProductTimeSlotsRegular productTimeSlotsRegular) {
    //Check if intervalType is week

    if (productTimeSlotsRegular.intervalType ==
        ProductTImeSlotsRegularIntervalType.WEEK) {
      //Get weeks for time slot duration
      var weeks = BookingTimeQuotaUtil.getWeeksForRegularTimeSlot(
          productTimeSlotsRegular);

      //Loop trough regular time slot depending on intervalRepeat (if intervalRepeat == 2, skip every other entry)
      for (var i = 0;
          i < weeks.length;
          i += productTimeSlotsRegular.intervalRepeat) {
        var weekDays = weeks[i];

        //Loop through days of regular time slot
        productTimeSlotsRegular.days.forEach(
          (productTimeSlotsRegularDay) {
            //Get date by weekday
            var date = weekDays.firstWhere(
              (weekDaysElement) =>
                  weekDaysElement.weekday == productTimeSlotsRegularDay.day,
              orElse: () => null,
            );

            //Check if date can be skipped
            if (_canDateBeSkipped(date, productTimeSlotsRegular)) return;

            //Update fields
            _updateDateAndTimeSlotArrays(
              date,
              productTimeSlotsRegularDay.hours,
            );
          },
        );
      }
    } else if (productTimeSlotsRegular.intervalType ==
        ProductTImeSlotsRegularIntervalType.MONTH) {
      //Get months for time slot duration
      var months = BookingTimeQuotaUtil.getMonthsForRegularTimeSlot(
          productTimeSlotsRegular);

      //Loop trough regular time slot depending on intervalRepeat (if intervalRepeat == 2, skip every other entry)
      for (var i = 0;
          i < months.length;
          i += productTimeSlotsRegular.intervalRepeat) {
        var daysInMonth = months[i];

        //Loop through days of regular time slot
        productTimeSlotsRegular.days.forEach(
          (productTimeSlotsRegularDay) {
            //Get week in month for which to apply time slot
            //0 = first week of month
            var weekInMonth =
                ((productTimeSlotsRegularDay.day - 1) / 7).floor();

            //Get weekday for week in month
            //E.g. productTimeSlotsRegularDay.day == 1 = first monday of month, productTimeSlotsRegularDay.day == 8 = second monday of month
            //Both return 1 as weekday
            var weekdayInWeekInMonth =
                productTimeSlotsRegularDay.day - (weekInMonth * 7);

            //Get date by weekday
            var date = daysInMonth.firstWhere(
              (daysInMonthElement) {
                //Get local week in month
                var localWeekInMonth =
                    ((daysInMonthElement.day - 1) / 7).floor();

                //Check if week in month matches
                var isSameWeekInMonth = localWeekInMonth == weekInMonth;

                return daysInMonthElement.weekday == weekdayInWeekInMonth &&
                    isSameWeekInMonth;
              },
              orElse: () => null,
            );

            //Check if date can be skipped
            if (_canDateBeSkipped(date, productTimeSlotsRegular)) return;

            //Update fields
            _updateDateAndTimeSlotArrays(
              date,
              productTimeSlotsRegularDay.hours,
            );
          },
        );
      }
    }
  }

  ///Returns bool wether date can be skipped
  ///Date can be skipped if it is null, is out of range, or has already been added
  bool _canDateBeSkipped(
    DateTime dateTime,
    ProductTimeSlotsRegular productTimeSlotsRegular,
  ) {
    //Skip if date is null
    if (dateTime == null) return true;

    //Skip if date is out of range
    if (dateTime.isBefore(productTimeSlotsRegular.startDate) ||
        (dateTime.isAfter(productTimeSlotsRegular.endDate) &&
            GlobalDate.isSameDay(dateTime, productTimeSlotsRegular.endDate) ==
                false)) return true;

    //Skip if date already exists in _allTimeSlots
    if (_allTimeSlots.any((allTimeSlotsElement) =>
        GlobalDate.isSameDay(allTimeSlotsElement.dateTime, dateTime)))
      return true;

    return false;
  }

  ///Handle date picked in calendar
  void _onDateSelected(DateTime dateTime, bool updateState) {
    //Filter time slots for date
    var timeSlotsForDate = _allTimeSlots.where(
      (allTimeSlotsElement) => GlobalDate.isSameDay(
        allTimeSlotsElement.dateTime,
        dateTime,
      ),
    );

//Update state
    if (updateState) {
      setState(() {
        _selectedDate = dateTime;
        _timeSlotsForDate = timeSlotsForDate.toList();
      });
    } else {
      _selectedDate = dateTime;
      _timeSlotsForDate = timeSlotsForDate.toList();
    }

    var availableTimeSlots = widget.product.timeSlots != null &&
            widget.product.timeSlots.hasTimeSlots &&
            _timeSlotsForDate.length > 0
        ? _timeSlotsForDate
        : [
            BookingScreenTimeSlotItemModel(
              dateTime: _selectedDate,
              timeString: null,
              remainingQuota: BookingTimeQuotaUtil.getDailyAvailableQuota(
                widget.product,
                _selectedDate,
                null,
                widget.category,
                widget.subCategory,
              ),
            ),
          ];

    //Notify booking screen view
    widget.onAvailableTimeSlotsChanged(availableTimeSlots);
  }

  ///Handle time slot selected
  void _onTimeSlotSelected(BookingScreenTimeSlotItemModel timeSlotItemModel) {
    if (timeSlotItemModel.remainingQuota > 0) {
      widget.onTimeSlotSelected(timeSlotItemModel);
    }
  }

  bool _hideTimeSelection(int index) {
    DateTime date = _timeSlotsForDate[index].dateTime;
    String time = _timeSlotsForDate[index].timeString;

    if (time != null) {
      DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
      var datetime = DateTime.parse('${dateFormat.format(date)} $time');

      if (widget.product.requestRequired &&
          datetime.difference(DateTime.now()).compareTo(Duration(hours: 2)) <
              0) {
        return true;
      }

      if (!widget.product.requestRequired &&
          !datetime.isAfter(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  bool _hideTimeSelectionAllTimeSlots(int index) {
    DateTime date = _allTimeSlots[index].dateTime;
    String time = _allTimeSlots[index].timeString;

    if (time != null) {
      DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
      var datetime = DateTime.parse('${dateFormat.format(date)} $time');

      if (widget.product.requestRequired &&
          datetime.difference(DateTime.now()).compareTo(Duration(hours: 2)) <
              0) {
        return true;
      }

      if (!widget.product.requestRequired &&
          !datetime.isAfter(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  ///Adjust closed dates. If all timeslots for a date are in the past then add that date to closed dates
  void _adjustClosedDates() {
    _allTimeSlots.forEach((allTimeSlotsElement) {
      var timeSlotsForDate = _allTimeSlots.where((localAllTimeSlotsElement) =>
          localAllTimeSlotsElement.dateTime == allTimeSlotsElement.dateTime);

      var timeSlotsForDateIndices = timeSlotsForDate.map(
          (timeSlotsForDateElement) =>
              _allTimeSlots.indexOf(timeSlotsForDateElement));

      bool shouldDateBeClosed = timeSlotsForDateIndices.every(
          (timeSlotsForDateIndicesElement) =>
              _hideTimeSelectionAllTimeSlots(timeSlotsForDateIndicesElement));

      if (shouldDateBeClosed == false) return;

      if (_closedDates.contains(allTimeSlotsElement.dateTime)) return;

      _closedDates.add(allTimeSlotsElement.dateTime);
    });

    _closedDates.removeWhere(
      (closedDatesElement) =>
          DateTime.now().isAfter(closedDatesElement) &&
          !GlobalDate.isSameDay(
            closedDatesElement,
            DateTime.now(),
          ),
    );

    _closedDates.sort((a, b) => a.compareTo(b));
  }
}

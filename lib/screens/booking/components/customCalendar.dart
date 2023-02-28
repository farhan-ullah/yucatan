import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CustomCalendarView extends StatefulWidget {
  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime initialDate;
  final Function(DateTime) startEndDateChange;
  final List<DateTime> closedDates;
  final bool usedForVendor;
  final List<DateTime>
      notAvailableDates; //Not available dates are dates for a product where the quota limit has been reached

  const CustomCalendarView({
    Key? key,
    this.initialDate,
    this.startEndDateChange,
    this.minimumDate,
    this.maximumDate,
    this.closedDates = const [],
    this.usedForVendor = false,
    this.notAvailableDates = const [],
  }) : super(key: key);

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  List<DateTime> dateList = <DateTime>[];
  var currentMonthDate = DateTime.now();
  DateTime selectedDate;

  Color textColorSameMonth;
  Color textColorOtherMonth;
  Color textColorSelected;
  Color textColorNotAvailable;
  Color borderColorSelectable;
  Color borderColorSelected;
  Color borderColorNotSelectable;
  Color borderColorNotAvailable;
  Color backgroundColorNotSelected;
  Color backgroundColorSelected;
  Color backgroundColorNotAvailable;

  @override
  void initState() {
    if (widget.initialDate != null) {
      currentMonthDate = widget.initialDate;
      selectedDate = widget.initialDate;
    }

    setListOfDate(currentMonthDate);

    initializeDateFormatting('de', null);

    //TODO: adjust colors for vendor, user colors are fine
    if (widget.usedForVendor) {
      textColorSameMonth = CustomTheme.primaryColorDark;
      textColorOtherMonth = CustomTheme.hintText;
      textColorSelected = Colors.white;
      textColorNotAvailable = CustomTheme.accentColor1;
      borderColorSelectable = CustomTheme.primaryColorDark;
      borderColorSelected = Colors.transparent;
      borderColorNotAvailable = CustomTheme.accentColor1;
      borderColorNotSelectable = Colors.transparent;
      backgroundColorNotSelected = Colors.transparent;
      backgroundColorSelected = CustomTheme.primaryColor;
      backgroundColorNotAvailable = CustomTheme.accentColor1;
    } else {
      textColorSameMonth = CustomTheme.primaryColorDark;
      textColorOtherMonth = CustomTheme.hintText;
      textColorSelected = Colors.white;
      textColorNotAvailable = CustomTheme.accentColor1;
      borderColorSelectable = CustomTheme.primaryColorDark;
      borderColorSelected = Colors.transparent;
      borderColorNotAvailable = CustomTheme.accentColor1;
      borderColorNotSelectable = Colors.transparent;
      backgroundColorNotSelected = Colors.transparent;
      backgroundColorSelected = CustomTheme.primaryColor;
      backgroundColorNotAvailable = CustomTheme.accentColor1;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    var newDate = DateTime(monthDate.year, monthDate.month, 0);
    int privusMothDay = 0;
    if (newDate.weekday < 7) {
      privusMothDay = newDate.weekday;
      for (var i = 1; i <= privusMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: privusMothDay - i)));
      }
    }
    for (var i = 0; i < (42 - privusMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
    // if (dateList[dateList.length - 7].month != monthDate.month) {
    //   dateList.removeRange(dateList.length - 7, dateList.length);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  Dimensions.getScaledSize(8.0),
                ),
                child: Container(
                  height: Dimensions.getScaledSize(38.0),
                  width: Dimensions.getScaledSize(38.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentMonthDate = DateTime(
                            currentMonthDate.year, currentMonthDate.month, 0);
                        setListOfDate(currentMonthDate);
                      });
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: Dimensions.getScaledSize(28),
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.getScaledSize(3),
                    ),
                    child: Text(
                      DateFormat("MMMM, yyyy", 'de-DE')
                          .format(currentMonthDate)
                          .replaceFirst(',', ''),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.getScaledSize(16),
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Dimensions.getScaledSize(38.0),
                  width: Dimensions.getScaledSize(38.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentMonthDate = DateTime(currentMonthDate.year,
                            currentMonthDate.month + 2, 0);
                        setListOfDate(currentMonthDate);
                      });
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: Dimensions.getScaledSize(28),
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.getScaledSize(8.0),
              right: Dimensions.getScaledSize(8.0),
              left: Dimensions.getScaledSize(8.0),
              bottom: Dimensions.getScaledSize(8.0),
            ),
            child: Row(
              children: getDaysNameUI(),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity > 3) {
                setState(() {
                  currentMonthDate = DateTime(
                      currentMonthDate.year, currentMonthDate.month, 0);
                  setListOfDate(currentMonthDate);
                });
              }
              if (details.primaryVelocity < -3) {
                setState(() {
                  currentMonthDate = DateTime(
                      currentMonthDate.year, currentMonthDate.month + 2, 0);
                  setListOfDate(currentMonthDate);
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimensions.getScaledSize(8.0),
                right: Dimensions.getScaledSize(8.0),
                left: Dimensions.getScaledSize(8.0),
              ),
              child: Column(
                children: getDaysNoUI(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDaysNameUI() {
    List<Widget> listUI = <Widget>[];
    for (var i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat("EEE", "de-DE")
                  .format(dateList[i])
                  .replaceFirst('.', ''),
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(14.0),
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    List<Widget> noList = <Widget>[];
    var cout = 0;
    for (var i = 0; i < dateList.length / 7; i++) {
      List<Widget> listUI = <Widget>[];
      for (var i = 0; i < 7; i++) {
        final date = dateList[cout];
        listUI.add(
          Container(
            height: Dimensions.getScaledSize(39),
            width: Dimensions.getScaledSize(45),
            child: GestureDetector(
              onTap: () {
                if (getIsSelectableDate(date)) {
                  if (currentMonthDate.month == date.month) {
                    if (widget.minimumDate != null &&
                        widget.maximumDate != null) {
                      var newminimumDate = DateTime(widget.minimumDate.year,
                          widget.minimumDate.month, widget.minimumDate.day - 1);
                      var newmaximumDate = DateTime(widget.maximumDate.year,
                          widget.maximumDate.month, widget.maximumDate.day + 1);
                      if (date.isAfter(newminimumDate) &&
                          date.isBefore(newmaximumDate)) {
                        onDateClick(date);
                      }
                    } else if (widget.minimumDate != null) {
                      var newminimumDate = DateTime(widget.minimumDate.year,
                          widget.minimumDate.month, widget.minimumDate.day - 1);
                      if (date.isAfter(newminimumDate)) {
                        onDateClick(date);
                      }
                    } else if (widget.maximumDate != null) {
                      var newmaximumDate = DateTime(widget.maximumDate.year,
                          widget.maximumDate.month, widget.maximumDate.day + 1);
                      if (date.isBefore(newmaximumDate)) {
                        onDateClick(date);
                      }
                    } else {
                      onDateClick(date);
                    }
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.getScaledSize(5),
                  bottom: Dimensions.getScaledSize(5),
                  left: Dimensions.getScaledSize(7),
                  right: Dimensions.getScaledSize(7),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(date),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Dimensions.getScaledSize(5.0),
                      ),
                    ),
                    border: Border.all(
                      color: _getBorderColor(date),
                    ),
                    boxShadow: getIsSelectedDate(date)
                        ? <BoxShadow>[
                            BoxShadow(
                              color: CustomTheme.grey,
                              blurRadius: Dimensions.getScaledSize(4.0),
                              offset: Offset(0, 0),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        color: _getTextColor(date),
                        fontSize: Dimensions.getScaledSize(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (i < 6) {
          listUI.add(
            Expanded(
              child: Container(),
            ),
          );
        }
        cout += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Color _getTextColor(DateTime date) {
    return getIsSelectedDate(date)
        ? Colors.white
        : currentMonthDate.month == date.month
            ? getIsSelectableDate(date)
                ? isNotAvailableDate(date)
                    ? textColorNotAvailable
                    : CustomTheme.primaryColorDark
                : CustomTheme.primaryColorDark
            : CustomTheme.hintText;
  }

  Color _getBorderColor(DateTime date) {
    return getIsSelectedDate(date)
        ? borderColorSelected
        : currentMonthDate.month == date.month
            ? getIsSelectableDate(date)
                ? isNotAvailableDate(date)
                    ? borderColorNotAvailable
                    : borderColorSelectable
                : borderColorNotSelectable
            : borderColorNotSelectable;
  }

  Color _getBackgroundColor(DateTime date) {
    return getIsSelectedDate(date)
        ? isNotAvailableDate(date)
            ? backgroundColorNotAvailable
            : backgroundColorSelected
        : backgroundColorNotSelected;
  }

  bool getIsSelectedDate(DateTime date) {
    if (selectedDate != null &&
        selectedDate.day == date.day &&
        selectedDate.month == date.month &&
        selectedDate.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (selectedDate != null &&
        selectedDate.day == date.day &&
        selectedDate.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isBeforeToday(DateTime date) {
    var today = DateTime.now();

    if (date.compareTo(today) < 0 &&
        (date.year == today.year &&
                date.month == today.month &&
                date.day == today.day) ==
            false) {
      return true;
    }

    return false;
  }

  bool getIsSelectableDate(DateTime date) {
    return currentMonthDate.month == date.month &&
            isBeforeToday(date) == false &&
            isClosedDate(date) == false &&
            (widget.maximumDate == null ||
                GlobalDate.isSameDay(widget.maximumDate, date) ||
                date.isBefore(widget.maximumDate)) ||
        //vendor side
        widget.usedForVendor &&
            widget.minimumDate != null &&
            date.isAfter(widget.minimumDate);
  }

  void onDateClick(DateTime date) {
    selectedDate = date;
    setState(() {
      try {
        widget.startEndDateChange(selectedDate);
      } catch (e) {}
    });
  }

  bool isClosedDate(DateTime date) {
    return widget.closedDates.any((element) =>
        element.year == date.year &&
        element.month == date.month &&
        element.day == date.day);
  }

  bool isNotAvailableDate(DateTime date) {
    return widget.notAvailableDates.any((element) =>
        element.year == date.year &&
        element.month == date.month &&
        element.day == date.day);
  }
}

import 'package:yucatan/utils/datefulWidget/GlobalDateEvent.dart';

class GlobalDate {
  static DateTime? _x;

  /// returns the current set date
  static DateTime current() => _x!;

  /// sets the DateTime to a custom value
  static DateTime set(DateTime dateTime) {
    GlobalDateEvent.invokeListener(dateTime);
    return (_x = dateTime);
  }

  /// sets the DateTime to today's value
  static DateTime setToday() => set(DateTime.now());

  /// sets the DateTime to tomorrow's value
  static DateTime setTomorrow() => set(DateTime.now().add(Duration(days: 1)));

  /// adds [Duration] to the current set DateTime
  static DateTime add(Duration duration) => set(_x!.add(duration));

  /// subtracts [Duration] from the current set DateTime
  static DateTime subtract(Duration duration) => set(_x!.subtract(duration));

  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (aDate == today) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTomorrow(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (aDate == tomorrow) {
      return true;
    } else {
      return false;
    }
  }

  static bool isWeek(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekdate = DateTime(today.year, today.month, today.day + 7);

    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (weekdate == aDate) {
      return true;
    } else {
      return false;
    }
  }

  static bool isYesterday(DateTime dateTime) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (aDate == yesterday) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  ///Returns a list of dates which represents a week for a given date
  ///E.g. If given date is a thursday, the list starts with the last monday and goes on till the upcoming sunday
  static List<DateTime> getWeekFromDate(DateTime dateTime) {
    List<DateTime> days = [];

    //Get first day of week
    var firstDayOfWeek = dateTime.subtract(
      Duration(days: dateTime.weekday - 1),
    );

    //Generate days in week
    for (var i = 0; i < 7; i++) {
      days.add(
        firstDayOfWeek.add(
          Duration(days: i),
        ),
      );
    }

    return days;
  }

  ///Returns a list of dates which represents a month for a given date
  ///E.g. If given date is the 14th day of a month, the list starts with the first day and goes on till the last day of the month
  static List<DateTime> getMonthFromDate(DateTime dateTime) {
    List<DateTime> days = [];

    //Get first day of month
    var firstDayOfMonth = DateTime(dateTime.year, dateTime.month, 1);

    //Get last day of month
    //0 for day equals the last day of previous month
    var lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

    //Generate days in month
    for (var i = 0; i < lastDayOfMonth.day; i++) {
      days.add(
        firstDayOfMonth.add(
          Duration(days: i),
        ),
      );
    }

    return days;
  }

  ///Return new instance of DateTime with time set to 00:00 for a given date
  static DateTime getDateWithoutTime(DateTime dateTime) {
    var dateWithoutTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    return dateWithoutTime;
  }
}

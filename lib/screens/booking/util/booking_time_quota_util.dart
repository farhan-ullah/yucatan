import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';

///Class for time and quota logic throughout the booking funnel
class BookingTimeQuotaUtil {
  //Returns a BookingScreenTimeSlotModel for a given product, date, time, category and/or sub category
  static int? getDailyAvailableQuota(
    Product product,
    DateTime date,
    String timeString,
    ProductCategory category,
    ProductSubCategory subCategory,
  ) {
    if (category == null) throw Exception("Category can not be null");

    if (category.quota != null) {
      if (category.quota! < 0) return 2147483647;

      return getRemainingQuota(product, category.quota!, date, timeString);
    }

    if (subCategory != null && subCategory.quota != null) {
      if (subCategory.quota! < 0) return 2147483647;

      return getRemainingQuota(product, subCategory.quota!, date, timeString);
    }

    if (product.timeSlots == null) return 2147483647;

    if (product.timeSlots!.dailyQuota! != null) {
      if (product.timeSlots!.dailyQuota! < 0) return 2147483647;

      return getRemainingQuota(
          product, product.timeSlots!.dailyQuota!, date, timeString);
    }

    if (product.timeSlots!.hasTimeSlots == false) {
      return getRemainingQuota(
          product, product.timeSlots!.dailyQuota!, date, timeString);
    }

    return null;
  }

  ///Returns the remaining quota from the quotaAvailability field or maxQuota if no element matches the date
  static int getRemainingQuota(
      Product product, int maxQuota, DateTime date, String timeString) {
    var hour = 0;
    var minute = 0;

    if (timeString != null) {
      var splittedTime = timeString.split(":");

      hour = int.tryParse(splittedTime[0])!;
      hour = hour != null ? hour : 0;

      minute = int.tryParse(splittedTime[1])!;
      minute = minute != null ? minute : 0;
    }

    var filterDate =
        DateTime.utc(date.year, date.month, date.day, hour, minute);

    var availableQuotaObject = product.timeSlots!.quotaAvailability?.firstWhere(
      (element) {
        return element.date == filterDate;
      },
      // orElse: () => null,
    );

    if (availableQuotaObject == null)
      return maxQuota != null && maxQuota < 0 ? 2147483647 : maxQuota;

    return availableQuotaObject.available ?? 0;
  }

  ///Returns the max quota from either the category, sub category, dailyQuota field in timeSlots, specific time slot, days or hours
  static int? getMaxQuota(
    Product product,
    DateTime date,
    String timeString,
    ProductCategory category,
    ProductSubCategory subCategory,
  ) {
    if (category == null) throw Exception("Category can not be null");

    if (category.quota != null) {
      if (category.quota! < 0) return 2147483647;

      return category.quota!;
    }

    if (subCategory != null && subCategory.quota != null) {
      if (subCategory.quota! < 0) return 2147483647;

      return subCategory.quota!;
    }

    if (product.timeSlots?.hasTimeSlots == false &&
        product.timeSlots?.dailyQuota != null) {
      if (product.timeSlots!.dailyQuota! < 0) return 2147483647;

      return product.timeSlots!.dailyQuota!;
    }

    var specialTimeSlot = product.timeSlots!.special?.firstWhere(
      (specialTimeSlotElement) =>
          GlobalDate.isSameDay(specialTimeSlotElement.date!, date),
      // orElse: () => null,
    );

    if (specialTimeSlot != null) {
      if (specialTimeSlot.quota != null) {
        return specialTimeSlot.quota! < 0 ? 2147483647 : specialTimeSlot.quota!;
      }

      var specialTimeSlotHoursEntry = specialTimeSlot.hours?.firstWhere(
        (specialTimeSlotHoursElement) =>
            specialTimeSlotHoursElement.time == timeString,
        // orElse: () => null,
      );

      if (specialTimeSlotHoursEntry != null &&
          specialTimeSlotHoursEntry.quota != null) {
        return specialTimeSlotHoursEntry.quota! < 0
            ? 2147483647
            : specialTimeSlotHoursEntry.quota;
      }
    }

    var maxQuotaFromRegularTimeSlots =
        getMaxQuotaFromRegularTimeSlots(product, date, timeString);

    if (maxQuotaFromRegularTimeSlots != null) {
      return maxQuotaFromRegularTimeSlots != null &&
              maxQuotaFromRegularTimeSlots < 0
          ? 2147483647
          : maxQuotaFromRegularTimeSlots;
    }

    return 0;
  }

  ///Returns max quota from regular time slots for a given product
  static int getMaxQuotaFromRegularTimeSlots(
    Product product,
    DateTime date,
    String timeString,
  ) {
    ProductTimeSlotsRegularDay? regularTimeSlotDay;

    product.timeSlots!.regular?.forEach((regularTimeSlotElement) {
      if (regularTimeSlotElement.intervalType ==
          ProductTImeSlotsRegularIntervalType.WEEK) {
        //Get weeks for time slot duration
        var weeks = BookingTimeQuotaUtil.getWeeksForRegularTimeSlot(
            regularTimeSlotElement);

        //Loop trough regular time slot depending on intervalRepeat (if intervalRepeat == 2, skip every other entry)
        for (var i = 0;
            i < weeks.length;
            i += regularTimeSlotElement.intervalRepeat!) {
          var weekDays = weeks[i];

          //Loop through days of regular time slot
          regularTimeSlotElement.days!.forEach(
            (productTimeSlotsRegularDay) {
              //Get date by weekday
              var localDate = weekDays.firstWhere(
                (weekDaysElement) =>
                    weekDaysElement.weekday == productTimeSlotsRegularDay.day,
                // orElse: () => null,
              );

              //Skip if date is null
              if (localDate == null) return null;

              //Skip if date is out of range
              if (localDate.isBefore(regularTimeSlotElement.startDate!) ||
                  (localDate.isAfter(regularTimeSlotElement.endDate!) &&
                      GlobalDate.isSameDay(
                              localDate, regularTimeSlotElement.endDate!) ==
                          false)) return null;

              if (localDate != null && GlobalDate.isSameDay(date, localDate)) {
                regularTimeSlotDay = productTimeSlotsRegularDay;
                return null;
              }
            },
          );
        }
      } else if (regularTimeSlotElement.intervalType ==
          ProductTImeSlotsRegularIntervalType.MONTH) {
        //Get months for time slot duration
        var months = BookingTimeQuotaUtil.getMonthsForRegularTimeSlot(
            regularTimeSlotElement);

        //Loop trough regular time slot depending on intervalRepeat (if intervalRepeat == 2, skip every other entry)
        for (var i = 0;
            i < months.length;
            i += regularTimeSlotElement.intervalRepeat!) {
          var daysInMonth = months[i];

          //Loop through days of regular time slot
          regularTimeSlotElement.days!.forEach(
            (productTimeSlotsRegularDay) {
              //Get week in month for which to apply time slot
              //0 = first week of month
              var weekInMonth =
                  ((productTimeSlotsRegularDay.day! - 1) / 7).floor();

              //Get weekday for week in month
              //E.g. productTimeSlotsRegularDay.day == 1 = first monday of month, productTimeSlotsRegularDay.day == 8 = second monday of month
              //Both return 1 as weekday
              var weekdayInWeekInMonth =
                  productTimeSlotsRegularDay.day! - (weekInMonth * 7);

              //Get date by weekday
              var localDate = daysInMonth.firstWhere(
                (daysInMonthElement) {
                  //Get local week in month
                  var localWeekInMonth =
                      ((daysInMonthElement.day - 1) / 7).floor();

                  //Check if week in month matches
                  var isSameWeekInMonth = localWeekInMonth == weekInMonth;

                  return daysInMonthElement.weekday == weekdayInWeekInMonth &&
                      isSameWeekInMonth;
                },
                // orElse: () => null,
              );

              //Skip if date is null
              if (localDate == null) return null;

              //Skip if date is out of range
              if (localDate.isBefore(regularTimeSlotElement.startDate!) ||
                  (localDate.isAfter(regularTimeSlotElement.endDate!) &&
                      GlobalDate.isSameDay(
                              localDate, regularTimeSlotElement.endDate!) ==
                          false)) return null;

              if (localDate != null && GlobalDate.isSameDay(date, localDate)) {
                regularTimeSlotDay = productTimeSlotsRegularDay;
                return null;
              }
            },
          );
        }
      }
    });

    if (regularTimeSlotDay == null) return 0;

    if (regularTimeSlotDay!.quota! != null) return regularTimeSlotDay!.quota!;

    var regularTimeSlotDayHour = regularTimeSlotDay!.hours!.firstWhere(
      (regularTimeSlotDayHoursElement) =>
          regularTimeSlotDayHoursElement.time == timeString,
      // orElse: () => null,
    );

    if (regularTimeSlotDayHour == null) return 0;

    if (regularTimeSlotDayHour.quota != null)
      return regularTimeSlotDayHour.quota!;

    return 0;
  }

  ///Get list of weeks (List<DateTime>) for regular time slot
  static List<List<DateTime>> getWeeksForRegularTimeSlot(
      ProductTimeSlotsRegular productTimeSlotsRegular) {
    List<List<DateTime>> weekList = [];

    //Get first and last week
    List<DateTime> firstWeek = GlobalDate.getWeekFromDate(
      productTimeSlotsRegular.startDate!,
    );
    List<DateTime> lastWeek = GlobalDate.getWeekFromDate(
      productTimeSlotsRegular.endDate!,
    );

    //Calcualte difference between start and end week without respecting time (HH:mm)
    var startEndDifference = GlobalDate.getDateWithoutTime(
      lastWeek[0],
    ).difference(
      GlobalDate.getDateWithoutTime(
        firstWeek[0],
      ),
    );

    //Add first week to list
    weekList.add(firstWeek);

    //Generate weeks in beetween first and last
    for (var i = 1; i < startEndDifference.inDays / 7; i++) {
      var week = GlobalDate.getWeekFromDate(
        productTimeSlotsRegular.startDate!.add(
          Duration(days: i * 7),
        ),
      );

      weekList.add(week);
    }

    //Add last week to list
    weekList.add(lastWeek);

    return weekList;
  }

  ///Get list of months (List<DateTime>) for regular time slot
  static List<List<DateTime>> getMonthsForRegularTimeSlot(
      ProductTimeSlotsRegular productTimeSlotsRegular) {
    List<List<DateTime>> monthList = [];

    //Get first and last moth
    List<DateTime> firstMonth = GlobalDate.getMonthFromDate(
      productTimeSlotsRegular.startDate!,
    );
    List<DateTime> lastMonth = GlobalDate.getMonthFromDate(
      productTimeSlotsRegular.endDate!,
    );

    //Calculate difference between start and end month
    var differenceInYears = lastMonth[0].year - firstMonth[0].year;
    var differenceInMonths = (lastMonth[0].month - firstMonth[0].month) +
        differenceInYears.floor() * 12;

    //Add first month to list
    monthList.add(firstMonth);

    //Generate months in beetween first and last
    for (var i = 1; i < differenceInMonths; i++) {
      var yearsInFuture =
          ((productTimeSlotsRegular.startDate!.month + i) / 12).floor();

      var month = GlobalDate.getMonthFromDate(
        DateTime(
          productTimeSlotsRegular.startDate!.year + yearsInFuture,
          productTimeSlotsRegular.startDate!.month + i - (yearsInFuture * 12),
          1,
        ),
      );

      monthList.add(month);
    }

    //Add last month to list
    monthList.add(lastMonth);

    return monthList;
  }

  ///Returns a bool wether a given product is available on a given date
  static bool? isProductAvailableOnDate(Product product, DateTime date) {
    if (product.timeSlots != null && product.timeSlots!.hasTimeSlots == false)
      return true;

    var specialOpen = product.timeSlots!.special?.any(
      (specialTimeSlotElement) {
        return GlobalDate.isSameDay(
          specialTimeSlotElement.date!,
          date,
        );
      },
    );

    if (specialOpen!) return true;

    return product.timeSlots!.regular?.any((regularTimeSlotElement) {
      if (regularTimeSlotElement.intervalType ==
          ProductTImeSlotsRegularIntervalType.WEEK) {
        //Get weeks for time slot duration
        var weeks = BookingTimeQuotaUtil.getWeeksForRegularTimeSlot(
            regularTimeSlotElement);

        //Loop trough regular time slot depending on intervalRepeat (if intervalRepeat == 2, skip every other entry)
        for (var i = 0;
            i < weeks.length;
            i += regularTimeSlotElement.intervalRepeat!) {
          var weekDays = weeks[i];

          //Loop through days of regular time slot
          var isAvailable = regularTimeSlotElement.days!.any(
            (productTimeSlotsRegularDay) {
              //Get date by weekday
              var localDate = weekDays.firstWhere(
                (weekDaysElement) =>
                    weekDaysElement.weekday == productTimeSlotsRegularDay.day,
                // orElse: () => null,
              );

              if (localDate == null) return false;

              return GlobalDate.isSameDay(date, localDate);
            },
          );

          if (isAvailable) return true;
        }
      } else if (regularTimeSlotElement.intervalType ==
          ProductTImeSlotsRegularIntervalType.MONTH) {
        //Get months for time slot duration
        var months = BookingTimeQuotaUtil.getMonthsForRegularTimeSlot(
            regularTimeSlotElement);

        //Loop trough regular time slot depending on intervalRepeat (if intervalRepeat == 2, skip every other entry)
        for (var i = 0;
            i < months.length;
            i += regularTimeSlotElement.intervalRepeat!) {
          var daysInMonth = months[i];

          //Loop through days of regular time slot
          var isAvailable = regularTimeSlotElement.days!.any(
            (productTimeSlotsRegularDay) {
              //Get week in month for which to apply time slot
              //0 = first week of month
              var weekInMonth =
                  ((productTimeSlotsRegularDay.day! - 1) / 7).floor();

              //Get weekday for week in month
              //E.g. productTimeSlotsRegularDay.day == 1 = first monday of month, productTimeSlotsRegularDay.day == 8 = second monday of month
              //Both return 1 as weekday
              var weekdayInWeekInMonth =
                  productTimeSlotsRegularDay.day! - (weekInMonth * 7);

              //Get date by weekday
              var localDate = daysInMonth.firstWhere(
                (daysInMonthElement) {
                  //Get local week in month
                  var localWeekInMonth =
                      ((daysInMonthElement.day - 1) / 7).floor();

                  //Check if week in month matches
                  var isSameWeekInMonth = localWeekInMonth == weekInMonth;

                  return daysInMonthElement.weekday == weekdayInWeekInMonth &&
                      isSameWeekInMonth;
                },
                // orElse: () => null,
              );

              if (localDate == null) return false;

              return GlobalDate.isSameDay(date, localDate);
            },
          );

          if (isAvailable) return true;
        }
      }

      return false;
    });
  }
}

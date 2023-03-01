class VendorBookingStatisticModel {
  DateTime? startDate;
  DateTime? endDate;
  double? revenue;
  int? numberOfBookings;
  List<ActivityBookingDataItem>? activityBookingDataList;
  List<DailyRevenueItem>? dailyRevenueItems;
  VendorBookingStatisticModel(
      {this.revenue,
      this.activityBookingDataList,
      this.endDate,
      this.numberOfBookings,
      this.startDate,
      this.dailyRevenueItems});

  factory VendorBookingStatisticModel.fromJson(dynamic json) {
    return VendorBookingStatisticModel(
      startDate: DateTime.tryParse(json["startDate"]),
      endDate: DateTime.tryParse(json["endDate"]),
      numberOfBookings: json["numberOfBookings"],
      revenue: double.tryParse(json["revenue"].toString()),
      activityBookingDataList: json["activityBookingDataList"]
          ?.map<ActivityBookingDataItem>((activityDataItem) =>
              ActivityBookingDataItem.fromJson(activityDataItem))
          ?.toList(),
      dailyRevenueItems: json["dailyRevenue"]
          ?.map<DailyRevenueItem>(
            (dailyRevenueItem) => DailyRevenueItem.fromJson(dailyRevenueItem),
          )
          ?.toList(),
    );
  }
}

class ActivityBookingDataItem {
  String? activityTitle;
  List<ProductDataItem>? productDataList;

  ActivityBookingDataItem({this.activityTitle, this.productDataList});

  factory ActivityBookingDataItem.fromJson(dynamic json) {
    return ActivityBookingDataItem(
        activityTitle: json["activityTitle"],
        productDataList: json["productDataList"]
            ?.map<ProductDataItem>(
              (productData) => ProductDataItem.fromJson(productData),
            )
            ?.toList());
  }
}

class ProductDataItem {
  int? bookingAmount;
  String? productTitle;
  double? revenue;
  ProductDataItem({this.bookingAmount, this.productTitle, this.revenue});

  factory ProductDataItem.fromJson(dynamic json) {
    return ProductDataItem(
        bookingAmount: json["bookingAmount"],
        productTitle: json["productTitle"],
        revenue: double.tryParse(json["revenue"].toString()));
  }
}

class DailyRevenueItem {
  DateTime? date;
  double? revenue;
  int? bookingAmount;

  DailyRevenueItem({
    this.date,
    this.bookingAmount,
    this.revenue,
  });

  factory DailyRevenueItem.fromJson(dynamic json) {
    return DailyRevenueItem(
      bookingAmount: json["bookings"],
      date: DateTime.tryParse(json['date']),
      revenue: double.tryParse(json["revenue"].toString()),
    );
  }
}

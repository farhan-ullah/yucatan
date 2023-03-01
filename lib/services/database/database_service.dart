import 'dart:convert';

import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/invoice_address_model.dart';
import 'package:yucatan/models/local_search_model.dart';
import 'package:yucatan/models/schedule_notification.dart';
import 'package:yucatan/models/user_model.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/booking_detailed_multi_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/status_service.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final String? bookingBoxName = "booking";
  static final String? bookingDetailedBoxName = "bookingDetailedBox";
  static final String? localSearchHistory = "localSearchHistory";
  static const scheduleNotificationBoxName = "scheduleNotificationBoxName";

  static final String? _hiveKey = "HiveKey2";

  static Future<void> initHive() async {
    Hive.registerAdapter(BookingProductPropertyTypeAdapter());
    Hive.registerAdapter(BookingProductPropertyAdapter());
    Hive.registerAdapter(ProductAdditionalServiceAdapter());
    Hive.registerAdapter(BookingProductAdapter());
    Hive.registerAdapter(AdditionalServiceInfoTicketAdapter());
    Hive.registerAdapter(BookingTicketAdapter());
    Hive.registerAdapter(InvoiceAddressModelAdapter());
    Hive.registerAdapter(BookingModelAdapter());
    Hive.registerAdapter(ActivityModelLocationAdapter());
    Hive.registerAdapter(ActivityModelActivityDetailsAdapter());
    Hive.registerAdapter(ActivityModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(BookingDetailedModelAdapter());
    Hive.registerAdapter(LocalSearchModelAdapter());
    Hive.registerAdapter(ScheduleNotificationAdapter());

    var storage = FlutterSecureStorage();
    if (!await storage.containsKey(key: _hiveKey!)) {
      List<int>? key = Hive.generateSecureKey();
      await storage.write(key: _hiveKey!, value: base64UrlEncode(key));
    }
    var encryptionKey = base64Url.decode((await storage.read(key: _hiveKey!))!);

    await Hive.initFlutter();

    await Hive.openBox(
      bookingDetailedBoxName!,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await Hive.openBox<LocalSearchModel>(localSearchHistory!);
    await Hive.openBox<ScheduleNotification>(scheduleNotificationBoxName);
  }

  static void updateDatabase() async {
    try {
      UserLoginModel? user = await UserProvider.getUser();
      BookingService.getAllForUserDetailed(user!.sId!).then((value) {
        if (value != null && value.data != null) storeBooking(value.data!);
      });
    } catch (exception) {
      print("Storing in database failed");
      print(exception.toString());
    }
  }

  static void storeBooking(List<BookingDetailedModel> models) async {
    bool connected = await StatusService.isConnected();
    if (!connected) return;

    var bookingBox = Hive.box(bookingDetailedBoxName!);
    bookingBox.put("bookingList", models);
  }

  static List<BookingDetailedModel> getAll() {
    var bookingBox = Hive.box(bookingDetailedBoxName!);
    var list = bookingBox.get("bookingList");
    List<BookingDetailedModel>? bookingDetailedList;
    if (list != null)
      bookingDetailedList = list.cast<BookingDetailedModel>();
    else
      bookingDetailedList = null;
    return bookingDetailedList!;
  }

  static Future<int> clearStoredBookings() async {
    var bookingBox = await Hive.openBox(bookingDetailedBoxName!);
    return bookingBox.clear();
  }

  static Future<BookingDetailedMultiResponseEntity> getBookingResponse() {
    BookingDetailedMultiResponseEntity response =
        BookingDetailedMultiResponseEntity();
    var bookings = getAll();
    response.data = bookings;
    if (bookings != null) {
      response.status = 200;
      response.setError(null);
    } else {
      response.status = 400;
      var error = ApiError();
      error.message = "No bookings found in database!";
      response.setError(error);
    }
    return Future.sync(() => response);
  }

  static void setLastSearchQuery(LocalSearchModel localSearchModel) async {
    var bookingBox = await Hive.openBox<LocalSearchModel>(localSearchHistory!);
    bookingBox.put(localSearchModel.index, localSearchModel);
  }

  static Future<List<LocalSearchModel>> getLastSearchQuery() async {
    var notificationBox =
        await Hive.openBox<LocalSearchModel>(localSearchHistory!);
    if (notificationBox.isNotEmpty) {
      return notificationBox.values.toList().cast<LocalSearchModel>();
    }
    return [];
  }

  static Future<int> clearLocalSearchHistory() async {
    var notificationBox =
        await Hive.openBox<LocalSearchModel>(localSearchHistory!);
    return notificationBox.clear();
  }

  static void setScheduledNotification(
      ScheduleNotification notification) async {
    var notificationBox =
        await Hive.openBox<ScheduleNotification>(scheduleNotificationBoxName);
    notificationBox.put(notification.id, notification);
  }

  static Future<List<ScheduleNotification>>
      getScheduledNotificationsList() async {
    var notificationBox =
        await Hive.openBox<ScheduleNotification>(scheduleNotificationBoxName);
    if (notificationBox.isNotEmpty) {
      return notificationBox.values.toList();
    }
    return [];
  }

  static Future<ScheduleNotification> getScheduledNotification(
      String id) async {
    var notificationBox =
        await Hive.openBox<ScheduleNotification>(scheduleNotificationBoxName);
    return notificationBox.get(id)!;
  }

  static Future<void> deleteScheduledNotification(String id) async {
    var notificationBox =
        await Hive.openBox<ScheduleNotification>(scheduleNotificationBoxName);
    return notificationBox.delete(id);
  }

  static Future<int> deleteAllScheduledNotification() async {
    var notificationBox =
        await Hive.openBox<ScheduleNotification>(scheduleNotificationBoxName);
    return notificationBox.clear();
  }

  static Future<void> clearDatabase() async {
    await clearStoredBookings();
    await deleteAllScheduledNotification();
    await clearLocalSearchHistory();
  }

// static void storeActivity(String activityId) async {
//   ActivitySingleResponse activity =
//       await ActivityService.getActivity(activityId);
//   if (activity.data != null) {
//     var bookingBox = Hive.box(bookingBoxName);
//     bookingBox.put(activityId, activity.data);
//   }
// }

// static ActivityModel getActivity(String activityId) {
//   var bookingBox = Hive.box(bookingBoxName);
//   var activity = bookingBox.get(activityId) as ActivityModel;
//   return activity;
// }

//   static Future<ActivitySingleResponse> getActivityByIdResponse(
//       String activityId) {
//     ActivitySingleResponse response = ActivitySingleResponse();
//     ActivityModel activity = getActivity(activityId);
//     response.data = activity;
//     if (activity != null) {
//       response.data.thumbnail = FileModel();
//       response.data.thumbnail.publicUrl = "";
//       response.status = 200;
//       response.errors = null;
//     } else {
//       response.status = 400;
//       var error = ApiError();
//       error.message = "No bookings found in database!";
//       response.errors = error;
//     }
//     return Future.sync(() => response);
//   }
}

import 'dart:convert';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_screen.dart';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/booking_detailed_multi_response.dart';
import 'package:yucatan/services/response/booking_detailed_single_response_entity.dart';
import 'package:yucatan/services/response/booking_multi_response_entity.dart';
import 'package:yucatan/services/response/booking_single_response_entity.dart';
import 'package:yucatan/services/response/product_demand_response.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/services/response/transaction_multi_response_entity.dart';

class BookingService extends BaseService {
  // this class is static only
  BookingService._() : super(BaseService.defaultURL + '/bookings');

  /// Query all bookings
  static Future<BookingMultiResponseEntity?> getAll() async {
    var httpData = (await BookingService._().get(''))!.body;
    if (httpData != null) {
      return BookingMultiResponseEntity().fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }

  /// Query all bookings for the logged in user
  static Future<BookingMultiResponseEntity?> getAllForUser(
      String userId) async {
    var httpData = (await BookingService._().get('/user/' + userId))!.body;
    if (httpData != null) {
      return BookingMultiResponseEntity().fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }

  static Future<bool> deleteBooking(String bookingId) async {
    var httpData = (await BookingService._().delete('/$bookingId'))!.body;

    if (httpData != null) {
      return json.decode(httpData)['status'] == 200;
    } else {
      return false;
    }
  }

  static Future<BookingDetailedMultiResponseEntity?> getAllForUserDetailed(
      String userId) async {
    var httpData =
        (await BookingService._().get('/user/$userId/detailed'))!.body;
    if (httpData != null) {
      return BookingDetailedMultiResponseEntity.fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }

  static Future<BookingDetailedSingleResponseEntity>? getBoookingDetailed(
      String id) async {
    var httpData = (await BookingService._().get('/$id/detailed'))!.body;

      return BookingDetailedSingleResponseEntity.fromJson(
          json.decode(httpData));

  }

  /// Queries an Booking by the given [id]
  /// [id] internal (object-)ID of the booking (BookingModel.sId)
  static Future<BookingSingleResponseEntity>? getBooking(String id) async {
    var httpData = (await BookingService._().get(id))!.body;

      return BookingSingleResponseEntity().fromJson(json.decode(httpData));

  }

  /// Queries an Booking by the given qr code reference
  /// [id] internal (object-)ID of the booking (BookingModel.sId)
  static Future<BookingSingleResponseEntity?> getBookingByQrCodeReference(
      String qrCodeReference) async {
    var httpData =
        (await BookingService._().get('/qr/' + qrCodeReference))!.body;
    if (httpData != null) {
      return BookingSingleResponseEntity().fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }

  // Set Ticket to used
  static Future<BookingSingleResponseEntity?> setTicketToUsedForQr(
      String qrCodeReference) async {
    var httpData =
        (await BookingService._().get('/useticket/' + qrCodeReference))!.body;
    if (httpData != null) {
      return BookingSingleResponseEntity().fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }

  // Get demand for date range
  static Future<ProductDemandResponse?> getDemandForDateRange(
      DateParameters dateParameters) async {
    Map<String, String> queryParams = Map();

    if (isNotNullOrEmpty(dateParameters.fromDate)) {
      queryParams.putIfAbsent('dateFrom', () => dateParameters.fromDate);
    }
    if (isNotNullOrEmpty(dateParameters.fromDate)) {
      queryParams.putIfAbsent('dateTo', () => dateParameters.toDate.toString());
    }

    String query = Uri(queryParameters: queryParams).query;
    var httpData = (await BookingService._().get('/demand?$query'))!.body;
    if (httpData != null) {
      return ProductDemandResponse.fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }

  // Get transations for date range
  static Future<TransactionMultiResponseEntity>? getTransactionsForDateRange(
      {DateTime? dateFrom, DateTime? dateTo}) async {
    Map<String, String> queryParams = Map();

    if (dateFrom != null) {
      queryParams.putIfAbsent('dateFrom', () => dateFrom.toIso8601String());
    }
    if (dateTo != null) {
      queryParams.putIfAbsent('dateTo', () => dateTo.toIso8601String());
    }

    String urlQuery = Uri(queryParameters: queryParams).query;
    var httpData =
        (await BookingService._().get('/transactions' + '?$urlQuery'))!.body;

      return TransactionMultiResponseEntity.fromJson(json.decode(httpData));

  }

  static Future<BookingSingleResponseEntity>? acceptRequest(
      String id, String message) async {
    dynamic body;
    if (message != "") {
      body = json.encode({"requestNote": message});
    }
    var httpData =
        (await BookingService._().post('/$id/accept-request', body))!.body;

      return BookingSingleResponseEntity().fromJson(json.decode(httpData));

  }

  static Future<BookingSingleResponseEntity?> denyRequest(
      String id, String message) async {
    dynamic body = json.encode({"requestNote": message});
    var httpResponse =
        (await BookingService._().post('/$id/deny-request', body));
    var httpData = httpResponse!.body;
    if (httpData != null) {
      return BookingSingleResponseEntity().fromJson(json.decode(httpData));
    } else {
      return null;
    }
  }
}

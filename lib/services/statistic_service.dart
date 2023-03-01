import 'dart:convert';

import 'base_service.dart';
import './response/vendor_booking_statistic_single_response_entity.dart';

class StatisticService extends BaseService {
  // this class is static only
  StatisticService._()
      : super(BaseService.defaultURL + '/statistics');

  static Future<VendorBookingStatisticSingleResponseEntity?>
      getVendorDetailedStatistic(String dateFrom, String dateTo) async {
    Map<String, String> queryParams = Map();

    if (dateFrom != null) {
      queryParams.putIfAbsent('dateFrom', () => dateFrom);
    }
    if (dateTo != null) {
      queryParams.putIfAbsent('dateTo', () => dateTo);
    }
    String urlQuery = Uri(queryParameters: queryParams).query;
    var httpData =
        (await new StatisticService._().get('/vendor/details' + '?$urlQuery'))
            !.body;
    if (httpData != null) {
      return VendorBookingStatisticSingleResponseEntity.fromJson(
          json.decode(httpData));
    } else
      return null;
  }
}

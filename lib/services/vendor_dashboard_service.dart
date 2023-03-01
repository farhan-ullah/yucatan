import 'dart:convert';

import 'base_service.dart';
import 'response/vendor_dashboard_response.dart';

class VendorDashboardService extends BaseService {
  VendorDashboardService._()
      : super(BaseService.defaultURL + '/statistics/vendor/dashboard');

  /// get statistic data for vendor dashboard bookings
  static Future<VendorDashboardResponse?> getVendorDashboardStats() async {
    var httpData = (await new VendorDashboardService._().get(''))?.body;
    if (httpData != null) {
      return new VendorDashboardResponse.fromJson(json.decode(httpData));
    } else
      return null;
  }
}

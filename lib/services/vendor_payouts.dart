import 'dart:convert';
import 'package:yucatan/services/response/vendor_next_payout_response.dart';

import 'response/vendor_payouts_response.dart';
import 'base_service.dart';
import 'vendor_accountbalance_response.dart';

class VendorPayouts extends BaseService {
  // this class is static only
  VendorPayouts._() : super(BaseService.defaultURL + '/');

  //payouts/vendor
  static Future<VendorPayoutsResponse?> getPayoutsForVendor() async {
    var httpData = (await new VendorPayouts._().get('/payouts/vendor/'));

    if (httpData != null) {
      return new VendorPayoutsResponse.fromJson(json.decode(httpData.body));
    } else
      return null;
  }

  ///GET for accoutBalance vendor in realtime
  static Future<VendorAccountBalanceResponse?>
      getAccountBalanceForVendor() async {
    var httpData = (await new VendorPayouts._().get('vendors/accountbalance'));

    if (httpData != null) {
      return new VendorAccountBalanceResponse.fromJson(
          json.decode(httpData.body));
    } else
      return null;
  }

  ///Get the next payout (future) for vendor
  static Future<VendorNextPayoutResponse?> getNextPayoutForVendor() async {
    var httpData =
        (await new VendorPayouts._().get('/payouts/vendor/nextpayout'));
    if (httpData != null) {
      return new VendorNextPayoutResponse.fromJson(json.decode(httpData.body));
    } else
      return null;
  }
}

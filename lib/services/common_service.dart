import 'dart:convert';
import 'package:yucatan/services/base_service.dart';
import 'package:yucatan/services/response/legal_docwebpage_response.dart';
import 'package:yucatan/services/response/webpage_single_response.dart';

class CommonService extends BaseService {
  CommonService._() : super(BaseService.defaultURL + '/common');

  static Future<WebPageSingleResponseEntity?> getWebPageUrl(String page) async {
    var httpData = (await new CommonService._().get(page))!.body;
    if (httpData != null) {
      return new WebPageSingleResponseEntity.fromJson(json.decode(httpData));
    } else
      return null;
  }

  static Future<LegalDocWebPageResponse?> getLegalDocWebPageUrl() async {
    var httpData = (await new CommonService._().get("/legalUrls"))!.body;
    //print(httpData);
    if (httpData != null) {
      return new LegalDocWebPageResponse.fromJson(json.decode(httpData));
    } else
      return null;
  }
}

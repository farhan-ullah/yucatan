import 'dart:convert';

import 'package:yucatan/models/contact_model.dart';
import 'package:yucatan/services/response/contact_response.dart';

import 'base_service.dart';

class ContactService extends BaseService {
  ContactService._() : super(BaseService.defaultURL + '/contact');

  ///send Messages to the Appventure support. - for user which are not logged in
  static Future<ContactResponse?> sendContactQuery(
      ContactModel contactModel, bool isUserLoggedIn) async {
    dynamic body = json.encode({
      'firstname': contactModel.firstname,
      'lastname': contactModel.lastname,
      'phone': contactModel.phone,
      'email': contactModel.email,
      'message': contactModel.message,
    });
    var httpData = (await new ContactService._().post(
        isUserLoggedIn ? '' : '/public',
        body)); //(for user which are not logged in)
    if (httpData != null) {
      ContactResponse contactResponse =
          new ContactResponse.fromJson(json.decode(httpData.body));
      contactResponse.statusCodeApiRequest = httpData.statusCode;
      return contactResponse;
    } else
      return null;
  }
}

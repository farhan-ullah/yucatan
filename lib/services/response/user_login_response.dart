import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/generated/json/base/json_filed.dart';
import 'package:yucatan/services/response/api_error.dart';

class UserLoginResponse with JsonConvert<UserLoginResponse> {
  int? status;
  UserLoginResponseData? data;
  ApiError? errors;
}

class UserLoginResponseData with JsonConvert<UserLoginResponseData> {
  String? token;
  late UserLoginModel user;
}

class UserLoginModel with JsonConvert<UserLoginModel> {
  @JSONField(name: "_id")
  String? sId;
  String? refreshToken;
  String? email;
  String? role;

  String? username;
  String firstname = '';
  String lastname = '';
  String phone = '';
  String street = '';
  String housenumber = '';
  String zipcode = '';
  String city = '';

  String countryISO2 = '';
  String areaCode = '';

  String? createdAt;
  String? updatedAt;
  @JSONField(name: "__v")
  int? iV;

  static String? _pseudoRole;

  /// sets pseudo role "User" for current account
  void switchToUserRole() {
    _pseudoRole = "User";
  }

  /// restores the actual role of the current account
  void switchToDefaultRole() {
    _pseudoRole = role;
  }

  /// Returns the users pseudo role if set. Otherwise the default role will be returned
  String? getRole() => _pseudoRole ?? role;

  /// returns true if the current account is a Vendor with a pseudo role of User
  bool isVendorPseudoUser() => getRole() == "User" && role == "Vendor";
}
